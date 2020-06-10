# 4d-plugin-scard-v2
SCARD with LIBUSB, LIBNFC fallback on Mac.

### Platform

| carbon | cocoa | win32 | win64 |
|:------:|:-----:|:---------:|:---------:|
||<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|

### Version

<img width="32" height="32" src="https://user-images.githubusercontent.com/1725068/73986501-15964580-4981-11ea-9ac1-73c5cee50aae.png"> <img src="https://user-images.githubusercontent.com/1725068/73987971-db2ea780-4984-11ea-8ada-e25fb9c3cf4e.png" width="32" height="32" />

## libnfc

**Problem**: Some card readers do not have a driver for Mac. 

* [SONY "PaSoRi" RC-S330](https://www.sony.jp/cat/products/RC-S330/)

**Solution**: Use [libnfc](https://github.com/nfc-tools/libnfc) as a fallback solution.

### SONY chipsets and libnfc

SONY specifications are often hard to find, only published in Japanese, or made available to corporate customers under an NDA. The developer of libnfc try to support the SONY chipset "RC-S956" (used by RC-S330, RC-S360, and RC-S370) which is similar to "PN53x" but not identical. 

* For the SONY chipset "RC-S956", the call succeeds once after the reader is connected to a Mac, but only that first time. After that, one must quit the application, disconnect the reader and try again. 

* For the SONY chipset "NFC Port-100" (used by RC-S380), there is no support as of ``libnfc-1.8.0`` (See below for alternative solution).

* The patch for SONY "RC-S956" chipset

  * Added a ``usleep(300000)`` during ``pn53x_init``. So it was a timing issue? Thats ``0.3`` seconds.

  * [pn53x.c](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/patch/pn53x.c)
  
  * Without the fix, "error	libnfc.driver.pn53x_usb	Application level error detected" is thrown on second call

* Example of libnfc call

  * [FeliCa](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/test/Project/Sources/Methods/TEST_002_NFC_F.4dm)
  * [Type B](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/test/Project/Sources/Methods/TEST_002_NFC_B.4dm)
  * Sorry I have no Type A cards to test...
  
* For Windows, most vendors publish a native device driver so I don't see much need for a low-level driver like libnfc. But for research, it might be interesting to explore:

  * [TDM-GCCでビルドするとうまくいった](https://hiro99ma.blogspot.com/2011/11/libnfctdm-gcc.html)
  * [peacepenguin/libnfc-unofficialbuilds](https://github.com/peacepenguin/libnfc-unofficialbuilds)

* Other opensource options for the SONY chipset:

  * [Web Application Programming Wiki*](https://wikiwiki.jp/webapp/NFC#d78a7e65)
  
## libusb

**Problem**: Some card readers do not have a driver for Mac and has no libnfc support.

* [SONY "PaSori" RC-S380](https://www.sony.co.jp/Products/felica/consumer/products/RC-S380.html)

**Solution**: Use [libusb](https://github.com/libusb/libusb) as a fallback solution.

### SONY chipsets and libusb

* The developers of [nfcpy](https://github.com/nfcpy/nfcpy) have done a good job at supporting these SONY chipsets. We can deduce SONY proprietary protocol from their code.

* This developer cridits nfcpy to support RC-S380 via libusb on Mac:

  * [今更ですが、SONY RC-S380 で Suica の IDm を読み込んでみた](https://qiita.com/ysomei/items/32f366b61a7b631c4750)
  * [getdeviceid.cpp](https://github.com/ysomei/test_getnfcid/blob/master/getdeviceid.cpp)

* Example of libusb call

  * [FeLiCa](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/test/Project/Sources/Methods/TEST_002_USB_F.4dm)
  * [Type B](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/test/Project/Sources/Methods/TEST_002_NFC_B.4dm)
  * Sorry I have no Type A cards to test...
 
---

### TODO

* [Suica(IDm)で認証するのは危険なのでFelica Lite-Sの内部認証を使う](https://qiita.com/odetarou/items/bcd65dbfd1f68735ac30)
