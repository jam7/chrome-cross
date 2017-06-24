ORG = jam7
NPROCS = `nproc`
VERSION = v1.7

PACKAGES = $(TOOLCHAINS) $(BINARIES)
PACKAGES_SH_ARMV7 = $(TOOLCHAINS_SH_ARMV7) $(BINARIES_SH_ARMV7)
PACKAGES_SH_ARMV8 = $(TOOLCHAINS_SH_ARMV8) $(BINARIES_SH_ARMV8)
PACKAGES_SH_X64 = $(TOOLCHAINS_SH_X64) $(BINARIES_SH_X64)
PACKAGES_SH_X86 = $(TOOLCHAINS_SH_X86) $(BINARIES_SH_X86)
PACKAGES_ARMV7 = $(TOOLCHAINS_ARMV7) $(BINARIES_ARMV7)
PACKAGES_ARMV8 = $(TOOLCHAINS_ARMV8) $(BINARIES_ARMV8)
PACKAGES_X64 = $(TOOLCHAINS_X64) $(BINARIES_X64)
PACKAGES_X86 = $(TOOLCHAINS_X86) $(BINARIES_X86)

# TOOLCHAINS are ordered belong to dependency order

TOOLCHAINS = linux-headers binutils gmp mpfr mpc isl cloog gcc glibc glibc219
TOOLCHAINS_SH_ARMV7 = $(TOOLCHAINS:%=cross-armv7/%.sh)
TOOLCHAINS_SH_ARMV8 = $(TOOLCHAINS:%=cross-armv8/%.sh)
TOOLCHAINS_SH_X64 = $(TOOLCHAINS:%=cross-x64/%.sh)
TOOLCHAINS_SH_X86 = $(TOOLCHAINS:%=cross-x86/%.sh)
TOOLCHAINS_ARMV7 = $(TOOLCHAINS:%=cross-armv7/%.image)
TOOLCHAINS_ARMV8 = $(TOOLCHAINS:%=cross-armv8/%.image)
TOOLCHAINS_X64 = $(TOOLCHAINS:%=cross-x64/%.image)
TOOLCHAINS_X86 = $(TOOLCHAINS:%=cross-x86/%.image)

# BINARIES are ordered belong to dependency order

BINARIES = zlib openssl libssh2 curl expat git ncursesw ncurses readline gmp ruby make
BINARIES_SH_ARMV7 = $(BINARIES:%=cross-armv7/%.sh)
BINARIES_SH_ARMV8 = $(BINARIES:%=cross-armv8/%.sh)
BINARIES_SH_X64 = $(BINARIES:%=cross-x64/%.sh)
BINARIES_SH_X86 = $(BINARIES:%=cross-x86/%.sh)
BINARIES_ARMV7 = $(BINARIES:%=cross-armv7/%.image)
BINARIES_ARMV8 = $(BINARIES:%=cross-armv8/%.image)
BINARIES_X64 = $(BINARIES:%=cross-x64/%.image)
BINARIES_X86 = $(BINARIES:%=cross-x86/%.image)

usage:
	@echo
	@echo "In order to make cross compiling environment on docker, type"
	@echo "   $$ make cross-armv7|cross-armv8|cross-x64|cross-x86|cross"
	@echo
	@echo "In order to make compiled packages for each architecture, type either"
	@echo "   $$ make armv7|armv8|x64|x86|all"
	@echo
	@echo "Currently creates "'"'"${PACKAGES}"'"'" only"
	@echo

.SUFFIXES: .sh.in .sh .image

