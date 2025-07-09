# Makefile for ESPHome PrintFarmButton

ESPHOME ?= esphome

.PHONY: clean build-s3-mini run-s3-mini build-c3-mini run-c3-mini build-s3-zero run-s3-zero build-c3-zero run-c3-zero

# Clean all build artifacts
clean:
	rm -rf .esphome/build/printfarmbutton*
	rm -rf .esphome/.storage

# ESP32-S3 SuperMini builds
build-s3-mini:
	$(ESPHOME) compile esp32s3-supermini.yaml

run-s3-mini:
	$(ESPHOME) run esp32s3-supermini.yaml

# ESP32-C3 SuperMini builds  
build-c3-mini:
	$(ESPHOME) compile esp32c3-supermini.yaml

run-c3-mini:
	$(ESPHOME) run esp32c3-supermini.yaml

# ESP32-S3 Zero builds
build-s3-zero:
	$(ESPHOME) compile esp32s3-zero.yaml

run-s3-zero:
	$(ESPHOME) run esp32s3-zero.yaml

# ESP32-C3 Zero builds
build-c3-zero:
	$(ESPHOME) compile esp32c3-zero.yaml

run-c3-zero:
	$(ESPHOME) run esp32c3-zero.yaml

# Clean and build targets (automatically clean before building different chip families)
clean-build-s3-mini: clean build-s3-mini
clean-build-c3-mini: clean build-c3-mini  
clean-build-s3-zero: clean build-s3-zero
clean-build-c3-zero: clean build-c3-zero

# For backward compatibility
s3: run-s3-mini
c3: run-c3-mini
