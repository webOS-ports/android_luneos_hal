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
ARCHIVE_NAME := hal-droid-wop-$(TARGET_DEVICE).tar
ARCHIVE_NAME_COMPRESSED := hal-droid-wop-$(TARGET_DEVICE).tar.bz2

.PHONY: luneos-hybris-hal luneos-hybris-common luneos-hybris-camera

luneos-hybris-camera: luneos-hybris-common libcamera_compat_layer libis_compat_layer camera_service
	# Deploy only the needed libs for camera
	@mkdir -p $(PRODUCT_OUT)/overlay-libs && chmod 755 $(PRODUCT_OUT)/overlay-libs
	@( cd $(PRODUCT_OUT) ; cp -v system/lib/{liblog.so,libcameraservice.so,libcamera_client.so,libmedia.so,libmediaplayerservice.so,libstagefright.so,libcamera_compat_layer.so,libmedia_compat_layer.so,libis_compat_layer.so} overlay-libs/ )
	@( cd $(PRODUCT_OUT) ; bunzip2 $(ARCHIVE_NAME_COMPRESSED); tar rvf $(ARCHIVE_NAME) overlay-libs/ system/bin/camera_service system/lib/libcamera_compat_layer.so system/lib/libmedia_compat_layer.so system/lib/libis_compat_layer.so ; bzip2 $(ARCHIVE_NAME) )

luneos-hybris-preliminary-cleanup:
	# Cleanup generated libs and symbols
	@rm -rf $(PRODUCT_OUT)/system/ $(PRODUCT_OUT)/symbols/

luneos-hybris-common: luneos-hybris-preliminary-cleanup \
		      bootimage \
		      servicemanager \
		      logcat updater init adb adbd linker \
		      libc \
		      libEGL libGLESv1_CM libGLESv2 \
	# Pack together all the system stuff we need and deploy the target into a tar.bz2 archive
	@( cd $(PRODUCT_OUT) ; cp `find obj -name filesystem_config.txt` $(PRODUCT_OUT) || touch filesystem_config.txt )
	@( cd $(PRODUCT_OUT) ; cp ramdisk.img android-ramdisk.img )
	@( cd $(PRODUCT_OUT) ; tar cvjf $(ARCHIVE_NAME_COMPRESSED) system symbols android-ramdisk.img filesystem_config.txt )

ifeq ("$(TARGET_ARCH)", "arm64")
luneos-hybris-hal: luneos-hybris-common luneos-hybris-camera linker_32 libc_32 libEGL_32 libGLESv1_CM_32 libGLESv2_32
else
luneos-hybris-hal: luneos-hybris-common luneos-hybris-camera
endif

