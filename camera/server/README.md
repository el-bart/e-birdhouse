# ESP32 RTSP cam

this is slightly customized version of [esp32-rtsp-cam](https://github.com/el-bart/esp32-rtsp-cam) project.


## configuring WiFi access

WPA2/3 PSK is supported.
```
cd sw/src/
cp wifi_creds.hpp.template wifi_creds.hpp
chmod 600 wifi_creds.hpp
vi wifi_creds.hpp
```
fill your in SSID and password for the network.

note that `wifi_creds.hpp` is marked as ignored in `git`, so that it does not get accudentally committed.


## flahsing

connect via serial adapter.
short `IO0` to `GND` with a jumper and press reset button.

flash with:
```
cd sw
./make
```

remove jumper and press reset button again.
boot sequence should show up on a serial console.
