################################################################################
#
# k_mod_video_out
#
################################################################################

K_MOD_VIDEO_OUT_VERSION = sni-release
K_MOD_VIDEO_OUT_SITE = "https://github.com/96boards-akebi96/kmod-video-out.git"
K_MOD_VIDEO_OUT_SITE_METHOD = git
K_MOD_VIDEO_OUT_LICENSE = GPL
K_MOD_VIDEO_OUT_INSTALL_STAGING = YES

ifeq ($(BR2_aarch64), y)
KMOD_ARCH=arm64
else ifeq ($(BR2_arm), y)
KMOD_ARCH=arm
else
$(error Unsupported arch)
endif

K_MOD_VIDEO_OUT_MAKE_OPTS = KERNEL_DIR=$(LINUX_DIR) ARCH=$(KMOD_ARCH)
K_MOD_VIDEO_OUT_MAKE_OPTS += MAKETOP="$(TARGET_DIR)"

ifeq ($(BR2_CCACHE),y)
	K_MOD_VIDEO_OUT_MAKE_OPTS += CROSS_COMPILE="\"$(CCACHE) $(TARGET_CROSS)\""
else
	K_MOD_VIDEO_OUT_MAKE_OPTS += CROSS_COMPILE="$(TARGET_CROSS)"
endif

# patch to use local src package
define K_MOD_VIDEO_OUT_RSYNC_AFTER_PATCH
	$(MAKE) $(K_MOD_VIDEO_OUT_TARGET_PATCH)
endef
K_MOD_VIDEO_OUT_POST_RSYNC_HOOKS += K_MOD_VIDEO_OUT_RSYNC_AFTER_PATCH

define K_MOD_VIDEO_OUT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(K_MOD_VIDEO_OUT_MAKE_OPTS) headers_install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(K_MOD_VIDEO_OUT_MAKE_OPTS) modules
endef

define K_MOD_VIDEO_OUT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(K_MOD_VIDEO_OUT_MAKE_OPTS) modules_install
endef

define K_MOD_VIDEO_OUT_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/vocdrv_ld20/vocd_driver.h $(BINARIES_DIR)/kernel-headers/asm/vocd_driver.h
endef

$(eval $(generic-package))
