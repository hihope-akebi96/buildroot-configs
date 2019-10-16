################################################################################
#
# romutils
#
################################################################################

ROMUTILS_VERSION = sni-release
ROMUTILS_SITE = "https://github.com/96boards-akebi96/romutils.git"
ROMUTILS_SITE_METHOD = git

ROMUTILS_DEPENDENCIES = host-uboot-tools

# The Git repository does not have the generated configure script and
# Makefile.
ROMUTILS_AUTORECONF = YES

ROMUTILS_CONF_OPTS = \
	--with-targetproc=$(BR2_BSP_TARGET_PROC) \
	--with-targetboard=$(BR2_BSP_TARGET_BOARD) \

ifeq ($(ANDROID),y)
ROMUTILS_CONF_OPTS += --with-subfeature=android
endif

ifeq ($(BR2_TARGET_ARM_TRUSTED_FIRMWARE),y)
ROMUTILS_CONF_OPTS += "--with-armtf=yes"
endif

ROMUTILS_CONF_ENV = \
	CC="" \
	MAKETOP="$(TARGET_DIR)"

ROMUTILS_BUILD_OPTS += MAKETOP="$(TARGET_DIR)"
ROMUTILS_BUILD_OPTS += MKIMAGE="$(HOST_DIR)/bin/mkimage"
ROMUTILS_BUILD_OPTS += OUTPUT_DIR="$(BINARIES_DIR)"

# patch to use local src package
define ROMUTILS_RSYNC_AFTER_PATCH
	$(MAKE) $(ROMUTILS_TARGET_PATCH)
endef
ROMUTILS_POST_RSYNC_HOOKS += ROMUTILS_RSYNC_AFTER_PATCH

define ROMUTILS_BUILD_CMDS
# Nothing to do
endef

define ROMUTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(ROMUTILS_BUILD_OPTS) install
endef

$(eval $(autotools-package))
