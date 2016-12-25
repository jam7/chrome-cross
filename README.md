chrome-cross
============
Toolchain builder for chromebrew

**Support X86, X86-64, ARM chipsets, but tested ARM only**

Overview
--------

Made building environment of toolchains for all chromebook chipsets for the ease of maintenance.

Prerequisites
-------------

You will need a 64 bits linux box with docker implemented.

Usage
-----

    make armv7 | x86 | x64 | all

Each creates cross compiling environment on docker and creates toolchains on them.
It is possible to cross-compiling environment also be following commands.

    make cross-armv7 | cross-x86 | cross-x64 | cross

Packages
--------

Made following packages for armv7, x86 and x64.

    linuxheaders, binutils, glibc, gmp, mpfr, mpc and gcc

Other usage
-----------

I would like to compile other packages also with this, but it is difficult to do so since it requires Chromeos environment.  For example, a package may require /usr/lib/libcrypt.so, but this cross compiling environment has only /usr/local/lib stuff.  Chromeos environment contains such /usr/lib stuff.

I may enhance this system or use dockcross for such purpose, but it's not finished yet.

Details
-------

All binary and shared libraries are compiled with appropriate -rpath options.

|chipset|uname -m|rpaths|
|:---:|:---:|---|
|armv7l|armv7l|/usr/local/lib|
|x86|i686|/usr/local/lib|
|x64|x86\_64|/usr/local/lib:/usr/local/lib64|

License
-------

Copyright 2016 Kazushi (Jam) Marukawa

This project including all of its source files is released under the terms of [GNU General Public License (version 3 or later)](http://www.gnu.org/licenses/gpl.txt)

Thanks lyxell for [GCC/musl toolchains for Chrome OS](https://github.com/lyxell/chromeos-gcc-toolchains)
