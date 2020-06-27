################################################################################
#
# powervr-sdk
#
################################################################################

POWERVR_SDK_VERSION = R20.1-v5.5
POWERVR_SDK_SOURCE = $(POWERVR_SDK_VERSION).tar.gz
POWERVR_SDK_SITE = https://github.com/powervr-graphics/Native_SDK/archive
POWERVR_SDK_LICENSE = MIT
POWERVR_SDK_LICENSE_FILES = LICENSE.md
POWERVR_SDK_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_POWERVR_SDK_NULLWS),y)
POWERVR_SDK_WS = NullWS
else ifeq ($(BR2_PACKAGE_POWERVR_SDK_X11WS),y)
POWERVR_SDK_WS = X11
else ifeq ($(BR2_PACKAGE_POWERVR_SDK_XCBWS),y)
POWERVR_SDK_WS = XCB
else ifeq ($(BR2_PACKAGE_POWERVR_SDK_WAYLANDWS),y)
POWERVR_SDK_WS = Wayland
POWERVR_SDK_DEPENDENCIES += wayland
else ifeq ($(BR2_PACKAGE_POWERVR_SDK_SCREENWS),y)
POWERVR_SDK_WS = Screen
else
	$(error "No window system selected")
endif

ifeq ($(BR2_POWERVR_SDK_EXAMPLES),y)
POWERVR_SDK_CONF_OPTS += -DPVR_BUILD_EXAMPLES=ON
else
POWERVR_SDK_CONF_OPTS += -DPVR_BUILD_EXAMPLES=OFF
endif

POWERVR_SDK_CONF_OPTS += \
	-DPVR_WINDOW_SYSTEM=$(POWERVR_SDK_WS)

define POWERVR_SDK_INSTALL_HEADERS
	@$(call MESSAGE,"Installing EGL/GLES headers")
	cp -r $(@D)/include/* $(STAGING_DIR)/usr/include
endef

POWERVR_SDK_INSTALL_STAGING_CMDS += $(POWERVR_SDK_INSTALL_HEADERS)

ifeq ($(BR2_PACKAGE_POWERVR_SDK_HEADERS_ONLY),y)
$(eval $(generic-package))
else
$(eval $(cmake-package))
endif