# M5Stack ATOM Matrix builds
build-matrix:
	$(ESPHOME_CMD) compile $(YAML_PREFIX)atom-matrix.yaml

run-matrix:
	$(ESPHOME_CMD) run $(YAML_PREFIX)atom-matrix.yaml

# ESPHome PrintFarmButton Makefile
#
# Usage:
#   make <target>                # Uses system ESPHome (default)
#   ESPHOME_MODE=podman make <target>  # Uses Podman container for ESPHome
#
# To use Podman, ensure you have podman installed and the esphome/esphome image available.
# The PlatformIO cache will be reused via .esphome/platformio.
#
# Supported targets: build/run for s3-mini, c3-mini, s3-zero, c3-zero
#
ESPHOME ?= esphome
ESPHOME_MODE ?= system

ifeq ($(ESPHOME_MODE),podman)
	ESPHOME_CMD = podman run -it -v $(CURDIR):/data -v $(CURDIR)/.esphome/platformio:/cache esphome/esphome:2025.7.0
	YAML_PREFIX = /data/
else
	ESPHOME_CMD = $(ESPHOME)
	YAML_PREFIX =
endif

.PHONY: clean build-s3-mini run-s3-mini build-c3-mini run-c3-mini build-s3-zero run-s3-zero build-c3-zero run-c3-zero build-atom-matrix run-atom-matrix clean-build-s3-mini clean-build-c3-mini clean-build-s3-zero clean-build-c3-zero clean-build-atom-matrix s3 c3

# Clean all build artifacts
clean:
	rm -rf .esphome/build/printfarmbutton*
	rm -rf .esphome/.storage

# ESP32-S3 SuperMini builds
build-s3-mini:
	$(ESPHOME_CMD) compile $(YAML_PREFIX)esp32s3-supermini.yaml

run-s3-mini:
	$(ESPHOME_CMD) run $(YAML_PREFIX)esp32s3-supermini.yaml

# ESP32-C3 SuperMini builds  
build-c3-mini:
	$(ESPHOME_CMD) compile $(YAML_PREFIX)esp32c3-supermini.yaml

run-c3-mini:
	$(ESPHOME_CMD) run $(YAML_PREFIX)esp32c3-supermini.yaml

# ESP32-S3 Zero builds
build-s3-zero:
	$(ESPHOME_CMD) compile $(YAML_PREFIX)esp32s3-zero.yaml

run-s3-zero:
	$(ESPHOME_CMD) run $(YAML_PREFIX)esp32s3-zero.yaml

# ESP32-C3 Zero builds
build-c3-zero:
	$(ESPHOME_CMD) compile $(YAML_PREFIX)esp32c3-zero.yaml

run-c3-zero:
	$(ESPHOME_CMD) run $(YAML_PREFIX)esp32c3-zero.yaml

# M5Stack ATOM Matrix builds (unique process)
build-atom-matrix:
	$(ESPHOME_CMD) compile $(YAML_PREFIX)atom-matrix.yaml

run-atom-matrix:
	$(ESPHOME_CMD) run $(YAML_PREFIX)atom-matrix.yaml

clean-build-atom-matrix: clean build-atom-matrix

# Clean and build targets (automatically clean before building different chip families)
clean-build-s3-mini: clean build-s3-mini
clean-build-c3-mini: clean build-c3-mini  
clean-build-s3-zero: clean build-s3-zero
clean-build-c3-zero: clean build-c3-zero
