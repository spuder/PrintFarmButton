# PrintFarmButton

<p align="center">
  <img src="images/logo.png" alt="PrintFarmButton Logo" width="200"/>
</p>

Open Source Andon light for 3d printers. 
See the state of your prints with a physical LED & microcontroller. With the push of a button you can mark your print plate as clear and ready for the next print in the queue. 

## Supported Print Queues

| Print Queue     | Status        |
|-----------------|--------------|
| printago.io     | ✅ Supported  |
| simplyprint     | 🕵️ Evaluating |
| 3dprinteros     | 🕵️ Evaluating |
| autofarm        | 🕵️ Evaluating |

## Setup

```bash
cd firmware/esphome

# For ESP32-S3 SuperMini boards:
make run-s3-mini

# For ESP32-C3 SuperMini boards:  
make run-c3-mini

# For ESP32-S3 Zero boards:
make run-s3-zero

# For ESP32-C3 Zero boards:
make run-c3-zero
```

You will see a new wifi network named `printfarmbutton-xxxx`. Join the network and navigate to [192.168.4.1](http://192.168.4.1)
Enter your wifi credentials and wait for it to reboot. 

Once you've joined it to your wifi, navigate to `http://printfarmbutton-xxxxxx.local` or find the ip address. 

## Hardware

### Required Components
- ESP32-S3-Zero board
- RGB LED connected to GPIO1 (5v, 144 Leds per meter)
- Physical button connected to GPIO2
- 3D printed enclosure (see `/hardware` folder for STL files)

#### Links

[Esp32-S3-Zero](https://amzn.to/44gplMl)  
[LED Strip](https://amzn.to/44uVFMB)  

### Wiring
1. Connect the RGB LED:
   - Data pin to GPIO1 on the ESP32-S3-Zero
   - Power pin to 5V
   - Ground pin to GND
2. Connect the physical button between GPIO2 and GND on the ESP32-S3-Zero
   - One terminal of the button connects to GPIO2
   - The other terminal connects to GND
3. Power the ESP32-S3-Zero via USB or an external 5V power supply

### Wiring Diagram


![Schematic](images/schematic.png)

## Firmware

To flash, ensure you have the `esphome` cli installed (`brew install esphome`)

```bash
cd firmware/esphome

# Build and flash for specific board types:
make run-s3-mini    # ESP32-S3 SuperMini boards
make run-c3-mini    # ESP32-C3 SuperMini boards  
make run-s3-zero    # ESP32-S3 Zero boards
make run-c3-zero    # ESP32-C3 Zero boards

# Or just compile without flashing:
make build-s3-mini  # Compile only for ESP32-S3 SuperMini
make build-c3-mini  # Compile only for ESP32-C3 SuperMini
make build-s3-zero  # Compile only for ESP32-S3 Zero
make build-c3-zero  # Compile only for ESP32-C3 Zero
```

To clean build artifacts (recommended when switching between chip families):
```bash
make clean
```

For clean builds (automatically clean then build):
```bash
make clean-build-s3-mini  # Clean then build ESP32-S3 SuperMini
make clean-build-c3-mini  # Clean then build ESP32-C3 SuperMini
make clean-build-s3-zero  # Clean then build ESP32-S3 Zero  
make clean-build-c3-zero  # Clean then build ESP32-C3 Zero
```

**Legacy commands** (for backward compatibility):
```bash
make s3   # Alias for run-s3-mini
make c3   # Alias for run-c3-mini
```

## ESPHome Makefile Usage

This project provides a Makefile for building and flashing ESPHome firmware for PrintFarmButton devices across different board variants.

### Board Types Supported

- **ESP32-S3 SuperMini** (`s3-mini`) - Uses GPIO3 for LED, GPIO0 for button
- **ESP32-C3 SuperMini** (`c3-mini`) - Uses GPIO3 for LED, GPIO0 for button  
- **ESP32-S3 Zero** (`s3-zero`) - Uses GPIO1 for LED, GPIO2 for button
- **ESP32-C3 Zero** (`c3-zero`) - Uses GPIO0 for LED, GPIO1 for button

⚠️ **Warning**: ESP32-C3 SuperMini boards from AliExpress are known to have overheating issues and WiFi connectivity problems. Consider using ESP32-S3 variants or ESP32-C3 Zero boards for better reliability.

### Available Commands

**Build and Flash:**
- `make run-s3-mini` — Build and upload to ESP32-S3 SuperMini
- `make run-c3-mini` — Build and upload to ESP32-C3 SuperMini
- `make run-s3-zero` — Build and upload to ESP32-S3 Zero
- `make run-c3-zero` — Build and upload to ESP32-C3 Zero

**Build Only:**
- `make build-s3-mini` — Compile firmware for ESP32-S3 SuperMini
- `make build-c3-mini` — Compile firmware for ESP32-C3 SuperMini
- `make build-s3-zero` — Compile firmware for ESP32-S3 Zero
- `make build-c3-zero` — Compile firmware for ESP32-C3 Zero

**Clean Builds:**
- `make clean-build-s3-mini` — Clean then build ESP32-S3 SuperMini
- `make clean-build-c3-mini` — Clean then build ESP32-C3 SuperMini
- `make clean-build-s3-zero` — Clean then build ESP32-S3 Zero
- `make clean-build-c3-zero` — Clean then build ESP32-C3 Zero

**Maintenance:**
- `make clean` — Remove all build artifacts and cache

**Legacy Aliases:**
- `make s3` — Alias for `run-s3-mini`
- `make c3` — Alias for `run-c3-mini`

### Notes
- You must have [ESPHome](https://esphome.io/) installed and available in your PATH
- Each board type has different GPIO configurations for LED and button
- Clean builds are recommended when switching between different chip families (ESP32-S3 ↔ ESP32-C3)
- Output binaries are placed in the ESPHome build directory

### Troubleshooting

If you get CMake errors about target mismatches, run `make clean` first:
```bash
make clean
make run-c3-mini  # or whichever target you want
```

---

For more details, see the comments in the Makefile and the ESPHome documentation.