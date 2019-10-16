################################################################################
#
# uniphier-bl
#
################################################################################

UNIPHIER_BL_VERSION = "a8abf989f68fb5bf02a79fdca7b87d356c0866a8"
UNIPHIER_BL_SITE = $(call github,uniphier,uniphier-bl,$(UNIPHIER_BL_VERSION))

UNIPHIER_BL_LICENSE = GPL-2.0
UNIPHIER_BL_LICENSE_FILES = LICENSE

UNIPHIER_BL_IMAGES = bl_ld20_global.bin
UNIPHIER_BL_BL2_IMAGE = $(BINARIES_DIR)/bl2.bin.gz
UNIPHIER_BL_ROM_IMAGE = unph_bl.bin

UNIPHIER_BL_DEPENDENCIES = arm-trusted-firmware

ifeq ($(BR2_CCACHE),y)
	UNIPHIER_BL_BUILD_OPTS += CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)"
else
	UNIPHIER_BL_BUILD_OPTS += CROSS_COMPILE="$(TARGET_CROSS)"
endif

define UNIPHIER_BL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(UNIPHIER_BL_BUILD_OPTS) -C $(@D)
	cat $(@D)/$(UNIPHIER_BL_IMAGES) $(UNIPHIER_BL_BL2_IMAGE) > $(@D)/$(UNIPHIER_BL_ROM_IMAGE)
endef

define UNIPHIER_BL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/$(UNIPHIER_BL_ROM_IMAGE) $(BINARIES_DIR)
endef

$(eval $(generic-package))
