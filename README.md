![version](https://img.shields.io/badge/version-19%2B-5682DF)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-intel%20|%20mac-arm%20|%20win-64&color=blue)
[![license](https://img.shields.io/github/license/miyako/4d-plugin-scard-v2)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/4d-plugin-scard-v2/total)

# 4d-plugin-scard-v2
SCARD with LIBUSB, LIBNFC fallback on Mac.

## libnfc

**Problem**: Some card readers do not have a driver for Mac. 

* [SONY "PaSoRi" RC-S330](https://www.sony.jp/cat/products/RC-S330/)

**Solution**: Use [libnfc](https://github.com/nfc-tools/libnfc) as a fallback solution.

### SONY chipsets and libnfc

SONY specifications are often hard to find, only published in Japanese, or made available to corporate customers under an NDA. The developer of libnfc try to support the SONY chipset "RC-S956" (used by RC-S330, RC-S360, and RC-S370) which is similar to "PN53x" but not identical. 

* For the SONY chipset "RC-S956", the call succeeds once after the reader is connected to a Mac, but only that first time. After that, one must quit the application, disconnect the reader and try again. 

* For the SONY chipset "NFC Port-100" (used by RC-S380), there is no support as of ``libnfc-1.8.0`` (see below for alternative solution).

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

* [SONY "PaSoRi" RC-S380](https://www.sony.co.jp/Products/felica/consumer/products/RC-S380.html)

**Solution**: Use [libusb](https://github.com/libusb/libusb) as a fallback solution.

### SONY chipsets and libusb

* The developers of [nfcpy](https://github.com/nfcpy/nfcpy) have done a good job at supporting these SONY chipsets. We can deduce SONY proprietary protocol from their code.

* This developer credits nfcpy for helping find a way to support RC-S380 via libusb on Mac:

  * [今更ですが、SONY RC-S380 で Suica の IDm を読み込んでみた](https://qiita.com/ysomei/items/32f366b61a7b631c4750)
  * [getdeviceid.cpp](https://github.com/ysomei/test_getnfcid/blob/master/getdeviceid.cpp)

* Example of libusb call

  * [FeliCa](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/test/Project/Sources/Methods/TEST_002_USB_F.4dm)
  * [Type B](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/test/Project/Sources/Methods/TEST_002_NFC_B.4dm)
  * Type A requires [SAK anti-collision sequence](https://github.com/nfc-tools/libnfc/blob/master/examples/nfc-anticol.c); not implemented here...
 
---

### TODO

* [Suica(IDm)で認証するのは危険なのでFelica Lite-Sの内部認証を使う](https://qiita.com/odetarou/items/bcd65dbfd1f68735ac30)
