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

* For example, the following example (libusb, not libnfc) used nfcpy to support RC-S380 on Mac:

  * [今更ですが、SONY RC-S380 で Suica の IDm を読み込んでみた](https://qiita.com/ysomei/items/32f366b61a7b631c4750)
  * [getdeviceid.cpp](https://github.com/ysomei/test_getnfcid/blob/master/getdeviceid.cpp)

