################################################################################
#
# k_mod_audio
#
################################################################################

K_MOD_AUDIO_VERSION = master
K_MOD_AUDIO_SITE = "https://github.com/96boards-akebi96/kmod-audio.git"
K_MOD_AUDIO_SITE_METHOD = git
K_MOD_AUDIO_LICENSE = GPL

ifeq ($(BR2_aarch64), y)
KMOD_ARCH=arm64
else ifeq ($(BR2_arm), y)
KMOD_ARCH=arm
else
$(error Unsupported arch)
endif

K_MOD_AUDIO_MAKE_OPTS = KERNEL_DIR=$(LINUX_DIR) ARCH=$(KMOD_ARCH)
K_MOD_AUDIO_MAKE_OPTS += MAKETOP="$(TARGET_DIR)"

ifeq ($(BR2_CCACHE),y)
	K_MOD_AUDIO_MAKE_OPTS += CROSS_COMPILE="\"$(CCACHE) $(TARGET_CROSS)\""
else
	K_MOD_AUDIO_MAKE_OPTS += CROSS_COMPILE="$(TARGET_CROSS)"
endif

# patch to use local src package
define K_MOD_AUDIO_RSYNC_AFTER_PATCH
	$(MAKE) $(K_MOD_AUDIO_TARGET_PATCH)
endef
K_MOD_AUDIO_POST_RSYNC_HOOKS += K_MOD_AUDIO_RSYNC_AFTER_PATCH

define K_MOD_AUDIO_MAKE_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(K_MOD_AUDIO_MAKE_OPTS) headers_install
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(K_MOD_AUDIO_MAKE_OPTS) modules
endef

define K_MOD_AUDIO_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(K_MOD_AUDIO_MAKE_OPTS) modules_install
endef

$(eval $(generic-package))
