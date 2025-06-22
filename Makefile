# Makefile for ESPHome OpenQueue Project
# Usage:
#   make compile BOARD=zero
#   make upload-s3-zero SERIAL_PORT=/dev/cu.usbserial-XXXX
#   make upload-s3-devkit SERIAL_PORT=/dev/cu.usbserial-XXXX

ESPHOME_CONFIG=firmware/esphome/config.yaml
SERIAL_PORT?=/dev/cu.usbserial-XXXX

.PHONY: compile upload-s3-zero upload-s3-devkit clean

compile:
	esphome compile firmware/esphome/config.yaml

upload-s3-zero: compile
	@echo "Set board_type: esp32-s3-devkitc-1 and rgb_led_pin: 1 in config.yaml before running this."
	esphome upload firmware/esphome/config.yaml --device $(SERIAL_PORT)

upload-s3-devkit: compile
	@echo "Set board_type: esp32-s3-devkitm-1 and rgb_led_pin: 48 in config.yaml before running this."
	esphome upload firmware/esphome/config.yaml --device $(SERIAL_PORT)

clean:
	rm -rf firmware/esphome/.esphome/build
