
include $(sort $(wildcard $(BR2_EXTERNAL_BSP_PATH)/board/common/*.mk))

include $(sort $(wildcard $(BR2_EXTERNAL_BSP_PATH)/package/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_BSP_PATH)/boot/*/*.mk))
