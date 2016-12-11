chromebrew-cross
================

Package builder for Chromebrew

**Support X86, X86-64, ARM chipsets**

Overview
--------

Chromebrew, a masterpiece of linux environment on Chromebook, supports several architectures.  Chromebrew-cross is a cross-compiling environment to support them all.

Prerequisites
-------------

You will need a linux box with docker implemented.

Installation
------------

Type `make cross` to build all cross compiling environment.

...

Usage
-----

    make cross-armv7|cross-x86|cross-x64|cross
    make armv7|x86|x64|all

First, create corss compiling environment for each architecture or all.
Second, create packages for each architecture or all.
  
Available packages are listed in the [packages directory](https://github.com/jam7/chromebrew-cross/tree/master/packages).

License
-------

Copyright 2016 Kazushi (Jam) Marukawa

This project including all of its source files is released under the terms of [GNU General Public License (version 3 or later)](http://www.gnu.org/licenses/gpl.txt)

Thanks lyxell for [GCC/musl toolchains for Chrome OS](https://github.com/lyxell/chromeos-gcc-toolchains)
Thanks Davy for [putting pre-compiled gcc for ARM](http://davy.nyacom.net/cros-arm-dev.html)
