################################################################################
#
# mali-kbase
#
################################################################################

MALI_KBASE_VERSION = akebi96/r28p0
MALI_KBASE_SITE = "https://github.com/96boards-akebi96/mali-kbase.git"
MALI_KBASE_SITE_METHOD = git
MALI_KBASE_LICENSE = GPL
MALI_KBASE_INSTALL_STAGING = YES

ifeq ($(BR2_aarch64), y)
KMOD_ARCH=arm64
else ifeq ($(BR2_arm), y)
KMOD_ARCH=arm
else
$(error Unsupported arch)
endif

MALI_KBASE_MAKE_OPTS = KERNEL_DIR=$(LINUX_DIR) ARCH=$(KMOD_ARCH)
MALI_KBASE_MAKE_OPTS += MAKETOP="$(TARGET_DIR)"
MALI_KBASE_MAKE_OPTS += CROSS_COMPILE="$(TARGET_CROSS)"

# patch to use local src package
define MALI_KBASE_RSYNC_AFTER_PATCH
	$(MAKE) $(MALI_KBASE_TARGET_PATCH)
endef
MALI_KBASE_POST_RSYNC_HOOKS += MALI_KBASE_RSYNC_AFTER_PATCH

define MALI_KBASE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MALI_KBASE_MAKE_OPTS) modules
endef

define MALI_KBASE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MALI_KBASE_MAKE_OPTS) modules_install
endef

$(eval $(generic-package))
