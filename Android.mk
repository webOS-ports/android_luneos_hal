#
# Copyright (c) 2017 Christophe Chapuis <chris.chapuis@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

#---------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := luneos-hybris-camera
LOCAL_MODULE_CLASS := ROOT
LOCAL_MODULE_SUFFIX := .tar
LOCAL_MODULE_PATH := $(PRODUCT_OUT)

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): libcamera_compat_layer libis_compat_layer camera_service
	@echo "Deploy needed libs for camera_service in $(dir $@)."
	@mkdir -p $(dir $@)
	@rm -rf $@
	mkdir -p $(dir $@)/overlay-libs && chmod 755 $(dir $@)/overlay-libs
	cp $(PRODUCT_OUT)/system/lib/{liblog.so,libcameraservice.so,libcamera_client.so,libgui.so,libbinder.so,libmedia.so,libmediaplayerservice.so,libstagefright.so,libcamera_compat_layer.so,libmedia_compat_layer.so,libis_compat_layer.so} $(dir $@)/overlay-libs/
	mkdir -p $(dir $@)/system/bin && chmod -R 755 $(dir $@)/system
	cp $(PRODUCT_OUT)/system/bin/camera_service $(dir $@)/system/bin/camera_service 
	(cd $(dir $@) ; tar cvf $@ overlay-libs/ system/bin/camera_service )

#---------------------------------------------------------------

ifeq ("$(TARGET_ARCH)", "arm64")
luneos-hybris-common: ramdisk \
		      servicemanager \
		      logcat updater init adb adbd linker \
		      libc \
		      libEGL libGLESv1_CM libGLESv2 \
		      linker_32 libc_32 libEGL_32 libGLESv1_CM_32 libGLESv2_32
else
luneos-hybris-common: ramdisk \
		      servicemanager \
		      logcat updater init adb adbd linker \
		      libc \
		      libEGL libGLESv1_CM libGLESv2
endif

#---------------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := luneos-hybris-hal
LOCAL_MODULE_CLASS := ROOT
LOCAL_MODULE_SUFFIX := .tar
LOCAL_MODULE_PATH := $(PRODUCT_OUT)

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): luneos-hybris-common
	@echo "Pack together all bionic-dependant binaries we need into $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	cp `find $(PRODUCT_OUT)/obj -name filesystem_config.txt` $(PRODUCT_OUT) || touch $(PRODUCT_OUT)/filesystem_config.txt
	cp $(PRODUCT_OUT)/ramdisk.img $(PRODUCT_OUT)/android-ramdisk.img
	@( cd $(PRODUCT_OUT) ; tar cvf $@ system symbols android-ramdisk.img filesystem_config.txt )

