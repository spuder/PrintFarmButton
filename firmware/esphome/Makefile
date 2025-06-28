# Makefile for ESPHome PrintFarmButton

ESPHOME ?= esphome

.PHONY: clean build-s3 run-s3 build-c3 run-c3

clean:
	rm -rf .esphome/build/printfarmbutton-s3
	rm -rf .esphome/build/printfarmbutton-c3
	rm -f ../output/printfarmbutton-esp32s3.bin ../output/printfarmbutton-esp32c3.bin ../output/printfarmbutton-esp32s3.bin.md5 ../output/printfarmbutton-esp32c3.bin.md5 ../output/manifest.json

build-s3:
	esphome compile firmware/esphome/esp32s3.yaml

run-s3:
	esphome run firmware/esphome/esp32s3.yaml

build-c3:
	esphome compile firmware/esphome/esp32c3.yaml

run-c3:
	esphome run firmware/esphome/esp32c3.yaml

# For backward compatibility, keep 's3' and 'c3' as aliases for 'run-s3' and 'run-c3'
s3: run-s3
c3: run-c3
