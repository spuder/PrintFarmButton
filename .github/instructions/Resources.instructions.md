---
applyTo: '**'
---
Coding standards, domain knowledge, and preferences that AI should follow.

https://context7.com/esphome/esphome-docs/llms.txt

how to get from the rest api

```
curl  "http://printfarmbutton-xxxx.local/binary_sensor/printer_is_online"
{"id":"binary_sensor-printer_is_online","value":false,"state":"OFF"}%
```


Get username
```
curl -v "http://printfarmbutton-xxxxxx.local/text/username"
{"id":"text-username","min_length":0,"max_length":255,"pattern":"","state":"foobar","value":"foobar"}
```

Set username
```
curl -X POST  "http://printfarmbutton-xxxxxx.local/text/username/set?value=foo"
```