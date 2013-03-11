
THEOS_DEVICE_IP = 10.0.0.2
include theos/makefiles/common.mk

BUNDLE_NAME = Quickredeem
Quickredeem_FILES = QuickredeemController.m
Quickredeem_INSTALL_PATH = /Library/WeeLoader/Plugins
Quickredeem_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
