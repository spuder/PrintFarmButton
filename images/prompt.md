create esphome project

## Design
make it modular, there should be a central config file that includes a config.d directory with individual yaml files

## Hardware

assume esp32-devkit with rgb led on pin 38


## Esphome

fetch mcp from https://context7.com/esphome/esphome-docs/llms.txt

### webserver
it should have the webserver with v3

There should be the following sections (groups)
1. Cloud Config
2. Printer Config

### mqtt
The mqtt user defined variables show up in the cloud config section of the webserver

it should have a mqtt client with user defined variables

variables
1. mqtt endpoint
Should be a drop down selection box, as of right now there should only be 1 drop down value 'wss://realtime.printago.io'
assume port 443

2. username
text box for user to enter their 

3. Password
passowrd box where user can input their values

4. Client ID
preppuplate the feild with apiclient_XXXX

once all 4 values are defined, then establish an mqtt connection

subscribe to the `stores/$USERNAME/printer-stats/#` topic,

## RGB LED

Provide a button in the web interface that allows the user to specify the rgb color for now, this will be changed to automatically update via mqtt messages in the future. 


---

### Wifi

ensure it enables wifi, if not connected to wifi setup the API with hotspot OpenQueue-XXXXX where X are mac address


### Bluetooth

Enable bluetooth and improv


---

## Makefile

provide a make file that allows for cimpiling the software locally and flashing to device. use an env var for the /dev/cu* address of the sreial port

Assume that esphome cli is installed

provide compile and upload make steps