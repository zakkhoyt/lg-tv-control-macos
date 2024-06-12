
# lgtv 
## Config file
`$HOME/.lgtv/lgtv/config/config.json`

## Binaries
* `/opt/homebrew/bin/lgtv` (works)
* `~/opt/lgtv/bin/lgtv` (works)
* `~/.lgtv/lgtv/bin/lgtv` (works after fixing python link)

## Development
* Python code: `$HOME/.lgtv/lgtv/lib/python3.11/site-packages/LGTV/scan.py`
* Debugging: 
  * VSCode interpreter to `~/.lgtv/lgtv/bin/python3`
  * Ensure it has the LGTV package available
  * `~/.lgtv/lgtv/bin/python3 ~/.lgtv/lgtv/bin/lgtv --name LGC1 --ssl swInfo`


# Snippets from logs
```sh
~/opt/lgtv/bin/lgtv --name LGC1 --ssl swInfo
```

```md
{
    "type": "response",
    "id": "sw_info_0",
    "payload": {
        "returnValue": true,
        "product_name": "webOSTV 6.0",
        "model_name": "HE_DTV_W21O_AFABATAA",
        "sw_type": "FIRMWARE",
        "major_ver": "03",
        "minor_ver": "40.87",
        "country": "US2",
        "country_group": "US",
        "device_id": "b4:b2:91:b4:e6:f3",
        "auth_flag": "N",
        "ignore_disable": "N",
        "eco_info": "01",
        "config_key": "00",
        "language_code": "en-US"
    }
}
{
    "closing": {
        "code": 1000,
        "reason": ""
    }
}
```


```sh
~/opt/lgtv/bin/lgtv --name LGC1 --ssl getForegroundAppInfo
```
```json
{
    "type": "response",
    "id": "0",
    "payload": {
        "appId": "com.webos.app.hdmi2",
        "returnValue": true,
        "windowId": "",
        "processId": ""
    }
}
{"closing": {"code": 1000, "reason": ""}}
```


# List of endpoints from log file
```log
file:///usr/bin/com.webos.app.dvrpopup
file:///usr/bin/com.webos.app.factorywin
file:///usr/bin/com.webos.app.home
file:///usr/bin/com.webos.app.inputcommon
file:///usr/bin/com.webos.app.livemenu
file:///usr/bin/com.webos.app.livepick
file:///usr/bin/com.webos.app.livepick-full
file:///usr/bin/com.webos.app.tvhotkey
file:///usr/bin/com.webos.app.voice
file:///usr/bin/com.webos.exampleapp.systemui
file:///usr/palm/applications/com.webos.app.screensaver/qml/main.qml
https://192.168.4.81:3001/resources/000c65d4609a2545685566e47220dc5c14676339/aiv_white_80x80.png
https://192.168.4.81:3001/resources/0af3abeaeaded1e61c012dc226730b47a06bfec4/30400783349475533_37925692_80x80_webos.png
https://192.168.4.81:3001/resources/140c7f73e5376e56e112d13ad0bcf8e0aa2ee463/icon_lgremoteservice.png
https://192.168.4.81:3001/resources/185f1bedb4f7687c0853cec8479299153bedacdf/icon.png
https://192.168.4.81:3001/resources/1f3787def1b1313eb18cb674851e6588033c7968/ic_app_sportalarm_2k.png
https://192.168.4.81:3001/resources/26a06fa06bf1674f0de7426bee296cc80d13e3d4/splash.png
https://192.168.4.81:3001/resources/2e64eac2bfe446a0cf012935f05908b6cddea338/4945987084042019_16977670_80x80_webos.png
https://192.168.4.81:3001/resources/2f9cc28783f5e3c7a80179821c37baaa9c73988a/13730519382019761_16977867_80x80_webos.png
https://192.168.4.81:3001/resources/300428ddb497b5095b1d1c022fb7e70b3e6fa113/icon.png
https://192.168.4.81:3001/resources/374167575875d3d9db6189f5810303c5bce85af3/icon_80x80.png
https://192.168.4.81:3001/resources/3ef2d29d79431525e6f31c4b57625479e9a5ca1d/icon_component_80.png
https://192.168.4.81:3001/resources/45ac588383bd959419d2c8b6a4536d1c3a0afbb8/icon_HDMI_4_80.png
https://192.168.4.81:3001/resources/5a4d4cfdd36bda0e5acd5bec5e668d6ce1a811ff/13540761905334586_37449189_80x80_webos.png
https://192.168.4.81:3001/resources/5d5473009991454062fa45d2004ecbb8982eb211/lgstore.png
https://192.168.4.81:3001/resources/627aea78b0f542f4f1b1ac0baded0481ae2e708b/icon_scheduler.png
https://192.168.4.81:3001/resources/6a642a2adf2074e399af366e975c4fe6c5b46970/icon.png
https://192.168.4.81:3001/resources/6df154e4454c3dc183e19dc2c7fd82342a3df27f/icon_small.png
https://192.168.4.81:3001/resources/6dfd9a2c65f79b824b124ebccd9ac810ce6e2f7a/27101850392736047_37895405_80x80_webos.png
https://192.168.4.81:3001/resources/7042c4b94b4da380420786d4ac120fd56b618e70/icon_scart_80.png
https://192.168.4.81:3001/resources/7278b25203048048fc650714065a4714a09917ba/72139087318820447_36160700_80x80_webos.png
https://192.168.4.81:3001/resources/77eef0b9d27915b89034f323d2071ec5aa3a04ee/AirPlay_Icon-77x77.png
https://192.168.4.81:3001/resources/7ad1deee39c03dd292bb30ece0b6abcaaa9b975b/icon_notification.png
https://192.168.4.81:3001/resources/7b0d2bcdd608dcdc7897a50d1b41a3ae6a713b70/setting_80x80.png
https://192.168.4.81:3001/resources/7c8b9312a423431fde1c644f6a6c41a68bff359c/icon_av_80.png
https://192.168.4.81:3001/resources/80380fd531c9e04d992c8c8a11976aa0b77e40f5/icon.png
https://192.168.4.81:3001/resources/89f6832a1a0df32a62e38655d980af19710ad5e5/webbrowser_icon.png
https://192.168.4.81:3001/resources/89f6bdcd4681936dee3fc6199109c855f998e744/96445588952254041_21790820472215287LARGE_APP_ICON_80x80_webos.png
https://192.168.4.81:3001/resources/8aa2dd9b860bcf345fd3161eff11258d4e11bc77/icon_livetv_80.png
https://192.168.4.81:3001/resources/94091813f66b4b3fb11bb4fc5eee4a26689995d1/app_ic_www_4k.png
https://192.168.4.81:3001/resources/96a126a220d8f4dcb3008ff38dc6dac57e6a0e18/13887589306908354_34877553_80x80_webos.png
https://192.168.4.81:3001/resources/99329c895249d18e07baf0ed212d29a5ec05aeea/33415616034563744_37837198_80x80_webos.png
https://192.168.4.81:3001/resources/a41d0c2854da22cc277aefd7c1899a14c768cfad/icon_60.png
https://192.168.4.81:3001/resources/a7301b876d72d201c3478c4502feba9195ed4d3e/29115590483436620_37940400_80x80_webos.png
https://192.168.4.81:3001/resources/b669b4b5a13cc5828d5255b351d02d6101b8c200/icon_HDMI_2_80.png
https://192.168.4.81:3001/resources/b92923e1db25de421a042432972c74b325590273/icon.png
https://192.168.4.81:3001/resources/b97fcfb9eedfb1f9e0620454733d66c1c8d887c9/icon_userguide.png
https://192.168.4.81:3001/resources/cc499b71e161fa004c6be5cb595b118516be07a0/icon_HDMI_3_80.png
https://192.168.4.81:3001/resources/d263872b6f20b20b0e84ad69b257b6d35920a0cd/69919359365022716_35543808_80x80_webos.png
https://192.168.4.81:3001/resources/dbf46b3a3ea96d162503f4ba6531458687eb0988/icon-mini.png
https://192.168.4.81:3001/resources/e0a54f6c1b4f4c445248c9f59725c7153a077631/icon_80.png
https://192.168.4.81:3001/resources/f2a563db9d546a92c4618b99fa273ec75ff43fec/icon_HDMI_1_80.png
https://192.168.4.81:3001/resources/fab2420eb6e52d0aaf8f6a45f7387749becc7c80/icon_scheduler.png
luna://amazon.service/invoke
luna://com.webos.app.browser.service/invoke
luna://com.webos.app.igallery.preview/invoke
```