clean:
	rm -rf cross-armv7/* cross-x86/* cross-x64/* dist/*

#
# Create compiled packages by
#

all: armv7 armv8 x64 x86
toolchains: armv7-toolchains armv8-toolchains x64-toolchains x86-toolchains
binaries: armv7-binaries armv8-binaries x64-binaries x86-binaries

cross-armv7/%.sh: packages/%.sh.in
	cpp -DCHROMEBREW_ARMV7 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

cross-armv8/%.sh: packages/%.sh.in
	cpp -DCHROMEBREW_ARMV8 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

cross-x64/%.sh: packages/%.sh.in
	cpp -DCHROMEBREW_X64 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

cross-x86/%.sh: packages/%.sh.in
	cpp -DCHROMEBREW_X86 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

${PACKAGES_SH_ARMV7} ${PACKAGES_SH_ARMV8} ${PACKAGES_SH_X64} ${PACKAGES_SH_X86}: env.docker

cross-armv7/%.image: cross-armv7/%.sh
	docker run -it --rm -v $(PWD)/cross-armv7:/work/cross-armv7 -v $(PWD)/dist:/dist \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e ftp_proxy=${ftp_proxy} \
		-e NPROCS=${NPROCS} \
		$(ORG)/cross-armv7 /bin/bash /work/$<
	touch $@

cross-armv8/%.image: cross-armv8/%.sh
	docker run -it --rm -v $(PWD)/cross-armv8:/work/cross-armv8 -v $(PWD)/dist:/dist \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e ftp_proxy=${ftp_proxy} \
		-e NPROCS=${NPROCS} \
		$(ORG)/cross-armv8 /bin/bash /work/$<
	touch $@

cross-x64/%.image: cross-x64/%.sh
	docker run -it --rm -v $(PWD)/cross-x64:/work/cross-x64 -v $(PWD)/dist:/dist \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e ftp_proxy=${ftp_proxy} \
		-e NPROCS=${NPROCS} \
		$(ORG)/cross-x64 /bin/bash /work/$<
	touch $@

cross-x86/%.image: cross-x86/%.sh
	docker run -it --rm -v $(PWD)/cross-x86:/work/cross-x86 -v $(PWD)/dist:/dist \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e ftp_proxy=${ftp_proxy} \
		-e NPROCS=${NPROCS} \
		$(ORG)/cross-x86 /bin/bash /work/$<
	touch $@

armv7: $(PACKAGES_ARMV7)
armv8: $(PACKAGES_ARMV8)
x64: $(PACKAGES_X64)
x86: $(PACKAGES_X86)
armv7-toolchains: $(TOOLCHAINS_ARMV7)
armv8-toolchains: $(TOOLCHAINS_ARMV8)
x64-toolchains: $(TOOLCHAINS_X64)
x86-toolchains: $(TOOLCHAINS_X86)
armv7-binaries: $(BINARIES_ARMV7)
armv8-binaries: $(BINARIES_ARMV8)
x64-binaries: $(BINARIES_X64)
x86-binaries: $(BINARIES_X86)

$(PACKAGES_ARMV7) $(PACKAGES_ARMV8) $(PACKAGES_X64) $(PACKAGES_X86): dist/create_package.sh

dist/create_package.sh: create_package.sh
	cp $? $@

#
# Create cross compiling environment by
#

cross: cross-armv7 cross-armv8 cross-x64 cross-x86

cross-armv7: cross-armv7/image
cross-armv7/image:cross-armv7/Dockerfile
	docker build -t $(ORG)/cross-armv7 \
	       --build-arg http_proxy=$(http_proxy) \
	       --build-arg https_proxy=$(https_proxy) \
	       --build-arg ftp_proxy=$(ftp_proxy) \
	       --build-arg NPROCS=$(NPROCS) \
		cross-armv7
	touch $@
cross-armv7/Dockerfile: Dockerfile.in env.docker
	cpp -DCHROMEBREW_ARMV7 -Ulinux -P -o $@ Dockerfile.in

cross-armv8: cross-armv8/image
cross-armv8/image:cross-armv8/Dockerfile
	docker build -t $(ORG)/cross-armv8 \
	       --build-arg http_proxy=$(http_proxy) \
	       --build-arg https_proxy=$(https_proxy) \
	       --build-arg ftp_proxy=$(ftp_proxy) \
	       --build-arg NPROCS=$(NPROCS) \
		cross-armv8
	touch $@
cross-armv8/Dockerfile: Dockerfile.in env.docker
	cpp -DCHROMEBREW_ARMV8 -Ulinux -P -o $@ Dockerfile.in

cross-x64: cross-x64/image
cross-x64/image: cross-x64/Dockerfile
	docker build -t $(ORG)/cross-x64 \
	       --build-arg http_proxy=$(http_proxy) \
	       --build-arg https_proxy=$(https_proxy) \
	       --build-arg ftp_proxy=$(ftp_proxy) \
	       --build-arg NPROCS=$(NPROCS) \
		cross-x64
	touch $@
cross-x64/Dockerfile: Dockerfile.in env.docker
	cpp -DCHROMEBREW_X64 -Ulinux -P -o $@ Dockerfile.in

cross-x86: cross-x86/image
cross-x86/image: cross-x86/Dockerfile
	docker build -t $(ORG)/cross-x86 \
	       --build-arg http_proxy=$(http_proxy) \
	       --build-arg https_proxy=$(https_proxy) \
	       --build-arg ftp_proxy=$(ftp_proxy) \
	       --build-arg NPROCS=$(NPROCS) \
		cross-x86
	touch $@
cross-x86/Dockerfile: Dockerfile.in env.docker
	cpp -DCHROMEBREW_X86 -Ulinux -P -o $@ Dockerfile.in

dockertag:
	docker tag $(ORG)/cross-armv7 $(ORG)/cross-armv7:$(VERSION)
	docker tag $(ORG)/cross-armv8 $(ORG)/cross-armv8:$(VERSION)
	docker tag $(ORG)/cross-x64 $(ORG)/cross-x64:$(VERSION)
	docker tag $(ORG)/cross-x86 $(ORG)/cross-x86:$(VERSION)

dockerpush:
	docker push $(ORG)/cross-armv7
	docker push $(ORG)/cross-armv8
	docker push $(ORG)/cross-x64
	docker push $(ORG)/cross-x86


FORCE:
.PHONY: all clean FORCE armv7 armv8 x64 x86 armv7-toolchains armv8-toolchains x64-toolchains x86-toolchains armv7-binaries armv8-binaries x64-binaries x86-binaries cross
