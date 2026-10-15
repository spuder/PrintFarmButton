# States

```
# Blue (Ready)
isOnline: true
confirmedReady: true
isAvailable: true

# Purple (Set Ready)
isOnline: true
confirmedReady: false
isAvailable: true

# Green (busy)
isOnline: true
isAvailable: false
confirmedReady: false
```

# API

Get info about printers
```
curl -X GET "https://api.printago.io/v1/printers/$PRINTERID" \
  -H "authorization: ApiKey $YOUR_API_KEY" \
  -H "x-printago-storeid: $USERNAME" | jq
  ```

Get MQTT messages

Updates for printers, e.g. when transitioning from idle to ready
`stores/$USERNAME/entities/printers/$PRINTER`

`stores/$USERNAME$/entities/printers/#`


Gets basic information about printer
`stores/$USERNAME/printer-stats/$PRINTER`


The Rest api provides all 3 entities

Whereas the MQTT `printer-stats/` provides `isOnline` and `isAvailable`, but only `entities/printers` provides `confirmedReady`. 
Furthermore `entities/printers` does not have retain enabled on the messages, so unless you are activly watching, you won't be able to get that state. 
# MQTT TLS certificate

`firmware/esphome/conf.d/mqtt.yaml` pins the Let's Encrypt root CAs (ISRG Root X1, X2, YE, YR) as `certificate_authority`, and the broker hostname is checked against the certificate (no `skip_cert_cn_check`). Do not pin the broker's leaf or intermediate certificate: Let's Encrypt renews the leaf about every 90 days and rotates intermediates, so a pinned leaf breaks devices on every renewal.

Check what the broker currently serves and that it chains to the pinned roots:
```
echo | openssl s_client -connect realtime.printago.io:8883 -servername realtime.printago.io -showcerts 2>/dev/null | grep -E "^ *[0-9] s:|i:|NotAfter"
```

Rotation is only needed when Printago changes CA, or a pinned root nears expiry (X1: 2035-06-04, X2: 2040-09-17, YE/YR: 2045-09-02). To rotate:
1. Download the new root(s) from https://letsencrypt.org/certificates/ (or the new CA's site) and check the SHA-256 fingerprint against the published one: `openssl x509 -in root.pem -noout -fingerprint -sha256`
2. Add the new root to `certificate_authority` **alongside** the existing ones, release, and wait for devices to auto-update (`conf.d/update.yaml`) *before* the broker switches CA. Only remove old roots once no served chain depends on them.
3. Run `esphome config` for every board, flash a device, and confirm `MQTT Connected` in the logs against `realtime.printago.io:8883`.
