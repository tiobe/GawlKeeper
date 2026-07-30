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
## SEMVER is normally supplied by the environment (CI sets this from
## GitVersion, see .github/workflows/build.yml). For local builds where
## nothing sets it, fall back to a lightweight approximation of GitVersion's
## own scheme: the latest reachable tag (same 'v' prefix as GitVersion.yml),
## plus a "-<n>" suffix for the number of commits since that tag (omitted
## when building the tag commit itself, i.e. n=0). No commit SHA is included.
## This is only ever a local-dev convenience -- CI always overrides it via
## the environment.
ifeq ($(SEMVER),)
GITDESCRIBE := $(shell git describe --tags --match 'v*' --long 2>/dev/null)
ifneq ($(GITDESCRIBE),)
SEMVER := $(shell echo '$(GITDESCRIBE)' | sed -E 's/^v([^-]+)-0-g[0-9a-fA-F]+$$/\1/; t; s/^v(.+)-([0-9]+)-g[0-9a-fA-F]+$$/\1-\2/')
else
SEMVER := 0.0.0-0
endif
endif

## If not main branch, add suffix
ifneq  ($(BRANCH),main)
FILESUFFIX = $(BRANCH)
else
FILESUFFIX =
endif

## Root of the elegant release; usually already set in the environment,
## but can be overridden on the command line, e.g.:
##   make ELEGANTROOT=/path/to/elegant-sdk

ELEGANTROOT ?= $(CURDIR)/../elegant-sdk

## Root of the elegant-common checkout (provides the common/version/resources
## CGN libraries); can be overridden on the command line, e.g.:
##   make ELEGANTCOMMON=/path/to/elegant-common

ELEGANTCOMMON ?= $(CURDIR)/../elegant-common

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

VERSIONCGNLIB := $(ELEGANTCOMMON)/version
VERSIONCLIB := $(VERSIONCGNLIB)/Generated

COMMONCGNLIB := $(ELEGANTCOMMON)/common
COMMONCLIB := $(COMMONCGNLIB)/Generated

USERCGNLIB = "${GENERIC}":$(VERSIONCGNLIB):$(COMMONCGNLIB)
USERCLIB   = "${GENERIC}":$(VERSIONCLIB):$(COMMONCLIB)
ifeq ($(ARCH),win64)
RESOURCEDIR = $(ELEGANTCOMMON)/resources/tiobe
LDRESOURCE = -ld $(RESOURCEDIR)/tiobe.o
else ifeq ($(ARCH),win32)
RESOURCEDIR = $(ELEGANTCOMMON)/resources/tiobe
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
        resources info clean_info package clean_package build_version \
        check-companions

default: check-companions version common resources build_version txc

