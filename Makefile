ORG = chromebrew

#	       --build-arg http_proxy=$(http_proxy) \
#	       --build-arg https_proxy=$(https_proxy) \
#	       --build-arg ftp_proxy=$(ftp_proxy) \

PACKAGES = linux-headers binutils gcc
PACKAGES_ARMV7 = $(PACKAGES:%=packages/%.armv7.sh)
PACKAGES_X86 = $(PACKAGES:%=packages/%.x86.sh)
PACKAGES_X64 = $(PACKAGES:%=packages/%.x64.sh)
PACKAGES_RUN_ARMV7 = $(PACKAGES:%=packages/%.armv7)
PACKAGES_RUN_X86 = $(PACKAGES:%=packages/%.x86)
PACKAGES_RUN_X64 = $(PACKAGES:%=packages/%.x64)

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

.SUFFIXES: .sh.in .armv7.sh .x86.sh .x64.sh .armv7 .x86 .x64

clean:
	rm -f *.armv7.sh *.x86.sh *.x64.sh
	rm -rf cross-armv7 cross-x86 cross-x64

#
# Create compiled packages by
#

all: armv7 x86 x64

.sh.in.armv7.sh:
	cpp -DCHROMEBREW_ARMV7 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

.sh.in.x86.sh:
	cpp -DCHROMEBREW_X86 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

.sh.in.x64.sh:
	cpp -DCHROMEBREW_X64 -Ulinux -P -E $< | sed -e 's:ENV \([^ ]*\) :\1=:' > $@

${PACKAGES_ARMV7} ${PACKAGES_X86} ${PACKAGES_X64}: env.docker

.armv7.sh.armv7:
	docker run -it --rm -v $(PWD):/work -v $(PWD)/dist:/dist $(ORG)/cross-armv7 /bin/bash /work/$<

.x86.sh.x86:
	docker run -it --rm -v $(PWD):/work -v $(PWD)/dist:/dist $(ORG)/cross-x86 /bin/bash /work/$<

.x64.sh.x64:
	docker run -it --rm -v $(PWD):/work -v $(PWD)/dist:/dist $(ORG)/cross-x64 /bin/bash /work/$<

armv7: $(PACKAGES_ARMV7) $(PACKAGES_RUN_ARMV7)

x86: $(PACKAGES_X86) $(PACKAGES_RUN_X86)

x64: $(PACKAGES_X64) $(PACKAGES_RUN_X64)

#
# Create cross compiling environment by
#

cross: cross-armv7 cross-x86 cross-x64

cross-armv7: cross-armv7/Dockerfile
	docker build -t $(ORG)/cross-armv7 \
	       --build-arg http_proxy=$(http_proxy) \
	       --build-arg https_proxy=$(https_proxy) \
	       --build-arg ftp_proxy=$(ftp_proxy) \
		cross-armv7

cross-armv7/Dockerfile: Dockerfile.in env.docker
	-mkdir cross-armv7
	cpp -DCHROMEBREW_ARMV7 -Ulinux -P -o $@ Dockerfile.in

cross-x86: cross-x86/Dockerfile
	docker build -t $(ORG)/cross-x86 \
	       --build-arg http_proxy=$(http_proxy) \
	       --build-arg https_proxy=$(https_proxy) \
	       --build-arg ftp_proxy=$(ftp_proxy) \
		cross-x86

cross-x86/Dockerfile: Dockerfile.in env.docker
	-mkdir cross-x86
	cpp -DCHROMEBREW_X86 -Ulinux -P -o $@ Dockerfile.in

cross-x64: cross-x64/Dockerfile
	docker build -t $(ORG)/cross-x64 \
	       --build-arg http_proxy=$(http_proxy) \
	       --build-arg https_proxy=$(https_proxy) \
	       --build-arg ftp_proxy=$(ftp_proxy) \
		cross-x64

cross-x64/Dockerfile: Dockerfile.in env.docker
	-mkdir cross-x64
	cpp -DCHROMEBREW_X64 -Ulinux -P -o $@ Dockerfile.in


FORCE:
.PHONY: all clean FORCE armv7 x86 x64 cross cross-armv7 cross-x86 cross-x64
