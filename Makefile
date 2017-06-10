ORG = jam7
NPROCS = `nproc`

PACKAGES = linux-headers binutils gcc glibc
PACKAGES_ARMV8 = $(PACKAGES:%=cross-armv8/%.sh)
PACKAGES_ARMV7 = $(PACKAGES:%=cross-armv7/%.sh)
PACKAGES_X86 = $(PACKAGES:%=cross-x86/%.sh)
PACKAGES_X64 = $(PACKAGES:%=cross-x64/%.sh)
TRIGGER_ARMV8 = $(PACKAGES:%=cross-armv8/%.image)
TRIGGER_ARMV7 = $(PACKAGES:%=cross-armv7/%.image)
TRIGGER_X86 = $(PACKAGES:%=cross-x86/%.image)
TRIGGER_X64 = $(PACKAGES:%=cross-x64/%.image)

usage:
	@echo
	@echo "In order to make cross compiling environment on docker, type"
	@echo "   $$ make cross-armv7|cross-x86|cross-x64|cross"
	@echo
	@echo "In order to make compiled packages for each architecture, type either"
	@echo "   $$ make armv7|x86|x64|all"
	@echo
	@echo "Currently creates "'"'"${PACKAGES}"'"'" only"
	@echo

.SUFFIXES: .sh.in .sh .image

clean:
	rm -f packages/*.armv7.sh packages/*.x86.sh packages/*.x64.sh
	rm -rf cross-armv7/* cross-x86/* cross-x64/* dist/*

#
# Create compiled packages by
#

all: armv8 armv7 x86 x64

cross-armv8/%.sh: packages/%.sh.in
	cpp -DCHROMEBREW_ARMV8 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

cross-armv7/%.sh: packages/%.sh.in
	cpp -DCHROMEBREW_ARMV7 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

cross-x86/%.sh: packages/%.sh.in
	cpp -DCHROMEBREW_X86 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

cross-x64/%.sh: packages/%.sh.in
	cpp -DCHROMEBREW_X64 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

${PACKAGES_ARMV8} ${PACKAGES_ARMV7} ${PACKAGES_X86} ${PACKAGES_X64}: env.docker

cross-armv8/%.image: cross-armv8/%.sh
	docker run -it --rm -v $(PWD)/cross-armv8:/work/cross-armv8 -v $(PWD)/dist:/dist \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e ftp_proxy=${ftp_proxy} \
		-e NPROCS=${NPROCS} \
		$(ORG)/cross-armv8 /bin/bash /work/$<
	touch $@

cross-armv7/%.image: cross-armv7/%.sh
	docker run -it --rm -v $(PWD)/cross-armv7:/work/cross-armv7 -v $(PWD)/dist:/dist \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e ftp_proxy=${ftp_proxy} \
		-e NPROCS=${NPROCS} \
		$(ORG)/cross-armv7 /bin/bash /work/$<
	touch $@

cross-x86/%.image: cross-x86/%.sh
	docker run -it --rm -v $(PWD)/cross-x86:/work/cross-x86 -v $(PWD)/dist:/dist \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e ftp_proxy=${ftp_proxy} \
		-e NPROCS=${NPROCS} \
		$(ORG)/cross-x86 /bin/bash /work/$<
	touch $@

cross-x64/%.image: cross-x64/%.sh
	docker run -it --rm -v $(PWD)/cross-x64:/work/cross-x64 -v $(PWD)/dist:/dist \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e ftp_proxy=${ftp_proxy} \
		-e NPROCS=${NPROCS} \
		$(ORG)/cross-x64 /bin/bash /work/$<
	touch $@

armv8: $(PACKAGES_ARMV8) $(TRIGGER_ARMV8)

armv7: $(PACKAGES_ARMV7) $(TRIGGER_ARMV7)

x86: $(PACKAGES_X86) $(TRIGGER_X86)

x64: $(PACKAGES_X64) $(TRIGGER_X64)

$(TRIGGER_ARMV8) $(TRIGGER_ARMV7) $(TRIGGER_X86) $(TRIGGER_X64): dist/create_package.sh

dist/create_package.sh: create_package.sh
	cp $? $@

#
# Create cross compiling environment by
#

cross: cross-armv8 cross-armv7 cross-x86 cross-x64

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


FORCE:
.PHONY: all clean FORCE armv8 armv7 x86 x64 cross
