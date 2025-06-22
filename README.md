# OpenQueue

<p align="center">
  <img src="images/logo.png" alt="OpenQueue Logo" width="200"/>
</p>

Open Source Andon light for 3d printers. 
See the state of your prints. With the push of a button you can mark your print plate as clear and ready for the next print in the queue. 

## Supported Print Queues

| Print Queue     | Status        |
|-----------------|--------------|
| printago.io     | ✅ Supported  |
| simplyprint     | 🕵️ Evaluating |
| 3dprinteros     | 🕵️ Evaluating |
| autofarm        | 🕵️ Evaluating |

## Setup

```
cd firmware/esphome
esphome compile config.yaml
esphome upload config.yaml
```

## Hardware

Requires an esp32 and RGB Leds, and a 3d printer of course

## Sofware

