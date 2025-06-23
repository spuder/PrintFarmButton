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

Then join the `openqueue` wifi network and navigate to 192.168.4.1
Enter your wifi credentials and wait for it to reboot

Once you've joined it to your wifi, navigate to `http://openqueue.local` or find the ip address. 

## Hardware

Requires an esp32 and RGB Leds, and a 3d printer of course

## Sofware

## LED Color States

The RGB LED indicates printer status as follows:

| Color   | Meaning                                      | Condition                                                                 |
|---------|----------------------------------------------|--------------------------------------------------------------------------|
| White   | Offline / Not connected                     | `isOnline == false`                                                      |
| Green   | Printing                                    | `isOnline == true && state == "RUNNING"`                                |
| Purple  | Idle (finished & available)                 | `isOnline == true && (state == "FINISH" or "FINISHED") && isAvailable == true` |
| Red     | Finished, not cleared (not available)       | `isOnline == true && (state == "FINISH" or "FINISHED") && isAvailable == false` |
| Off     | Unknown/other state                         | Any other state                                                          |

- `isOnline`, `state`, and `isAvailable` are fields in the MQTT JSON payload.
- Colors are set automatically based on the most recent MQTT message.

---

