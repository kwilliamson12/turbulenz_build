# Copyright (c) 2013 Turbulenz Limited.
# Released under "Modified BSD License".  See COPYING for full text.

XCODE_ROOT := /Applications/Xcode.app/Contents/Developer
XCODE_TOOLROOT := $(XCODE_ROOT)/Toolchains/XcodeDefault.xctoolchain
XCODE_PLATFORMS := $(XCODE_ROOT)/Platforms

ifeq (i386,$(ARCH))
  XCODE_PLATFORM := $(XCODE_PLATFORMS)/iPhoneSimulator.platform
  XCODE_SDK := iPhoneSimulator6.1.sdk
  CXXFLAGSPRE := -mios-simulator-version-min=5.0 \
    -fobjc-abi-version=2 \
    -fobjc-legacy-dispatch "-DIBOutlet=__attribute__((iboutlet))" \
    "-DIBOutletCollection(ClassName)=__attribute__((iboutletcollection(ClassName)))" \
    "-DIBAction=void)__attribute__((ibaction)"
else
  XCODE_PLATFORM := $(XCODE_PLATFORMS)/iPhoneOS.platform
  XCODE_SDK := iPhoneOS6.1.sdk
  CXXFLAGSPRE := -miphoneos-version-min=5.0
endif

XCODE_SDKROOT := $(XCODE_PLATFORM)/Developer/SDKs/$(XCODE_SDK)

CXX := $(XCODE_TOOLROOT)/usr/bin/clang
CMM := $(XCODE_TOOLROOT)/usr/bin/clang

CXXFLAGSPRE += -x objective-c++ \
  -arch $(ARCH) \
  -stdlib=libc++ \
  -fmessage-length=0 -fpascal-strings -fexceptions -fasm-blocks \
  -fvisibility=hidden -fvisibility-inlines-hidden \
  -Wall -Wno-c++11-extensions \
  -isysroot $(XCODE_SDKROOT) \
  -DTZ_IOS=1

CXXFLAGSPOST := \
    -c

CMMFLAGSPRE = $(CXXFLAGSPRE)
CMMFLAGSPOST = $(CXXFLAGSPOST)

# DEBUG / RELEASE

ifeq ($(CONFIG),debug)
  CXXFLAGSPRE += -g -O0 -D_DEBUG -DDEBUG
  CMMFLAGSPRE += -g -O0 -D_DEBUG -DDEBUG
else
  CXXFLAGSPRE += -g -O3 -DNDEBUG
  CMMFLAGSPRE += -g -O3 -DNDEBUG
endif

#
# LIBS
#

AR := $(XCODE_TOOLROOT)/usr/bin/libtool
ARFLAGSPRE := -static -arch_only $(ARCH) -syslibroot $(XCODE_SDKROOT) -g
arout := -o
ARFLAGSPOST :=

libprefix := lib
libsuffix := .a

#
# DLL
#

DLL := $(AR)
DLLFLAGSPRE :=
DLLFLAGSPOST :=
DLLFLAGS_LIBDIR :=
DLLFLAGS_LIB :=

dllprefix := lib
dllsuffix := .a
dll-post =

#
# APPS
#

LDFLAGS_LIBDIR := -L
LDFLAGS_LIB := -l
LD :=
LDFLAGSPRE :=
LDFLAGSPOST :=

app-post =

############################################################
