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

LOCAL_PATH:= $(call my-dir)

.PHONY: luneos-hybris-hal luneos-hybris-common

luneos-hybris-common: bootimage \
                      servicemanager \
		      logcat updater init adb adbd linker \
		      libc \
		      libEGL libGLESv1_CM libGLESv2 \
		      libcamera_compat_layer camera_service libis_compat_layer

ifeq ("$(TARGET_ARCH)", "arm64")
luneos-hybris-hal: luneos-hybris-common linker_32 libc_32 libEGL_32 libGLESv1_CM_32 libGLESv2_32
else
luneos-hybris-hal: luneos-hybris-common
endif

