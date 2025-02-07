#
# $Id: makefile 45721 2021-12-22 09:51:16Z steneker $
#
# (c) 2003-2019  Tiobe Software BV -- All rights reserved
#

.SILENT:

## Name of program:

TARGET = GawlKeeper
ADDITIONALTARGETS = 
AGDLS = $(TARGET) $(ADDITIONALTARGETS)
FRONTFILES = $(addprefix Grammar/,$(addsuffix .front,$(ADDITIONALTARGETS)))
SVNVERSION := $(shell svn info .. | sed -n "s/Last Changed Rev: //p" || echo "0.1")

## Root of the elegant release:
ELEGANTROOT=/home/elegant/7.2g

## Switches for tools:
STATICSEMANTICS = StaticSemantics
FrontSWITCHES = -tf $(STATICSEMANTICS) -preserve_comment -genprint
ElegantSWITCHES = -lalr -unused -localtypes -s100 -noparseroot
ScanGenSWITCHES	= -7.0 -compact
DiagramsSWITCHES =

## Additional C-compiler switches:

ifeq ($(ARCH),win64)
CSWITCHES = \
  -Wno-unused-but-set-variable -Wno-unused-variable -Wno-uninitialized \
  -Wno-type-limits
EXT = .exe
else ifeq ($(ARCH),linux64)
CSWITCHES = \
  -Wno-unused-but-set-variable -Wno-unused-variable -Wno-uninitialized \
  -Wno-type-limits
else ifeq ($(ARCH),linux)
CSWITCHES = \
  -Wno-unused-but-set-variable -Wno-unused-variable -Wno-uninitialized \
  -Wno-type-limits
else ifeq ($(ARCH),macos64)
#CSWITCHES = \
  -Wno-unused-value -Wno-unused-variable -Wno-uninitialized \
  -Wno-type-limits -Wno-parentheses-equality -Wcast-align #-Wno-cast-align
CSWITCHES = \
  -Wno-unused-value -Wno-unused-variable -Wno-uninitialized \
  -Wno-type-limits -Wcast-align -Wno-unused-but-set-variable -Wno-implicit-fallthrough
else ifeq ($(ARCH),macos)
CSWITCHES = \
  -Wno-unused-value -Wno-unused-variable -Wno-uninitialized \
  -Wno-type-limits -Wno-parentheses-equality
else ifeq ($(ARCH),win32)
CSWITCHES = \
  -Wno-unused-but-set-variable -Wno-unused-variable -Wno-uninitialized \
  -Wno-type-limits
#CSWITCHES = -DGC_NOT_DLL
EXT = .exe
else ifeq ($(ARCH),sunos)
# sunos
CSWITCHES = -DGC_NOT_DLL
endif

############################

## If you need additional libraries:
##   1 : specify where the Elegant compiler can find the .spec files:
##        USERCGNLIB = "<directory containing the .spec files>"
##        this may also be a list of colon-separated directories
##   2 : specify where the ANSI-C compiler can find the .h files
##        USERCLIB = "<directory containing the .h files>"
##        this may also be a list of colon-separated directories
##   3 : specify where the linker can find the pre-compiled library
##       (note the -ld in front of these switches!)
##        LDSWITCHES = -ld -L<directory containing the library files> \
##                     -ld -l<name of library file> ...
##        repeat the last two switches as many times as needed. (see
##        also the ld manual pages)
##
## Example: How to use the Generic library (simply uncomment these lines
##          if you want to use this library)
## This library is located in the directory ${ELEGANTROOT}/lib/generic.
## All .spec and .h files are located there. There are usually three
## versions available per platform: an optimized version, a debug version
## and a version meant for profiling, corresponding to the targets debug,
## optimize and profile. Which one is used is communicated through the
## make macro SUBLIB. This explains the odd LDSWITCHES line
##
GENERIC = ${ELEGANTROOT}/lib/generic

VERSIONCGNLIB := $(CURDIR)/../version
VERSIONCLIB := $(VERSIONCGNLIB)/Generated

COMMONCGNLIB := $(CURDIR)/../common
COMMONCLIB := $(COMMONCGNLIB)/Generated

