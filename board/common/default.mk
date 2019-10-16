
# ----------------------------------------
# Custom config for arm-trusted-firmware
# ----------------------------------------
ifeq ($(BR2_TARGET_ARM_TRUSTED_FIRMWARE),y)
BR2_TARGET_UBOOT_CONFIG_FRAGMENT_FILES+="$(BR2_EXTERNAL_BSP_PATH)/board/common/uboot/defconfig-with-armtf"

# I try to define dependencies here, but can not accept it.
# so I add this define into original arm-trusted-firmware.mk
# ifeq ($(BR2_PACKAGE_FIRMWARE_COMMON),y)
# ARM_TRUSTED_FIRMWARE_DEPENDENCIES += firmware_common
# ARM_TRUSTED_FIRMWARE_MAKE_OPTS += SCP_BL2=$(BINARIES_DIR)/stm_main_ref16.bin
# endif
ARM_TRUSTED_FIRMWARE_MAKE_OPTS += "FIP_GZIP=1"

ifeq ($(ARM_TRUSTED_FIRMWARE_PLATFORM),uniphier)
ARM_TRUSTED_FIRMWARE_MAKE_TARGETS += bl2_gzip
endif

define ARM_TRUSTED_FIRMWARE_INSTALL_IMAGES_CMDS
	cp -dpf $(@D)/build/$(ARM_TRUSTED_FIRMWARE_PLATFORM)/release/*.bin $(BINARIES_DIR)/ ; \
	if [ $(ARM_TRUSTED_FIRMWARE_PLATFORM) == "uniphier" ] ; then \
		if [ -e $(@D)/build/$(ARM_TRUSTED_FIRMWARE_PLATFORM)/release/bl2.bin.gz ] ; then \
			cp -dpf $(@D)/build/$(ARM_TRUSTED_FIRMWARE_PLATFORM)/release/bl2.bin.gz $(BINARIES_DIR)/ ; \
		fi ; \
	fi
endef

endif # ifeq ($(BR2_TARGET_ARM_TRUSTED_FIRMWARE),y)


# ----------------------------------------
# Custom config for Uboot
# ----------------------------------------
ifeq ($(BR2_TARGET_UBOOT),y)

# Use ccache for target build
ifeq ($(BR2_CCACHE),y)
	UBOOT_MAKE_OPTS += CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)"
endif # ifeq ($(BR2_CCACHE),y)

BR2_TARGET_UBOOT_CUSTOM_DTS_PATH+="$(BR2_EXTERNAL_BSP_PATH)/board/common/uboot/dts_rgmii"

define UBOOT_BUILD_CMDS                                                                                           
	$(if $(UBOOT_CUSTOM_DTS_PATH),
		cp -f $(UBOOT_CUSTOM_DTS_PATH) $(@D)/arch/$(UBOOT_ARCH)/dts/
	)
	if [ $(BR2_BSP_TARGET_ETHPHY) = "rgmii" ] ; then \
		echo "#include \"dts_rgmii\"" >> $(@D)/arch/$(UBOOT_ARCH)/dts/dts_ld20-global-v4.dts ; \
	fi
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) $(UBOOT_MAKE_OPTS) \
		$(UBOOT_MAKE_TARGET)
	$(if $(BR2_TARGET_UBOOT_FORMAT_SD),
		$(@D)/tools/mxsboot sd $(@D)/u-boot.sb $(@D)/u-boot.sd)
	$(if $(BR2_TARGET_UBOOT_FORMAT_NAND),
		$(@D)/tools/mxsboot \
			-w $(BR2_TARGET_UBOOT_FORMAT_NAND_PAGE_SIZE)	\
			-o $(BR2_TARGET_UBOOT_FORMAT_NAND_OOB_SIZE)		\
			-e $(BR2_TARGET_UBOOT_FORMAT_NAND_ERASE_SIZE)	\
			nand $(@D)/u-boot.sb $(@D)/u-boot.nand)
endef

# patch to use local src package
define UBOOT_RSYNC_AFTER_PATCH
	$(MAKE) $(UBOOT_TARGET_PATCH)
endef
UBOOT_POST_RSYNC_HOOKS += UBOOT_RSYNC_AFTER_PATCH

endif # ifeq ($(BR2_TARGET_UBOOT),y)


# ----------------------------------------
# Custom config for linux
# ----------------------------------------
ifeq ($(BR2_LINUX_KERNEL),y)

ifneq ($(BR2_BSP_TARGET_KCONFIG),)
LINUX_MAKE_FLAGS += "KBUILD_KCONFIG=$(BR2_BSP_TARGET_KCONFIG)"
endif # ifneq ($(BR2_BSP_TARGET_KCONFIG),)

# Use ccache for target build
ifeq ($(BR2_CCACHE),y)
	LINUX_MAKE_FLAGS += CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)"
endif # ifeq ($(BR2_CCACHE),y)

ifeq ($(BR2_LINUX_KERNEL_DTS_SUPPORT),y)

KERNEL_DTS_FULL_NAME += $(addprefix \
		$(KERNEL_ARCH_PATH)/boot/dts/,$(addsuffix .dts,$(KERNEL_DTS_NAME)))

define LINUX_BUILD_DTB
	$(LINUX_MAKE_ENV) $(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D) $(KERNEL_DTBS)
endef

endif # ifeq ($(BR2_LINUX_KERNEL_DTS_SUPPORT),y)
endif # ifeq ($(BR2_LINUX_KERNEL),y)
