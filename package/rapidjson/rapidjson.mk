################################################################################
#
# rapidjson
#
################################################################################

RAPIDJSON_VERSION = ab1842a2dae061284c0a62dca1cc6d5e7e37e346
RAPIDJSON_SITE = $(call github,Tencent,rapidjson,$(RAPIDJSON_VERSION))
RAPIDJSON_LICENSE = MIT
RAPIDJSON_LICENSE_FILES = license.txt
RAPIDJSON_CPE_ID_VENDOR = tencent

# rapidjson is a header-only C++ library
RAPIDJSON_INSTALL_TARGET = NO
RAPIDJSON_INSTALL_STAGING = YES

RAPIDJSON_CONF_OPTS = \
	-DRAPIDJSON_BUILD_DOC=OFF \
	-DRAPIDJSON_BUILD_EXAMPLES=OFF \
	-DRAPIDJSON_BUILD_TESTS=OFF

$(eval $(cmake-package))
