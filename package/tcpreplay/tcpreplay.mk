################################################################################
#
# tcpreplay
#
################################################################################

TCPREPLAY_VERSION = 4.5.1
TCPREPLAY_SITE = https://github.com/appneta/tcpreplay/releases/download/v$(TCPREPLAY_VERSION)
TCPREPLAY_SOURCE = tcpreplay-$(TCPREPLAY_VERSION).tar.xz
TCPREPLAY_LICENSE = GPL-3.0
TCPREPLAY_LICENSE_FILES = docs/LICENSE
TCPREPLAY_CPE_ID_VENDOR = broadcom
TCPREPLAY_CONF_ENV = \
	ac_cv_path_ac_pt_PCAP_CONFIG="$(STAGING_DIR)/usr/bin/pcap-config" \
	LIBS="$(TCPREPLAY_LIBS)"
TCPREPLAY_CONF_OPTS = --with-libpcap=$(STAGING_DIR)/usr \
	--enable-pcapconfig
TCPREPLAY_DEPENDENCIES = libpcap

ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),)
TCPREPLAY_DEPENDENCIES += musl-fts
TCPREPLAY_LIBS += -lfts
endif

ifeq ($(BR2_STATIC_LIBS),y)
TCPREPLAY_CONF_OPTS += --enable-dynamic-link=no
TCPREPLAY_LIBS += `$(STAGING_DIR)/usr/bin/pcap-config --static --libs`
endif

ifeq ($(BR2_PACKAGE_LIBDNET),y)
TCPREPLAY_DEPENDENCIES += libdnet
TCPREPLAY_CONF_OPTS += --with-libdnet=$(STAGING_DIR)/usr
else
TCPREPLAY_CONF_OPTS += --without-libdnet
endif

ifeq ($(BR2_PACKAGE_TCPDUMP),y)
TCPREPLAY_CONF_ENV += ac_cv_path_tcpdump_path=/usr/sbin/tcpdump
else
TCPREPLAY_CONF_ENV += ac_cv_path_tcpdump_path=no
endif

$(eval $(autotools-package))
