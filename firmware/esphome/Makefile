# Makefile for ESPHome PrintFarmButton

ESPHOME ?= esphome

.PHONY: clean s3 c3

clean:
	rm -rf .esphome/build
	rm -rf ../output/*

s3:
	$(ESPHOME) run esp32s3.yaml

c3:
	$(ESPHOME) run esp32c3.yaml
