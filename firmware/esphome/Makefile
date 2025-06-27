# Makefile for ESPHome PrintFarmButton

ESPHOME ?= esphome

.PHONY: clean s3 c3

clean:
	rm -rf .esphome/build/printfarmbutton-s3
	rm -rf .esphome/build/printfarmbutton-c3
	rm -f ../output/printfarmbutton-esp32s3.bin ../output/printfarmbutton-esp32c3.bin ../output/printfarmbutton-esp32s3.bin.md5 ../output/printfarmbutton-esp32c3.bin.md5 ../output/manifest.json

s3:
	$(ESPHOME) run esp32s3.yaml

c3:
	$(ESPHOME) run esp32c3.yaml
