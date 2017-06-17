chrome-cross
============
Toolchain builder for chromebrew

**Support X86, X86-64, ARM and AARCH64 chipsets, but not tested on AARCH64 yet**

Overview
--------

Made building environment of toolchains for all chromebook chipsets for the ease of maintenance.

Prerequisites
-------------

You will need a 64 bits linux box with docker implemented.

Usage
-----

Make packages using cross compiler by following commands.  This may download docker images for cross comppiler.

    make armv7 | armv8 | x64 | x86 | all

You will get toolchains under dist directory.

```
$ ls dist
binutils-2.25-chromeos-armv7l.tar.xz       glibc-2.19-chromeos-armv7l.tar.xz          linux-headers-3.18-chromeos-armv7l.tar.xz.sha1
binutils-2.25-chromeos-armv7l.tar.xz.sha1  glibc-2.19-chromeos-armv7l.tar.xz.sha1     linux-headers-3.18-chromeos-i686.tar.xz
binutils-2.25-chromeos-i686.tar.xz         glibc-2.19-chromeos-i686.tar.xz            linux-headers-3.18-chromeos-i686.tar.xz.sha1
binutils-2.25-chromeos-i686.tar.xz.sha1    glibc-2.19-chromeos-i686.tar.xz.sha1       linux-headers-3.18-chromeos-x86_64.tar.xz
binutils-2.25-chromeos-x86_64.tar.xz       glibc-2.19-chromeos-x86_64.tar.xz          linux-headers-3.18-chromeos-x86_64.tar.xz.sha1
binutils-2.25-chromeos-x86_64.tar.xz.sha1  glibc-2.19-chromeos-x86_64.tar.xz.sha1     mpc-1.0.3-chromeos-armv7l.tar.xz
cloog-0.18.4-chromeos-armv7l.tar.xz        gmp-6.1.2-chromeos-armv7l.tar.xz           mpc-1.0.3-chromeos-armv7l.tar.xz.sha1
cloog-0.18.4-chromeos-armv7l.tar.xz.sha1   gmp-6.1.2-chromeos-armv7l.tar.xz.sha1      mpc-1.0.3-chromeos-i686.tar.xz
cloog-0.18.4-chromeos-i686.tar.xz          gmp-6.1.2-chromeos-i686.tar.xz             mpc-1.0.3-chromeos-i686.tar.xz.sha1
cloog-0.18.4-chromeos-i686.tar.xz.sha1     gmp-6.1.2-chromeos-i686.tar.xz.sha1        mpc-1.0.3-chromeos-x86_64.tar.xz
cloog-0.18.4-chromeos-x86_64.tar.xz        gmp-6.1.2-chromeos-x86_64.tar.xz           mpc-1.0.3-chromeos-x86_64.tar.xz.sha1
cloog-0.18.4-chromeos-x86_64.tar.xz.sha1   gmp-6.1.2-chromeos-x86_64.tar.xz.sha1      mpfr-3.1.5-chromeos-armv7l.tar.xz
create_package.sh                          isl-0.14.1-chromeos-armv7l.tar.xz          mpfr-3.1.5-chromeos-armv7l.tar.xz.sha1
gcc-4.9.x-chromeos-armv7l.tar.xz           isl-0.14.1-chromeos-armv7l.tar.xz.sha1     mpfr-3.1.5-chromeos-i686.tar.xz
gcc-4.9.x-chromeos-armv7l.tar.xz.sha1      isl-0.14.1-chromeos-i686.tar.xz            mpfr-3.1.5-chromeos-i686.tar.xz.sha1
gcc-4.9.x-chromeos-i686.tar.xz             isl-0.14.1-chromeos-i686.tar.xz.sha1       mpfr-3.1.5-chromeos-x86_64.tar.xz
gcc-4.9.x-chromeos-i686.tar.xz.sha1        isl-0.14.1-chromeos-x86_64.tar.xz          mpfr-3.1.5-chromeos-x86_64.tar.xz.sha1
gcc-4.9.x-chromeos-x86_64.tar.xz           isl-0.14.1-chromeos-x86_64.tar.xz.sha1
gcc-4.9.x-chromeos-x86_64.tar.xz.sha1      linux-headers-3.18-chromeos-armv7l.tar.xz
```

Packages
--------

Made following packages for armv7, armv8, x64 and x86.

    linuxheaders, binutils, glibc, gmp, mpfr, mpc, isl, cloog, gcc, libssh2, git and ruby

Other packages
--------------

I would like to compile other packages also using this environemt, but it is difficult to do so since it requires Chromeos environment.  For example, a package may require /usr/lib/libcrypt.so, but this cross compiling environment has only /usr/local/lib stuff.  Chromeos environment contains such /usr/lib stuff.

I may enhance this system or use dockcross for such purpose, but it's not finished yet.

RPATH configuration
-------------------

All binary and shared libraries are compiled with appropriate -rpath options like below.

|chipset|uname -m|rpaths|
|:---:|:---:|---|
|armv7|armv7l|/usr/local/lib|
|armv8|aarch64|/usr/local/lib:/usr/local/lib64|
|x64|x86\_64|/usr/local/lib:/usr/local/lib64|
|x86|i686|/usr/local/lib|

I'm not sure what I should do for /usr/local/lib32, so I'm currently not using it.

Cross Compiler
--------------

If you would like to create cross compiler by your self, use following commands.

    make cross-armv7 | cross-armv8 | cross-x64 | cross-x86 | cross

Version Hitory
--------------

|Version|Description|
|:---:|---|
|v1.7|Add libssh2, git and ruby|
|v1.6|Change to use gcc-4.9.4|
|v1.5|Change to use gcc-7.1.0|
|v1.4|Change armv8 configuration to use armv7 configuration|
|v1.3|Remove static libraries|
|v1.2|Add FORTRAN|
|v1.1|Change to use isl and cloog for gcc|
|v1.0|First release|

License
-------

@ 2016-2017 Kazushi (Jam) Marukawa, All rights reserved.

This project including all of its source files is released under the terms of [GNU General Public License (version 3 or later)](http://www.gnu.org/licenses/gpl.txt)

Thanks lyxell for [GCC/musl toolchains for Chrome OS](https://github.com/lyxell/chromeos-gcc-toolchains)