```sh
$ ~/opt/lgtv/bin/lgtv --name LGC1 --ssl swInfo
```

```json
json
```

## Handshake
DEBUG:root:Initiating handshake
DEBUG:root:Received response
DEBUG:root:
{
    "type": "registered",
    "id": "register_0",
    "payload": {
        "client-key": "af6a854c6e1b88e60b9ec6fb5672765b"
    }
}
DEBUG:root:Handshake complete
DEBUG:root:
{
    "id": "sw_info_0",
    "type": "request",
    "uri": "ssap://com.webos.service.update/getCurrentSWInformation"
}
DEBUG:root:Received response
DEBUG:root:
{
    "type": "response",
    "id": "sw_info_0",
    "payload": {
        "returnValue": true,
        "product_name": "webOSTV 6.0",
        "model_name": "HE_DTV_W21O_AFABATAA",
        "sw_type": "FIRMWARE",
        "major_ver": "03",
        "minor_ver": "40.87",
        "country": "US2",
        "country_group": "US",
        "device_id": "b4:b2:91:b4:e6:f3",
        "auth_flag": "N",
        "ignore_disable": "N",
        "eco_info": "01",
        "config_key": "00",
        "language_code": "en-US"
    }
}
DEBUG:root:
{
    "type": "response",
    "id": "sw_info_0",
    "payload": {
        "returnValue": true,
        "product_name": "webOSTV 6.0",
        "model_name": "HE_DTV_W21O_AFABATAA",
        "sw_type": "FIRMWARE",
        "major_ver": "03",
        "minor_ver": "40.87",
        "country": "US2",
        "country_group": "US",
        "device_id": "b4:b2:91:b4:e6:f3",
        "auth_flag": "N",
        "ignore_disable": "N",
        "eco_info": "01",
        "config_key": "00",
        "language_code": "en-US"
    }
}
DEBUG:ws4py:Closing message received (1000) 'b'''
{
    "closing": {
        "code": 1000,
        "reason": ""
    }
}
