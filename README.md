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

Other usage
-----------

I would like to compile other packages also with this, but it is difficult to do so since it requires Chromeos environment.  For example, a package may require /usr/lib/libcrypt.so, but this cross compiling environment has only /usr/local/lib stuff.  Chromeos environment contains such /usr/lib stuff.

I may enhance this system or use dockcross for such purpose, but it's not finished yet.

License
-------

Copyright 2016 Kazushi (Jam) Marukawa

This project including all of its source files is released under the terms of [GNU General Public License (version 3 or later)](http://www.gnu.org/licenses/gpl.txt)

Thanks lyxell for [GCC/musl toolchains for Chrome OS](https://github.com/lyxell/chromeos-gcc-toolchains)
