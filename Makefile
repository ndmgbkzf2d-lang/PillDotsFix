ARCHS = arm64
TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = pilldotsfix
pilldotsfix_FILES = Tweak.x
pilldotsfix_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += pilldotsfixprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
