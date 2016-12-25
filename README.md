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

First, need to prepare cross compiling environment on docker by following commands.

    make cross-armv7 | cross-x86 | cross-x64 | cross

Then, make packages using above cross compiler by following commands.

    make armv7 | x86 | x64 | all

You will get toolchains under dist directory.

```
$ ls dist
binutils-2.25-chromeos-armv7l.tar.xz       gmp-5.1.2-chromeos-i686.tar.xz.sha1
binutils-2.25-chromeos-armv7l.tar.xz.sha1  gmp-5.1.2-chromeos-x86_64.tar.xz
binutils-2.25-chromeos-i686.tar.xz         gmp-5.1.2-chromeos-x86_64.tar.xz.sha1
binutils-2.25-chromeos-i686.tar.xz.sha1    linux-headers-3.14-chromeos-armv7l.tar.xz
binutils-2.25-chromeos-x86_64.tar.xz       linux-headers-3.14-chromeos-armv7l.tar.xz.sha1
binutils-2.25-chromeos-x86_64.tar.xz.sha1  linux-headers-3.4-chromeos-i686.tar.xz
create_package.sh                          linux-headers-3.4-chromeos-i686.tar.xz.sha1
gcc-4.9.x-chromeos-armv7l.tar.xz           linux-headers-3.8-chromeos-x86_64.tar.xz
gcc-4.9.x-chromeos-armv7l.tar.xz.sha1      linux-headers-3.8-chromeos-x86_64.tar.xz.sha1
gcc-4.9.x-chromeos-i686.tar.xz             mpc-1.0.1-chromeos-armv7l.tar.xz
gcc-4.9.x-chromeos-i686.tar.xz.sha1        mpc-1.0.1-chromeos-armv7l.tar.xz.sha1
gcc-4.9.x-chromeos-x86_64.tar.xz           mpc-1.0.1-chromeos-i686.tar.xz
gcc-4.9.x-chromeos-x86_64.tar.xz.sha1      mpc-1.0.1-chromeos-i686.tar.xz.sha1
glibc-2.17-chromeos-i686.tar.xz            mpc-1.0.1-chromeos-x86_64.tar.xz
glibc-2.17-chromeos-i686.tar.xz.sha1       mpc-1.0.1-chromeos-x86_64.tar.xz.sha1
glibc-2.17-chromeos-x86_64.tar.xz          mpfr-3.1.2-chromeos-armv7l.tar.xz
glibc-2.17-chromeos-x86_64.tar.xz.sha1     mpfr-3.1.2-chromeos-armv7l.tar.xz.sha1
glibc-2.19-chromeos-armv7l.tar.xz          mpfr-3.1.2-chromeos-i686.tar.xz
glibc-2.19-chromeos-armv7l.tar.xz.sha1     mpfr-3.1.2-chromeos-i686.tar.xz.sha1
gmp-5.1.2-chromeos-armv7l.tar.xz           mpfr-3.1.2-chromeos-x86_64.tar.xz
gmp-5.1.2-chromeos-armv7l.tar.xz.sha1      mpfr-3.1.2-chromeos-x86_64.tar.xz.sha1
gmp-5.1.2-chromeos-i686.tar.xz
```

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

All binary and shared libraries are compiled with appropriate -rpath options like below.

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
