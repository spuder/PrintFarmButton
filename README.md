# OpenQueueButton

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

Then join the `openqueue` wifi network and navigate to 192.168.4.1
Enter your wifi credentials and wait for it to reboot

Once you've joined it to your wifi, navigate to `http://openqueue.local` or find the ip address. 

## Hardware

### Required Components
- ESP32-S3-Zero board
- RGB LED connected to GPIO1
- Physical button connected to GPIO2
- 3D printed enclosure (see `/hardware` folder for STL files)

### Wiring
1. Connect the RGB LED:
   - Data pin to GPIO1 on the ESP32-S3-Zero
   - Power pin to 5V
   - Ground pin to GND
2. Connect the physical button between GPIO2 and GND on the ESP32-S3-Zero
   - One terminal of the button connects to GPIO2
   - The other terminal connects to GND
3. Power the ESP32-S3-Zero via USB or an external 5V power supply

### Pinout Reference
| Component      | ESP32-S3-Zero Pin |
|----------------|-------------------|
| RGB LED data   | GPIO1             |
| RGB LED power  | 5V                |
| RGB LED ground | GND               |
| Button         | GPIO2 and GND     |

### Wiring Diagram

```
                ESP32-S3-Zero
             +----------------+
        |----+ 5v             |
        |----+ GND            |
        |    |                |
RGB LED -----+ GPIO1          |
             |                |
Button  -----+ GPIO2          |
    |        |                |
    |        |                |
    +--------+ GND            |
             |                |
             +----------------+
```
