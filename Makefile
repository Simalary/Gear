INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

TWEAK_NAME = Gear

Gear_FILES = Tweak.x
Gear_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
