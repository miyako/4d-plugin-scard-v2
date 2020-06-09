# 4d-plugin-scard-v2
SCARD with LIBUSB, LIBNFC fallback on Mac.

### libnfc

Some card readers do not have a driver for Mac. 

* [SONY "PaSoRi" RC-S330](https://www.sony.jp/cat/products/RC-S330/)

* [SONY "PaSori" RC-S380](https://www.sony.co.jp/Products/felica/consumer/products/RC-S380.html)

We can use [libnfc](https://github.com/nfc-tools/libnfc) as a fallback solution.

### SONY chipsets and libnfc

SONY specifications are often published in Japanese or made available to corporate customers under an NDA. The developer of libnfc try to support the SONY chipset "RC-S956" (used by RC-S330, RC-S360, and RC-S370) which is similar to "PN53x" but not identical. 

* For the SONY chipset "RC-S956", the call succeeds once after the reader is connected to a Mac, but only that first time. After that, one must quit the application, disconnect the reader and try again. 

* For the SONY chipset "NFC Port-100" (used by RC-S380), there is no support as of ``libnfc-1.8.0``.

* The developers of [nfcpy](https://github.com/nfcpy/nfcpy) have done a good job at supporting these SONY chipsets. We can deduce SONY proprietary protocol from their code.

* This developer cridits nfcpy to support RC-S380 on Mac (libusb, not libnfc):

  * [今更ですが、SONY RC-S380 で Suica の IDm を読み込んでみた](https://qiita.com/ysomei/items/32f366b61a7b631c4750)
  * [getdeviceid.cpp](https://github.com/ysomei/test_getnfcid/blob/master/getdeviceid.cpp)

* The fix for SONY "RC-S956" chipset

  * Added a ``usleep(300000)`` during ``pn53x_init``. So it was a timing issue? Thats ``0.3`` seconds.

  * [pn53x.c](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/patch/pn53x.c)

* Example of libnfc call

  * [FeLiCa](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/test/Project/Sources/Methods/TEST_002_NFC_F.4dm)
  * [Type B](https://github.com/miyako/4d-plugin-scard-v2/blob/master/SCARD-v2/test/Project/Sources/Methods/TEST_002_NFC_B.4dm)
  * Sorry I have no Type A cards to test...
  
