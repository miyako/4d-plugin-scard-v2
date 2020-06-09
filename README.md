# 4d-plugin-scard-v2
SCARD with LIBUSB, LIBNFC fallback on Mac.

### libnfc

Some card readers do not have a driver for Mac. 

* [SONY "PaSoRi" RC-S330](https://www.sony.jp/cat/products/RC-S330/)

* [SONY "PaSori RC-S380"](https://www.sony.co.jp/Products/felica/consumer/products/RC-S380.html)

We can use [libnfc](https://github.com/nfc-tools/libnfc) as a fallback solution.

##### Issues with libnfc

SONY specifications are often published in Japanese or made available to corporate customers under an NDA. The developer of libnfc try to support the SONY chipset "RC-S956" (used by RC-S330, RC-S360, and RC-S370) which is similar to "PN53x" but testing shows that there is a timing issue. The call generally success immediately after the reader is connected to a Mac, but only the first time. Also the SONY chipset "NFC Port-100" (used by RC-S380) is not supported as of ``libnfc-1.8.0``.