USERCGNLIB = "${GENERIC}":$(VERSIONCGNLIB):$(COMMONCGNLIB)
USERCLIB   = "${GENERIC}":$(VERSIONCLIB):$(COMMONCLIB)
ifeq ($(ARCH),win64)
RESOURCEDIR = $(CURDIR)/../resources/tiobe
LDRESOURCE = -ld $(RESOURCEDIR)/tiobe.o
else ifeq ($(ARCH),win32)
RESOURCEDIR = $(CURDIR)/../resources/tiobe
LDRESOURCE = -ld $(RESOURCEDIR)/tiobe.o
else
LDRESOURCE =
endif
LDSWITCHES = $(LDRESOURCE) \
             -ld -L${GENERIC}/${TARCH}/${SUBLIB} -ld -lgeneric \
             -ld -L$(VERSIONCLIB)/$(TARCH)/$(SUBLIB) -ld -lversion \
             -ld -L$(COMMONCLIB)/$(TARCH)/$(SUBLIB) -ld -lcommon

BUILDCFG := optimize

# To run a debug build:
#   make BUILDCFG=debug
# To run a profile build:
#   make BUILDCFG=profile

.PHONY: default version common txc realclean patch_scanfile patch_scanner \
        make_scanfile_patch make_scanner_patch make_frontfile_patch test \
        resources info clean_info package clean_package relnotes \
        clean_relnotes publish

default: version common resources txc

version:
	$(MAKE) ARCH=$(ARCH) -C $(VERSIONCGNLIB) lib$(BUILDCFG)

common:
	$(MAKE) ARCH=$(ARCH) -C $(COMMONCGNLIB) lib$(BUILDCFG)

resources:
ifeq ($(ARCH),win64)
	$(MAKE) ARCH=$(ARCH) -C $(RESOURCEDIR)
else ifeq ($(ARCH),win32)
	$(MAKE) ARCH=$(ARCH) -C $(RESOURCEDIR)
endif

txc: $(FRONTFILES) from_front patch_scanfile patch_scanner $(BUILDCFG)

realclean: clean
	rm -f CGN/$(STATICSEMANTICS).{impl,spec}
	rm -f Grammar/GawlKeeper.{agdl,scan}
	$(MAKE) ARCH=$(ARCH) -C $(COMMONCGNLIB) clean
	$(MAKE) ARCH=$(ARCH) -C $(VERSIONCGNLIB) clean

test:
	./testall

# replace the .front by .arch if you do not want to use Front
include ${ELEGANTROOT}/lib/include/makefile.front

Grammar/%.front:: %.front.patch
	-patch -N -p0 -o $@ < $<
	t=$<; t=$${t%.front.patch}; make TARGET=$${t} from_front

# patch_scanfile: $(addprefix $(GENERATED)/,$(addsuffix .scan,$(AGDLS))) $(addsuffix .scan.patch,$(AGDLS))
# 	-patch -N -p0 -F0 < $(TARGET).scan.patch
# 
# make_scanfile_patch: $(addprefix $(GENERATED)/,$(addsuffix .scan,$(AGDLS))) $(addprefix Grammar/,$(addsuffix .scan,$(AGDLS)))
# 	-diff -Naur $(GENERATED)/$(TARGET).scan Grammar/$(TARGET).scan > $(TARGET).scan.patch

info:
	sed -E -n 's|^\s*\#define\s*Versions_date\s*\(.*\"(.*)\"\)$$|\1|p' ../version/Generated/$(ARCH)/O/Versions.h | jq -R "{date:.}|.revision=\"$(SVNVERSION)\"|.version=\"r$(SVNVERSION)  (\(.date))\"|.compatible[0]=\"2021.2.1.43807\"|.compatible[1]=\"2021.3\"" > info.json

clean_info:
	rm -f info.json

package: clean_package realclean default info
	mkdir $(TARGET)
	cp $(TARGET).$(ARCH) $(TARGET)/$(TARGET)$(EXT)
	cp info.json $(TARGET)
	rm -f $(TARGET)-$(SVNVERSION)-$(ARCH).zip
	zip -r --symlinks $(TARGET)-$(SVNVERSION)-$(ARCH).zip $(TARGET)

clean_package:
	rm -rf $(TARGET)

# The SVN repository number from which revisions onwards one must
# collect release notes.
STARTREV := 1793

relnotes:
	svn log --xml -r $(SVNVERSION):$(STARTREV) | xsltproc -o $(TARGET)-relnotes.html svn-log.xslt -

clean_relnotes:
	rm -f $(TARGET)-relnotes.html

DEST = absolem:/home/wilde/ticsweb/pub/codecheckers/$(TARGET)
publish: package relnotes
	scp $(TARGET)-$(SVNVERSION)-$(ARCH).zip $(TARGET)-relnotes.html $(DEST)