## Compares the elegant-sdk/elegant-common checkouts sitting beside this repo
## (ELEGANTROOT/ELEGANTCOMMON) against the versions this repo is pinned to
## (.elegant-sdk-version / .elegant-common-version, kept current by
## check-elegant-common-release.yml's family of bump PRs). A companion
## checkout older than the pin may be missing fixes/behavior the pinned
## version assumes, so the build stops; one that's ahead only gets a
## warning, since a companion's main is expected to normally run ahead of
## the last version it was pinned at.
##
## Best-effort: silently skipped (with a warning) for a dependency that has
## no pin file yet, isn't a git checkout, or has no tag history reachable
## (e.g. a shallow clone) -- this check is aimed at local builds against a
## persistent sibling checkout, not CI, which always clones a fresh ref.
check-companions:
	for dep in elegant-sdk:$(ELEGANTROOT) elegant-common:$(ELEGANTCOMMON); do \
	  name=$${dep%%:*}; path=$${dep#*:}; \
	  pinned=$$(cat "$(CURDIR)/.$$name-version" 2>/dev/null || true); \
	  if [ -z "$$pinned" ]; then \
	    echo "warning: no .$$name-version pin recorded, skipping companion check for $$name"; \
	    continue; \
	  fi; \
	  if [ ! -d "$$path/.git" ]; then \
	    echo "warning: $$path is not a git checkout, skipping companion check for $$name"; \
	    continue; \
	  fi; \
	  current=$$(git -C "$$path" describe --tags --abbrev=0 2>/dev/null || true); \
	  if [ -z "$$current" ]; then \
	    echo "warning: could not determine $$name's checked-out version at $$path (shallow clone or no tags?), skipping companion check"; \
	    continue; \
	  fi; \
	  if [ "$$current" = "$$pinned" ]; then \
	    continue; \
	  fi; \
	  highest=$$(printf '%s\n%s\n' "$$pinned" "$$current" | sort -V | tail -1); \
	  if [ "$$highest" = "$$pinned" ]; then \
	    echo "error: $$name at $$path is $$current, older than the pinned $$pinned -- update that checkout (e.g. git -C $$path checkout $$pinned) before building"; \
	    exit 1; \
	  else \
	    echo "warning: $$name at $$path is $$current, newer than the pinned $$pinned -- continuing anyway"; \
	  fi; \
	done

## Bake SEMVER into the binary as a CGN unit (see elegant-common's
## BuildVersion.spec) instead of the old approach of reading it from the
## process environment at runtime -- which meant `-version` reported
## whatever SEMVER happened to be set in the caller's shell, not what was
## actually built. Always regenerated (.PHONY) so a changed SEMVER is
## picked up without requiring `make clean`.
build_version:
	printf '%s\n' \
	  'impl unit BuildVersion' \
	  '' \
	  'functions' \
	  '' \
	  'Get(): String' \
	  '{ return "$(SEMVER)" }' \
	  > CGN/BuildVersion.impl

## common/version/resources build order and configuration are owned by
## elegant-common's own top-level makefile; delegate to it instead of
## reaching into its subdirectories and duplicating that logic here.

version:
	$(MAKE) ARCH=$(ARCH) ELEGANTROOT=$(ELEGANTROOT) BUILDCFG=$(BUILDCFG) -C $(ELEGANTCOMMON) version

common:
	$(MAKE) ARCH=$(ARCH) ELEGANTROOT=$(ELEGANTROOT) BUILDCFG=$(BUILDCFG) -C $(ELEGANTCOMMON) common

resources:
	$(MAKE) ARCH=$(ARCH) ELEGANTROOT=$(ELEGANTROOT) -C $(ELEGANTCOMMON) resources

txc: $(FRONTFILES) from_front patch_scanfile patch_scanner $(BUILDCFG)

realclean: clean
	rm -f CGN/$(STATICSEMANTICS).{impl,spec}
	rm -f Grammar/GawlKeeper.{agdl,scan}
	$(MAKE) ARCH=$(ARCH) ELEGANTROOT=$(ELEGANTROOT) -C $(ELEGANTCOMMON) clean

test:
	cd test && ./all.sh

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
	sed -E -n 's|^\s*\#define\s*Versions_date\s*\(.*\"(.*)\"\)$$|\1|p' $(ELEGANTCOMMON)/version/Generated/$(ARCH)/O/Versions.h | jq -R "{date:.}|.revision=\"$(SEMVER)\"|.version=\"r$(SEMVER)  (\(.date))\"|.compatible[0]=\"2021.2.1.43807\"|.compatible[1]=\"2021.3\"" > info.json

clean_info:
	rm -f info.json

package: clean_package realclean default info
	mkdir $(TARGET)
	cp $(TARGET).$(ARCH) $(TARGET)/$(TARGET)$(EXT)
	cp info.json $(TARGET)
	rm -f $(TARGET)-$(SEMVER)-$(ARCH)$(FILESUFFIX).zip
	zip -r --symlinks $(TARGET)-$(SEMVER)-$(ARCH)$(FILESUFFIX).zip $(TARGET)

clean_package:
	rm -rf $(TARGET)
