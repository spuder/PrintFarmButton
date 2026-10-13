# AGENTS.md — PrintFarmButton

Guidance for AI agents and contributors working in this repo. Read this before editing firmware, workflows, or the web flasher.

## What this is

PrintFarmButton is an open-source physical button for 3D-printer farms. An ESP32 with a WS2812 RGB LED strip and a pushbutton shows printer state from [Printago](https://printago.io) and marks the bed clear/ready on press.

- Firmware: ESPHome (ESP-IDF framework) — no Arduino/C++ project files; behaviour is ESPHome YAML + inline C++ lambdas.
- Web: two static pages (`index.html`, `flash.html`) deployed to GitHub Pages. No build step, no package manager, no tests.
- Hardware: STL enclosures + Fritzing schematic in `hardware/`.

LED state mapping (source of truth: `firmware/esphome/conf.d/cloud_printago.yaml`, script `update_led_color`):

| LED | Meaning | Condition |
|-----|---------|-----------|
| Off | Offline / unhandled state | `!isOnline`, or `confirmedReady && !isAvailable` |
| Red (solid) | Error / warning | `printer_has_error_sensor` or `printer_has_warning_sensor` |
| Green + `Left2Right` | Downloading / preparing | `is_downloading` (Printago state `PREPARE`) |
| Blue (solid) | Ready / idle | `confirmedReady && isAvailable` |
| Magenta (`Pulse`) | Finished, waiting for bed clear | `!confirmedReady && isAvailable` |
| Green (solid) | Printing / busy | `!isAvailable && !confirmedReady` |
| Rainbow | Boot, and on MQTT disconnect | `common.yaml` `on_boot`, `conf.d/mqtt.yaml` `on_disconnect` |

## Repo layout

```
.
├── index.html / flash.html   # GitHub Pages site: provisioning guide / ESP Web Tools flasher
├── release.sh                # Interactive git-semver tagging helper (creates vX.Y.Z tags)
├── DEV.md / TODO             # Printago REST/MQTT notes and the running task list
├── firmware/
│   ├── output/               # GENERATED: *.factory.bin / *.ota.bin (+ .md5) and manifest-*.json — committed by CI, do not hand-edit
│   └── esphome/
│       ├── Makefile          # Local build/run targets (system ESPHome or Podman)
│       ├── README.md         # One-line Podman compile example (may lag the Makefile)
│       ├── common.yaml       # Shared: esphome/ota/api/http_request/improv, packages, boot behaviour
│       ├── <board>.yaml      # One entrypoint per board (see table below) — substitutions + board + packages
│       └── conf.d/           # Feature modules included as ESPHome packages
│           ├── cloud_printago.yaml  # Printago REST + MQTT state, LED logic, all scripts (~850 lines, the core file)
│           ├── cloud.yaml           # Cloud Connection select (currently only "Printago")
│           ├── mqtt.yaml            # MQTT client, TLS CA bundle, connect/disconnect handlers
│           ├── mqtt_printago.yaml   # MQTT Endpoint/Port text entities (defaults realtime.printago.io:8883)
│           ├── led.yaml             # esp32_rmt_led_strip light + Rainbow/Pulse/Left2Right effects
│           ├── button.yaml / button_internal.yaml / button_m5.yaml  # GPIO button variants
│           ├── wifi.yaml            # WiFi + fallback AP (ssid "PrintFarmButton") + captive portal
│           ├── web_server.yaml      # Web UI on port 80, sorting groups (cloud/bambu/printago/updates)
│           ├── update.yaml          # http_request OTA update entity + auto-update workaround interval
│           └── version.yaml         # substitutions.version — overwritten by CI on release, do not edit manually
├── hardware/                 # *.stl enclosures, Schematic.fzz
├── images/                   # README/flasher images (paths with spaces exist — quote them)
└── .github/
    ├── workflows/esphome-build.yml  # Tag-triggered firmware builds + artifact/manifest deploy to main
    ├── workflows/docs.yml           # Deploys the Pages site on index/flash/docs/images changes
    └── instructions/                # Copilot instructions + example MQTT payloads
```

## Board variants

Each board file sets `button_gpio` / `led_gpio` / `num_leds` / `manifest_file` substitutions, the ESP32 board/framework, then includes `common.yaml` plus a button module. Pin behaviour is *not* uniform — check the board file before assuming a pin.

| Entrypoint | Board | Button GPIO | LED GPIO | LEDs | Button module | Notes |
|------------|-------|-------------|----------|------|---------------|-------|
| `esp32s3-zero.yaml` | `esp32-s3-devkitc-1` | 1 | 2 | 13 | `button.yaml` + `button_internal.yaml` (GPIO0) | Only non-M5 board with an internal button |
| `esp32s3-supermini.yaml` | `esp32-s3-devkitc-1` | 13 | 12 | 13 | `button.yaml` | |
| `esp32c3-zero.yaml` | `esp32-c3-devkitm-1` | 0 | 1 | 13 | `button.yaml` | |
| `esp32c3-supermini.yaml` | `esp32-c3-devkitm-1` | 4 | 3 | 13 | `button.yaml` | |
| `atom-matrix.yaml` | `m5stack-atom` | 39 (internal) | 27 | 24 | `button_m5.yaml` | M5 button has no pull-up/down; ATOM Matrix panel is 5×5 |

Buttons: external button uses `INPUT_PULLDOWN`, internal uses `INPUT_PULLUP` + `inverted`, M5 uses neither. All use 100 ms `delayed_on`/`delayed_off` debounce and call script `mark_printer_ready` on press.

Untracked experimental board files (`atom-lite.yaml`, `atoms3*.yaml`, `m5stack-nanoc6.yaml`, `m5stamp-pico.yaml`) exist in some working trees — they are not built by CI and not part of the release matrix.

## Build, validate, flash

Prerequisites: ESPHome **2025.7.0** (pinned in CI as `ESPHOME_VERSION` and `common.yaml` `min_version`; the Podman image in the Makefile uses the same version).

```bash
cd firmware/esphome

# Validate config without compiling (fastest check — run for every board you touch)
esphome config esp32s3-zero.yaml

# Compile / compile+upload over serial, system ESPHome
make build-s3-zero        # also: build-s3-mini, build-c3-zero, build-c3-mini, build-atom-matrix
make run-s3-zero          # esphome run (compile + upload + logs)

# Same via Podman (PlatformIO cache persists in .esphome/platformio)
ESPHOME_MODE=podman make build-s3-zero

make clean                # removes .esphome/build/printfarmbutton* and .esphome/.storage
```

- There is **no test suite**. `esphome config <board>.yaml` for all five boards is the minimum verification for YAML changes; a full `compile` is the real check for lambda (C++) changes.
- Browser flashing: `flash.html` uses ESP Web Tools (`esp-web-tools@10.0.0`) and loads manifests from `https://raw.githubusercontent.com/spuder/PrintFarmButton/main/firmware/output/manifest-*.json`. Zero boards share `manifest-zero.json`, SuperMini boards share `manifest-supermini.json` (chipFamily inside selects C3 vs S3).
- OTA: devices check their `${manifest_file}` hourly (`conf.d/update.yaml`) and auto-install when the Auto Update switch is on (3-minute interval workaround — see the comments there before "fixing" it).

## Release flow

1. `./release.sh` (needs `git-semver`) creates and pushes an annotated `vX.Y.Z` tag.
2. `.github/workflows/esphome-build.yml` builds all five boards (ESP32-C3 ×2, ESP32-S3 ×2, ATOM Matrix), generates `.md5` files, rewrites `conf.d/version.yaml` from the tag, assembles `firmware/output/manifest-*.json`, and bot-commits binaries + manifests + `version.yaml` back to `main` (`[skip ci]`).
3. `.github/workflows/docs.yml` redeploys GitHub Pages when `index.html`/`flash.html`/`docs/**`/`images/**` change.

⚠️ Tag-format trap: the build workflow triggers on tags matching `[0-9]+.[0-9]+.[0-9]+*` (no `v` prefix), while `release.sh` creates `vX.Y.Z` tags, and the repo has both tag styles. If a release does not build, check the tag name first.

## Conventions — read before editing

- **ESPHome packages:** board files only carry substitutions + `esp32:` + package includes. Shared behaviour goes in `common.yaml`; feature changes go in the owning `conf.d/*.yaml` module. Keep the package keys in `common.yaml` stable — boards and modules cross-reference entity IDs.
- **Entity IDs and names are API contracts.** Template `text` entities in `cloud_printago.yaml` / `mqtt_printago.yaml` carry `#This name is the key for the rest api, do not change`. The web UI and `index.html` curl commands address them as `/text/store_id/set`, `/text/api_key/set`, `/text/printer_id/set`, `/text/mqtt_endpoint/set`. Do not rename entities/IDs without updating `index.html`, `DEV.md`, and `.github/instructions/` together.
- **Printago data split (see `DEV.md`):** REST (`api.printago.io/v1/printers…`, `ApiKey` + `x-printago-storeid` headers) returns `confirmedReady`/`isAvailable`/`isOnline`; MQTT topic `stores/<storeid>/printer-stats/<printer>` gives `isOnline`/`isAvailable`/health/state, and `stores/<storeid>/entities/printers` (no per-printer suffix, not retained) gives `confirmedReady`. Both transports are required for full state.
- **State lives in template binary sensors** (`printer_is_online_sensor`, `printer_is_available_sensor`, `printer_confirmed_ready_sensor`, `printer_has_error_sensor`, `printer_has_warning_sensor`, `is_downloading` in `cloud_printago.yaml`). Publish to them with `publish_state(...)`; every `on_state` calls `update_led_color`. All Printago scripts use `mode: queued`.
- **Credentials are runtime config, not secrets.yaml.** API key, Store ID, Printer ID, MQTT endpoint/port are `restore_value: true` template text entities set from the device web UI (or the curl commands generated by `index.html`). MQTT username/password/client_id are derived in lambdas (username = Store ID, password = API key, client_id = `apiclient_<storeid>_<mac suffix>`). `firmware/esphome/secrets.yaml` is only a CI placeholder (workflow touches an empty file) — never commit real credentials.
- **TLS material is embedded:** `conf.d/mqtt.yaml` contains a pinned CA bundle and `common.yaml` sets `http_request: verify_ssl: false`. Treat either change as security-sensitive and flag it in review.
- **Forked component:** `common.yaml` loads `template` from `https://github.com/spuder/esphome` ref `template_select_options` (`refresh: 0s`) for dynamic select options. Changes to printer-select behaviour may live in that fork, not this repo.
- **Generated files:** never hand-edit `firmware/output/*` or `conf.d/version.yaml`. Never edit `firmware/esphome/.esphome/` (build cache).
- **Web pages are dependency-free vanilla HTML/CSS/JS.** Keep them as single files with inline `<style>`/`<script>`; third-party code loads from CDN (ESP Web Tools, Improv WiFi Serial SDK). `flash.html`'s initial `manifest="hardware/output/…"` attribute is replaced by JS on load — the `manifestMap` in its script is authoritative.
- **Commit style:** short imperative subjects (see `git log --oneline`). CI bot commits use `Update firmware build and version.yaml [skip ci]` — keep the `[skip ci]` convention for artifact-only commits.

## Known rough edges (from TODO / code comments)

- Yellow/paused and white/grey LED states unimplemented; `confirmedReady && !isAvailable` falls through to LED off.
- Offline printers have shown green instead of red; Store ID persistence and fetch-on-boot are open items in `TODO`.
- `on_update_available` for the update entity is unreliable upstream (esphome/issues#6205), hence the 3-minute polling workaround in `update.yaml`.
- Power consumption (~300–500 mA target) and long-press-to-mark-failed are not implemented.
