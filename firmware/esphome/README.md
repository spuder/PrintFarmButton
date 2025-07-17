# Building

```bash
podman run -it -v $PWD:/data -v $PWD/.esphome/platformio:/cache esphome/esphome:2025.7.0b1 compile /data/esp32s3-supermini.yaml
```