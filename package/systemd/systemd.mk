################################################################################
#
# systemd
#
################################################################################

# When updating systemd, take care of the following:
# - Check if the requirements have changed (see README), in particular
#   arch and headers
# - If yes, propagate the dependencies to BR2_INIT_SYSTEMD
# - If the required kernel options have changed, update the Config.in
#   help text and the list of KCONFIG_ENABLE_OPT.
# - Check if there are new meson_options. Make sure all options are set
#   explicitly (usually to default value).
# - If there are new services:
#   - create new options for them (if they really are optional);
#   - create a new _USER if necessary;
#   - create new directory (with _PERMISSIONS) if necessary.
# - Diff sysusers.d with the previous version
# - Diff factory/etc/nsswitch.conf with the previous version
#   (details are often sprinkled around in README and manpages)
SYSTEMD_VERSION = 257.7
SYSTEMD_SITE = $(call github,systemd,systemd,v$(SYSTEMD_VERSION))
SYSTEMD_LICENSE = \
	LGPL-2.1+, \
	GPL-2.0+ (udev), \
	Public Domain (few source files, see LICENSES/README.md), \
	BSD-2-Clause (eBPF instruction mini library), \
	BSD-3-Clause (tools/chromiumos), \
	CC0-1.0 (few source files, see LICENSES/README.md), \
	GPL-2.0 with Linux-syscall-note (linux kernel headers), \
	MIT-0 (few source files, see LICENSES/README.md), \
	MIT (few source files, see LICENSES/README.md), \
	OFL-1.1 (Heebo fonts)
SYSTEMD_LICENSE_FILES = \
	LICENSE.GPL2 \
	LICENSE.LGPL2.1 \
	LICENSES/alg-sha1-public-domain.txt \
	LICENSES/BSD-2-Clause.txt \
	LICENSES/BSD-3-Clause.txt \
	LICENSES/CC0-1.0.txt \
	LICENSES/LGPL-2.0-or-later.txt \
	LICENSES/Linux-syscall-note.txt \
	LICENSES/lookup3-public-domain.txt \
	LICENSES/MIT-0.txt \
	LICENSES/MIT.txt \
	LICENSES/murmurhash2-public-domain.txt \
	LICENSES/OFL-1.1.txt \
	LICENSES/README.md
SYSTEMD_CPE_ID_VALID = YES
SYSTEMD_INSTALL_STAGING = YES
SYSTEMD_DEPENDENCIES = \
	$(BR2_COREUTILS_HOST_DEPENDENCY) \
	$(if $(BR2_PACKAGE_BASH_COMPLETION),bash-completion) \
	host-gperf \
	host-python-jinja2 \
	kmod \
	libcap \
	libxcrypt \
	util-linux-libs \
	$(TARGET_NLS_DEPENDENCIES)

SYSTEMD_SELINUX_MODULES = systemd udev xdg

SYSTEMD_PROVIDES = udev

SYSTEMD_CONF_OPTS += \
	-Dcreate-log-dirs=false \
	-Ddbus=disabled \
	-Ddbus-interfaces-dir=no \
	-Ddefault-compression='auto' \
	-Ddefault-locale='C.UTF-8' \
	-Ddefault-user-shell=/bin/sh \
	-Dfirst-boot-full-preset=false \
	-Didn=true \
	-Dima=false \
	-Dipe=false \
	-Dkexec-path=/usr/sbin/kexec \
	-Dkmod-path=/usr/bin/kmod \
	-Dldconfig=false \
	-Dlink-boot-shared=true \
	-Dloadkeys-path=/usr/bin/loadkeys \
	-Dman=disabled \
	-Dmount-path=/usr/bin/mount \
	-Dvcs-tag=false \
	-Dmode=release \
	-Dnspawn-locale='C.UTF-8' \
	-Dnss-systemd=true \
	-Dpasswdqc=disabled \
	-Dlibfido2=disabled \
	-Dquotacheck-path=/usr/sbin/quotacheck \
	-Dquotaon-path=/usr/sbin/quotaon \
	-Dsetfont-path=/usr/bin/setfont \
	-Dsplit-bin=true \
	-Dsulogin-path=/usr/sbin/sulogin \
	-Dsystem-gid-max=999 \
	-Dsystem-uid-max=999 \
	-Dsysvinit-path= \
	-Dsysvrcnd-path= \
	-Dtests=false \
	-Dfuzz-tests=false \
	-Dinstall-tests=false \
	-Dlog-message-verification=disabled \
	-Dsysupdated=disabled \
	-Dtmpfiles=true \
	-Dukify=disabled \
	-Dbpf-framework=disabled \
	-Dvmlinux-h=disabled \
	-Dumount-path=/usr/bin/umount \
	-Dxenctrl=disabled

SYSTEMD_CFLAGS = $(TARGET_CFLAGS)
ifeq ($(BR2_OPTIMIZE_FAST),y)
SYSTEMD_CFLAGS += -O3 -fno-finite-math-only
endif

ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)
SYSTEMD_JOURNALD_PERMISSIONS = /var/log/journal d 2755 root systemd-journal - - - - -
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
SYSTEMD_DEPENDENCIES += libglib2
SYSTEMD_CONF_OPTS += -Dglib=enabled
else
SYSTEMD_CONF_OPTS += -Dglib=disabled
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
SYSTEMD_DEPENDENCIES += libarchive
SYSTEMD_CONF_OPTS += -Dlibarchive=enabled
else
SYSTEMD_CONF_OPTS += -Dlibarchive=disabled
endif

ifeq ($(BR2_PACKAGE_ACL),y)
SYSTEMD_DEPENDENCIES += acl
SYSTEMD_CONF_OPTS += -Dacl=enabled
else
SYSTEMD_CONF_OPTS += -Dacl=disabled
endif

ifeq ($(BR2_PACKAGE_LESS),y)
SYSTEMD_CONF_OPTS += -Durlify=true
else
SYSTEMD_CONF_OPTS += -Durlify=false
endif

ifeq ($(BR2_PACKAGE_LIBAPPARMOR),y)
SYSTEMD_DEPENDENCIES += libapparmor
SYSTEMD_CONF_OPTS += -Dapparmor=enabled
else
SYSTEMD_CONF_OPTS += -Dapparmor=disabled
endif

ifeq ($(BR2_PACKAGE_AUDIT),y)
SYSTEMD_DEPENDENCIES += audit
SYSTEMD_CONF_OPTS += -Daudit=enabled
else
SYSTEMD_CONF_OPTS += -Daudit=disabled
endif

ifeq ($(BR2_PACKAGE_CRYPTSETUP),y)
SYSTEMD_DEPENDENCIES += cryptsetup
SYSTEMD_CONF_OPTS += -Dlibcryptsetup=enabled -Dlibcryptsetup-plugins=enabled
else
SYSTEMD_CONF_OPTS += -Dlibcryptsetup=disabled -Dlibcryptsetup-plugins=disabled
endif

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
SYSTEMD_DEPENDENCIES += elfutils
SYSTEMD_CONF_OPTS += -Delfutils=enabled
else
SYSTEMD_CONF_OPTS += -Delfutils=disabled
endif

ifeq ($(BR2_PACKAGE_IPTABLES),y)
SYSTEMD_DEPENDENCIES += iptables
SYSTEMD_CONF_OPTS += -Dlibiptc=enabled
else
SYSTEMD_CONF_OPTS += -Dlibiptc=disabled
endif

# Both options can't be selected at the same time so prefer libidn2
ifeq ($(BR2_PACKAGE_LIBIDN2),y)
SYSTEMD_DEPENDENCIES += libidn2
SYSTEMD_CONF_OPTS += -Dlibidn2=enabled -Dlibidn=disabled
else ifeq ($(BR2_PACKAGE_LIBIDN),y)
SYSTEMD_DEPENDENCIES += libidn
SYSTEMD_CONF_OPTS += -Dlibidn=enabled -Dlibidn2=disabled
else
SYSTEMD_CONF_OPTS += -Dlibidn=disabled -Dlibidn2=disabled
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
SYSTEMD_DEPENDENCIES += libseccomp
SYSTEMD_CONF_OPTS += -Dseccomp=enabled
else
SYSTEMD_CONF_OPTS += -Dseccomp=disabled
endif

ifeq ($(BR2_PACKAGE_LIBXKBCOMMON),y)
SYSTEMD_DEPENDENCIES += libxkbcommon
SYSTEMD_CONF_OPTS += -Dxkbcommon=enabled
else
SYSTEMD_CONF_OPTS += -Dxkbcommon=disabled
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
SYSTEMD_DEPENDENCIES += bzip2
SYSTEMD_CONF_OPTS += -Dbzip2=enabled
else
SYSTEMD_CONF_OPTS += -Dbzip2=disabled
endif

ifeq ($(BR2_PACKAGE_ZSTD),y)
SYSTEMD_DEPENDENCIES += zstd
SYSTEMD_CONF_OPTS += -Dzstd=enabled
else
SYSTEMD_CONF_OPTS += -Dzstd=disabled
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
SYSTEMD_DEPENDENCIES += lz4
SYSTEMD_CONF_OPTS += -Dlz4=enabled
else
SYSTEMD_CONF_OPTS += -Dlz4=disabled
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
SYSTEMD_DEPENDENCIES += linux-pam
SYSTEMD_CONF_OPTS += -Dpam=enabled
else
SYSTEMD_CONF_OPTS += -Dpam=disabled
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBFDISK),y)
SYSTEMD_CONF_OPTS += -Dfdisk=enabled
else
SYSTEMD_CONF_OPTS += -Dfdisk=disabled
endif

ifeq ($(BR2_PACKAGE_KMOD),y)
SYSTEMD_DEPENDENCIES += kmod
SYSTEMD_CONF_OPTS += -Dkmod=enabled
else
SYSTEMD_CONF_OPTS += -Dkmod=disabled
endif

ifeq ($(BR2_PACKAGE_XZ),y)
SYSTEMD_DEPENDENCIES += xz
SYSTEMD_CONF_OPTS += -Dxz=enabled
else
SYSTEMD_CONF_OPTS += -Dxz=disabled
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
SYSTEMD_DEPENDENCIES += zlib
SYSTEMD_CONF_OPTS += -Dzlib=enabled
else
SYSTEMD_CONF_OPTS += -Dzlib=disabled
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
SYSTEMD_DEPENDENCIES += libcurl
SYSTEMD_CONF_OPTS += -Dlibcurl=enabled
else
SYSTEMD_CONF_OPTS += -Dlibcurl=disabled
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
SYSTEMD_DEPENDENCIES += libgcrypt
SYSTEMD_CONF_OPTS += -Dgcrypt=enabled
else
SYSTEMD_CONF_OPTS += -Dgcrypt=disabled
endif

ifeq ($(BR2_PACKAGE_P11_KIT),y)
SYSTEMD_DEPENDENCIES += p11-kit
SYSTEMD_CONF_OPTS += -Dp11kit=enabled
else
SYSTEMD_CONF_OPTS += -Dp11kit=disabled
endif

ifeq ($(BR2_PACKAGE_PCRE2),y)
SYSTEMD_DEPENDENCIES += pcre2
SYSTEMD_CONF_OPTS += -Dpcre2=enabled
else
SYSTEMD_CONF_OPTS += -Dpcre2=disabled
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),y)
SYSTEMD_CONF_OPTS += -Dblkid=enabled
else
SYSTEMD_CONF_OPTS += -Dblkid=disabled
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_NOLOGIN),y)
SYSTEMD_CONF_OPTS += -Dnologin-path=/sbin/nologin
else
SYSTEMD_CONF_OPTS += -Dnologin-path=/bin/false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_INITRD),y)
SYSTEMD_CONF_OPTS += -Dinitrd=true
else
SYSTEMD_CONF_OPTS += -Dinitrd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_KERNELINSTALL),y)
SYSTEMD_CONF_OPTS += -Dkernel-install=true
else
SYSTEMD_CONF_OPTS += -Dkernel-install=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_ANALYZE),y)
SYSTEMD_CONF_OPTS += -Danalyze=true
else
SYSTEMD_CONF_OPTS += -Danalyze=false
endif

ifeq ($(BR2_PACKAGE_LIBPWQUALITY),y)
SYSTEMD_DEPENDENCIES += libpwquality
SYSTEMD_CONF_OPTS += -Dpwquality=enabled
else
SYSTEMD_CONF_OPTS += -Dpwquality=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_JOURNAL_REMOTE),y)
# remote also depends on libcurl, this is already added above.
SYSTEMD_DEPENDENCIES += libmicrohttpd
SYSTEMD_CONF_OPTS += -Dremote=enabled -Dmicrohttpd=enabled
SYSTEMD_REMOTE_USER = systemd-journal-remote -1 systemd-journal-remote -1 * - - - systemd Journal Remote
SYSTEMD_UPLOAD_USER = systemd-journal-upload -1 systemd-journal-upload -1 * - - - systemd Journal Upload
else
SYSTEMD_CONF_OPTS += -Dremote=disabled -Dmicrohttpd=disabled
endif

ifeq ($(BR2_PACKAGE_LIBQRENCODE),y)
SYSTEMD_DEPENDENCIES += libqrencode
SYSTEMD_CONF_OPTS += -Dqrencode=enabled
else
SYSTEMD_CONF_OPTS += -Dqrencode=disabled
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
SYSTEMD_DEPENDENCIES += libselinux
SYSTEMD_CONF_OPTS += -Dselinux=enabled
else
SYSTEMD_CONF_OPTS += -Dselinux=disabled
endif

ifneq ($(BR2_PACKAGE_LIBGCRYPT)$(BR2_PACKAGE_LIBOPENSSL),)
SYSTEMD_CONF_OPTS += -Ddefault-dnssec=allow-downgrade
else
SYSTEMD_CONF_OPTS += -Ddefault-dnssec=no
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HWDB),y)
SYSTEMD_CONF_OPTS += -Dhwdb=true
define SYSTEMD_BUILD_HWDB
	$(HOST_DIR)/bin/systemd-hwdb update --root $(TARGET_DIR) --strict --usr
endef
SYSTEMD_TARGET_FINALIZE_HOOKS += SYSTEMD_BUILD_HWDB
define SYSTEMD_RM_HWBD_UPDATE_SERVICE
	rm -rf $(TARGET_DIR)/usr/lib/systemd/system/systemd-hwdb-update.service \
		$(TARGET_DIR)/usr/lib/systemd/system/*/systemd-hwdb-update.service \
		$(TARGET_DIR)/usr/bin/systemd-hwdb
endef
SYSTEMD_POST_INSTALL_TARGET_HOOKS += SYSTEMD_RM_HWBD_UPDATE_SERVICE
else
SYSTEMD_CONF_OPTS += -Dhwdb=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_BINFMT),y)
SYSTEMD_CONF_OPTS += -Dbinfmt=true
else
SYSTEMD_CONF_OPTS += -Dbinfmt=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_UTMP),y)
SYSTEMD_CONF_OPTS += -Dutmp=true
else
SYSTEMD_CONF_OPTS += -Dutmp=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_VCONSOLE),y)
SYSTEMD_CONF_OPTS += \
	-Dvconsole=true \
	-Ddefault-keymap=$(call qstrip,$(BR2_PACKAGE_SYSTEMD_VCONSOLE_DEFAULT_KEYMAP))
else
SYSTEMD_CONF_OPTS += -Dvconsole=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_VMSPAWN),y)
SYSTEMD_CONF_OPTS += -Dvmspawn=enabled
else
SYSTEMD_CONF_OPTS += -Dvmspawn=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_QUOTACHECK),y)
SYSTEMD_CONF_OPTS += -Dquotacheck=true
else
SYSTEMD_CONF_OPTS += -Dquotacheck=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SYSUSERS),y)
SYSTEMD_CONF_OPTS += -Dsysusers=true
else
SYSTEMD_CONF_OPTS += -Dsysusers=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SYSUSERS),y)
SYSTEMD_CONF_OPTS += -Dstoragetm=true
else
SYSTEMD_CONF_OPTS += -Dstoragetm=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_FIRSTBOOT),y)
SYSTEMD_CONF_OPTS += -Dfirstboot=true
else
SYSTEMD_CONF_OPTS += -Dfirstboot=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RANDOMSEED),y)
SYSTEMD_CONF_OPTS += -Drandomseed=true
else
SYSTEMD_CONF_OPTS += -Drandomseed=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_BACKLIGHT),y)
SYSTEMD_CONF_OPTS += -Dbacklight=true
else
SYSTEMD_CONF_OPTS += -Dbacklight=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RFKILL),y)
SYSTEMD_CONF_OPTS += -Drfkill=true
else
SYSTEMD_CONF_OPTS += -Drfkill=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_LOGIND),y)
SYSTEMD_CONF_OPTS += -Dlogind=true
SYSTEMD_LOGIND_PERMISSIONS = /var/lib/systemd/linger d 755 0 0 - - - - -
else
SYSTEMD_CONF_OPTS += -Dlogind=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_MACHINED),y)
SYSTEMD_CONF_OPTS += -Dmachined=true -Dnss-mymachines=enabled
SYSTEMD_MACHINED_PERMISSIONS = /var/lib/machines d 700 0 0 - - - - -
else
SYSTEMD_CONF_OPTS += -Dmachined=false -Dnss-mymachines=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_IMPORTD),y)
SYSTEMD_CONF_OPTS += -Dimportd=enabled
else
SYSTEMD_CONF_OPTS += -Dimportd=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HOMED),y)
SYSTEMD_CONF_OPTS += -Dhomed=enabled
SYSTEMD_DEPENDENCIES += cryptsetup openssl
SYSTEMD_HOMED_PERMISSIONS = /var/lib/systemd/home d 755 0 0 - - - - -
else
SYSTEMD_CONF_OPTS += -Dhomed=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HOSTNAMED),y)
SYSTEMD_CONF_OPTS += -Dhostnamed=true
else
SYSTEMD_CONF_OPTS += -Dhostnamed=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_NSRESOURCED),y)
SYSTEMD_CONF_OPTS += -Dnsresourced=true
else
SYSTEMD_CONF_OPTS += -Dnsresourced=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_MYHOSTNAME),y)
SYSTEMD_CONF_OPTS += -Dnss-myhostname=true
else
SYSTEMD_CONF_OPTS += -Dnss-myhostname=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TIMEDATED),y)
SYSTEMD_CONF_OPTS += -Dtimedated=true
else
SYSTEMD_CONF_OPTS += -Dtimedated=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_LOCALED),y)
SYSTEMD_CONF_OPTS += -Dlocaled=true
else
SYSTEMD_CONF_OPTS += -Dlocaled=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_REPART),y)
SYSTEMD_CONF_OPTS += -Drepart=enabled
SYSTEMD_DEPENDENCIES += openssl
else
SYSTEMD_CONF_OPTS += -Drepart=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_MOUNTFSD),y)
SYSTEMD_CONF_OPTS += -Dmountfsd=true
else
SYSTEMD_CONF_OPTS += -Dmountfsd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_USERDB),y)
SYSTEMD_CONF_OPTS += -Duserdb=true
else
SYSTEMD_CONF_OPTS += -Duserdb=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_COREDUMP),y)
SYSTEMD_CONF_OPTS += -Dcoredump=true
SYSTEMD_COREDUMP_USER = systemd-coredump -1 systemd-coredump -1 * - - - systemd core dump processing
SYSTEMD_COREDUMP_PERMISSIONS = /var/lib/systemd/coredump d 755 0 0 - - - - -
else
SYSTEMD_CONF_OPTS += -Dcoredump=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_PSTORE),y)
SYSTEMD_CONF_OPTS += -Dpstore=true
SYSTEMD_PSTORE_PERMISSIONS = /var/lib/systemd/pstore d 755 0 0 - - - - -
else
SYSTEMD_CONF_OPTS += -Dpstore=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_OOMD),y)
SYSTEMD_CONF_OPTS += -Doomd=true
SYSTEMD_OOMD_USER = systemd-oom -1 systemd-oom -1 * - - - systemd Userspace OOM Killer
define SYSTEMD_OOMD_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_PSI)
	$(call KCONFIG_ENABLE_OPT,CONFIG_MEMCG)
endef
else
SYSTEMD_CONF_OPTS += -Doomd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_POLKIT),y)
SYSTEMD_CONF_OPTS += -Dpolkit=enabled
SYSTEMD_DEPENDENCIES += polkit
else
SYSTEMD_CONF_OPTS += -Dpolkit=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_PORTABLED),y)
SYSTEMD_CONF_OPTS += -Dportabled=true
else
SYSTEMD_CONF_OPTS += -Dportabled=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SYSEXT),y)
SYSTEMD_CONF_OPTS += -Dsysext=true
else
SYSTEMD_CONF_OPTS += -Dsysext=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SYSUPDATE),y)
SYSTEMD_CONF_OPTS += -Dsysupdate=enabled
else
SYSTEMD_CONF_OPTS += -Dsysupdate=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_NETWORKD),y)
SYSTEMD_CONF_OPTS += -Dnetworkd=true
SYSTEMD_NETWORKD_USER = systemd-network -1 systemd-network -1 * - - - systemd Network Management
SYSTEMD_NETWORKD_DHCP_IFACE = $(call qstrip,$(BR2_SYSTEM_DHCP))
ifneq ($(SYSTEMD_NETWORKD_DHCP_IFACE),)
define SYSTEMD_INSTALL_NETWORK_CONFS
	sed s/SYSTEMD_NETWORKD_DHCP_IFACE/$(SYSTEMD_NETWORKD_DHCP_IFACE)/ \
		$(SYSTEMD_PKGDIR)/dhcp.network > \
		$(TARGET_DIR)/etc/systemd/network/$(SYSTEMD_NETWORKD_DHCP_IFACE).network
endef
endif
else
SYSTEMD_CONF_OPTS += -Dnetworkd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_RESOLVED),y)
define SYSTEMD_INSTALL_RESOLVCONF_HOOK
	ln -sf ../run/systemd/resolve/resolv.conf \
		$(TARGET_DIR)/etc/resolv.conf
endef
SYSTEMD_CONF_OPTS += -Dnss-resolve=enabled -Dresolve=true
SYSTEMD_RESOLVED_USER = systemd-resolve -1 systemd-resolve -1 * - - - systemd Resolver
else
SYSTEMD_CONF_OPTS += -Dnss-resolve=disabled -Dresolve=false
endif

ifeq ($(BR2_PACKAGE_LIBOPENSSL),y)
SYSTEMD_CONF_OPTS += \
	-Dgnutls=disabled \
	-Dopenssl=enabled \
	-Ddns-over-tls=openssl \
	-Ddefault-dns-over-tls=opportunistic
SYSTEMD_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
SYSTEMD_CONF_OPTS += \
	-Dgnutls=enabled \
	-Dopenssl=disabled \
	-Ddns-over-tls=gnutls \
	-Ddefault-dns-over-tls=opportunistic
SYSTEMD_DEPENDENCIES += gnutls
else
SYSTEMD_CONF_OPTS += \
	-Dgnutls=disabled \
	-Dopenssl=disabled \
	-Ddns-over-tls=false \
	-Ddefault-dns-over-tls=no
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_TIMESYNCD),y)
SYSTEMD_CONF_OPTS += -Dtimesyncd=true
SYSTEMD_TIMESYNCD_USER = systemd-timesync -1 systemd-timesync -1 * - - - systemd Time Synchronization
SYSTEMD_TIMESYNCD_PERMISSIONS = /var/lib/systemd/timesync d 755 systemd-timesync systemd-timesync - - - - -
else
SYSTEMD_CONF_OPTS += -Dtimesyncd=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_SMACK_SUPPORT),y)
SYSTEMD_CONF_OPTS += -Dsmack=true
else
SYSTEMD_CONF_OPTS += -Dsmack=false
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_HIBERNATE),y)
SYSTEMD_CONF_OPTS += -Dhibernate=true
else
SYSTEMD_CONF_OPTS += -Dhibernate=false
endif

ifeq ($(BR2_PACKAGE_TPM2_TSS),y)
SYSTEMD_DEPENDENCIES += tpm2-tss
SYSTEMD_CONF_OPTS += -Dtpm2=enabled
else
SYSTEMD_CONF_OPTS += -Dtpm2=disabled
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_BOOT),y)
SYSTEMD_INSTALL_IMAGES = YES
SYSTEMD_DEPENDENCIES += gnu-efi host-python-pyelftools
SYSTEMD_CONF_OPTS += -Dbootloader=enabled

SYSTEMD_BOOT_EFI_ARCH = $(call qstrip,$(BR2_PACKAGE_SYSTEMD_BOOT_EFI_ARCH))
define SYSTEMD_INSTALL_BOOT_FILES
	$(INSTALL) -D -m 0644 $(@D)/buildroot-build/src/boot/systemd-boot$(SYSTEMD_BOOT_EFI_ARCH).efi \
		$(BINARIES_DIR)/efi-part/EFI/BOOT/boot$(SYSTEMD_BOOT_EFI_ARCH).efi
	$(INSTALL) -D -m 0644 $(SYSTEMD_PKGDIR)/boot-files/loader.conf \
		$(BINARIES_DIR)/efi-part/loader/loader.conf
	$(INSTALL) -D -m 0644 $(SYSTEMD_PKGDIR)/boot-files/buildroot.conf \
		$(BINARIES_DIR)/efi-part/loader/entries/buildroot.conf
endef

else
SYSTEMD_CONF_OPTS += -Dbootloader=disabled
endif # BR2_PACKAGE_SYSTEMD_BOOT == y

ifeq ($(BR2_PACKAGE_SYSTEMD_EFI),y)
SYSTEMD_CONF_OPTS += -Defi=true
else
SYSTEMD_CONF_OPTS += -Defi=false
endif

SYSTEMD_FALLBACK_HOSTNAME = $(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
ifneq ($(SYSTEMD_FALLBACK_HOSTNAME),)
SYSTEMD_CONF_OPTS += -Dfallback-hostname=$(SYSTEMD_FALLBACK_HOSTNAME)
endif

SYSTEMD_DEFAULT_TARGET = $(call qstrip,$(BR2_PACKAGE_SYSTEMD_DEFAULT_TARGET))
ifneq ($(SYSTEMD_DEFAULT_TARGET),)
define SYSTEMD_INSTALL_INIT_HOOK
	ln -fs "$(SYSTEMD_DEFAULT_TARGET)" \
		$(TARGET_DIR)/usr/lib/systemd/system/default.target
endef
SYSTEMD_POST_INSTALL_TARGET_HOOKS += SYSTEMD_INSTALL_INIT_HOOK
endif

define SYSTEMD_INSTALL_MACHINEID_HOOK
	touch $(TARGET_DIR)/etc/machine-id
endef

SYSTEMD_POST_INSTALL_TARGET_HOOKS += \
	SYSTEMD_INSTALL_MACHINEID_HOOK

define SYSTEMD_INSTALL_IMAGES_CMDS
	$(SYSTEMD_INSTALL_BOOT_FILES)
endef

define SYSTEMD_PERMISSIONS
	/boot d 700 0 0 - - - - -
	/var/spool d 755 0 0 - - - - -
	/var/lib d 755 0 0 - - - - -
	/var/lib/private d 700 0 0 - - - - -
	/var/log/private d 700 0 0 - - - - -
	/var/cache/private d 700 0 0 - - - - -
	$(SYSTEMD_JOURNALD_PERMISSIONS)
	$(SYSTEMD_LOGIND_PERMISSIONS)
	$(SYSTEMD_MACHINED_PERMISSIONS)
	$(SYSTEMD_HOMED_PERMISSIONS)
	$(SYSTEMD_COREDUMP_PERMISSIONS)
	$(SYSTEMD_PSTORE_PERMISSIONS)
	$(SYSTEMD_TIMESYNCD_PERMISSIONS)
endef

define SYSTEMD_USERS
	# udev user groups
	- - render -1 * - - - DRI rendering nodes
	# systemd user groups
	- - systemd-journal -1 * - - - Journal
	$(SYSTEMD_REMOTE_USER)
	$(SYSTEMD_UPLOAD_USER)
	$(SYSTEMD_COREDUMP_USER)
	$(SYSTEMD_OOMD_USER)
	$(SYSTEMD_NETWORKD_USER)
	$(SYSTEMD_RESOLVED_USER)
	$(SYSTEMD_TIMESYNCD_USER)
endef

define SYSTEMD_INSTALL_NSSCONFIG_HOOK
	$(SED) '/^passwd:/ {/systemd/! s/$$/ systemd/}' \
		-e '/^group:/ {/systemd/! s/$$/ [SUCCESS=merge] systemd/}' \
		-e '/^shadow:/ {/systemd/! s/$$/ systemd/}' \
		-e '/^gshadow:/ {/systemd/! s/$$/ systemd/}' \
		$(if $(BR2_PACKAGE_SYSTEMD_RESOLVED), \
			-e '/^hosts:/ s/[[:space:]]*mymachines//' \
			-e '/^hosts:/ {/resolve/! s/files/resolve [!UNAVAIL=return] files/}' ) \
		$(if $(BR2_PACKAGE_SYSTEMD_MYHOSTNAME), \
			-e '/^hosts:/ {/myhostname/! s/files/files myhostname/}' ) \
		$(if $(BR2_PACKAGE_SYSTEMD_MACHINED), \
			-e '/^hosts:/ {/mymachines/! s/^\(hosts:[[:space:]]*\)/\1mymachines /}' ) \
		$(TARGET_DIR)/etc/nsswitch.conf
endef

SYSTEMD_TARGET_FINALIZE_HOOKS += \
	SYSTEMD_INSTALL_NSSCONFIG_HOOK \
	SYSTEMD_INSTALL_RESOLVCONF_HOOK

ifneq ($(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)),)
# systemd provides multiple units to autospawn getty as needed
# * getty@.service to start a getty on normal TTY
# * serial-getty@.service to start a getty on serial lines
# * console-getty.service for generic /dev/console
# * container-getty@.service for a getty on /dev/pts/*
#
# the generator systemd-getty-generator will
# * read the console= kernel command line parameter
# * enable one of the above units depending on what it finds
#
# Systemd defaults to enabling getty@tty1.service
#
# What we want to do
# * Enable a getty on $BR2_TARGET_GENERIC_GETTY_PORT
# * Set the baudrate for all units according to BR2_TARGET_GENERIC_GETTY_BAUDRATE
# * Always enable a getty on the console using systemd-getty-generator
#   (backward compatibility with previous releases of buildroot)
#
# What we do
# * disable getty@tty1 (enabled by upstream systemd)
# * enable getty@xxx if  $BR2_TARGET_GENERIC_GETTY_PORT is a tty
# * enable serial-getty@xxx for other $BR2_TARGET_GENERIC_GETTY_PORT
# * rewrite baudrates if a baudrate is provided
define SYSTEMD_INSTALL_SERVICE_TTY
	mkdir -p $(TARGET_DIR)/usr/lib/systemd/system/getty@.service.d; \
	printf '[Install]\nDefaultInstance=\n' \
		>$(TARGET_DIR)/usr/lib/systemd/system/getty@.service.d/buildroot-console.conf; \
	if [ $(BR2_TARGET_GENERIC_GETTY_PORT) = "console" ]; \
	then \
		: ; \
	elif echo $(BR2_TARGET_GENERIC_GETTY_PORT) | egrep -q 'tty[0-9]*$$'; \
	then \
		printf '[Install]\nDefaultInstance=%s\n' \
			$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)) \
			>$(TARGET_DIR)/usr/lib/systemd/system/getty@.service.d/buildroot-console.conf; \
	else \
		mkdir -p $(TARGET_DIR)/usr/lib/systemd/system/serial-getty@.service.d;\
		printf '[Install]\nDefaultInstance=%s\n' \
			$(call qstrip,$(BR2_TARGET_GENERIC_GETTY_PORT)) \
			>$(TARGET_DIR)/usr/lib/systemd/system/serial-getty@.service.d/buildroot-console.conf;\
	fi; \
	if [ $(call qstrip,$(BR2_TARGET_GENERIC_GETTY_BAUDRATE)) -gt 0 ] ; \
	then \
		$(SED) 's/115200/$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),115200/' $(TARGET_DIR)/lib/systemd/system/getty@.service; \
		$(SED) 's/115200/$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),115200/' $(TARGET_DIR)/lib/systemd/system/serial-getty@.service; \
		$(SED) 's/115200/$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),115200/' $(TARGET_DIR)/lib/systemd/system/console-getty@.service; \
		$(SED) 's/115200/$(BR2_TARGET_GENERIC_GETTY_BAUDRATE),115200/' $(TARGET_DIR)/lib/systemd/system/container-getty@.service; \
	fi
endef
endif

define SYSTEMD_INSTALL_PRESET
	$(INSTALL) -D -m 644 $(SYSTEMD_PKGDIR)/80-buildroot.preset $(TARGET_DIR)/usr/lib/systemd/system-preset/80-buildroot.preset
endef

define SYSTEMD_INSTALL_INIT_SYSTEMD
	$(SYSTEMD_INSTALL_PRESET)
	$(SYSTEMD_INSTALL_SERVICE_TTY)
	$(SYSTEMD_INSTALL_NETWORK_CONFS)
endef

ifeq ($(BR2_ENABLE_LOCALE_PURGE),y)
# Go through all files with scheme <basename>.<langext>.catalog
# and remove those where <langext> is not in LOCALE_NOPURGE
define SYSTEMD_LOCALE_PURGE_CATALOGS
	for cfile in `find $(TARGET_DIR)/usr/lib/systemd/catalog -name '*.*.catalog'`; \
	do \
		basename=$${cfile##*/}; \
		basename=$${basename%.catalog}; \
		langext=$${basename#*.}; \
		[ "$$langext" = "$${basename}" ] && continue; \
		expr '$(LOCALE_NOPURGE)' : ".*\b$${langext}\b" >/dev/null && continue; \
		rm -f "$$cfile"; \
	done
endef
SYSTEMD_ROOTFS_PRE_CMD_HOOKS += SYSTEMD_LOCALE_PURGE_CATALOGS
endif

ifeq ($(BR2_PACKAGE_SYSTEMD_CATALOGDB),y)
define SYSTEMD_UPDATE_CATALOGS
	$(HOST_DIR)/bin/journalctl --root=$(TARGET_DIR) --update-catalog
	install -D $(TARGET_DIR)/var/lib/systemd/catalog/database \
		$(TARGET_DIR)/usr/share/factory/var/lib/systemd/catalog/database
	rm $(TARGET_DIR)/var/lib/systemd/catalog/database
	ln -sf /usr/share/factory/var/lib/systemd/catalog/database \
		$(TARGET_DIR)/var/lib/systemd/catalog/database
	grep -q '^L /var/lib/systemd/catalog/database' $(TARGET_DIR)/usr/lib/tmpfiles.d/var.conf || \
		printf "\nL /var/lib/systemd/catalog/database\n" >> $(TARGET_DIR)/usr/lib/tmpfiles.d/var.conf
endef
SYSTEMD_ROOTFS_PRE_CMD_HOOKS += SYSTEMD_UPDATE_CATALOGS
endif

define SYSTEMD_RM_CATALOG_UPDATE_SERVICE
	rm -rf $(TARGET_DIR)/usr/lib/systemd/catalog \
		$(TARGET_DIR)/usr/lib/systemd/system/systemd-journal-catalog-update.service \
		$(TARGET_DIR)/usr/lib/systemd/system/*/systemd-journal-catalog-update.service
endef
SYSTEMD_ROOTFS_PRE_CMD_HOOKS += SYSTEMD_RM_CATALOG_UPDATE_SERVICE

define SYSTEMD_PRESET_ALL
	$(HOST_DIR)/bin/systemctl --root=$(TARGET_DIR) preset-all
endef
SYSTEMD_ROOTFS_PRE_CMD_HOOKS += SYSTEMD_PRESET_ALL

SYSTEMD_CONF_ENV = $(HOST_UTF8_LOCALE_ENV)
SYSTEMD_NINJA_ENV = $(HOST_UTF8_LOCALE_ENV)

define SYSTEMD_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_TMPFS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_DEVTMPFS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_CGROUPS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_INOTIFY_USER)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SIGNALFD)
	$(call KCONFIG_ENABLE_OPT,CONFIG_TIMERFD)
	$(call KCONFIG_ENABLE_OPT,CONFIG_EPOLL)
	$(call KCONFIG_ENABLE_OPT,CONFIG_UNIX)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SYSFS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_PROC_FS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_FHANDLE)

	$(call KCONFIG_DISABLE_OPT,CONFIG_FW_LOADER_USER_HELPER)

	$(call KCONFIG_ENABLE_OPT,CONFIG_DMIID)

	$(call KCONFIG_ENABLE_OPT,CONFIG_BLK_DEV_BSG)

	$(call KCONFIG_ENABLE_OPT,CONFIG_NET_NS)

	$(call KCONFIG_ENABLE_OPT,CONFIG_USER_NS)

	$(call KCONFIG_DISABLE_OPT,CONFIG_SYSFS_DEPRECATED)

	$(call KCONFIG_ENABLE_OPT,CONFIG_IPV6)
	$(call KCONFIG_ENABLE_OPT,CONFIG_AUTOFS_FS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_AUTOFS4_FS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_TMPFS_POSIX_ACL)
	$(call KCONFIG_ENABLE_OPT,CONFIG_TMPFS_XATTR)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SECCOMP)
	$(call KCONFIG_ENABLE_OPT,CONFIG_SECCOMP_FILTER)
	$(call KCONFIG_ENABLE_OPT,CONFIG_KCMP)
	$(call KCONFIG_ENABLE_OPT,CONFIG_NET_SCHED)
	$(call KCONFIG_ENABLE_OPT,CONFIG_NET_SCH_FQ_CODEL)

	$(call KCONFIG_ENABLE_OPT,CONFIG_CGROUP_SCHED)
	$(call KCONFIG_ENABLE_OPT,CONFIG_FAIR_GROUP_SCHED)

	$(call KCONFIG_ENABLE_OPT,CONFIG_CFS_BANDWIDTH)

	$(call KCONFIG_ENABLE_OPT,CONFIG_EFIVAR_FS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_EFI_PARTITION)

	$(call KCONFIG_ENABLE_OPT,CONFIG_DMI)
	$(call KCONFIG_ENABLE_OPT,CONFIG_DMI_SYSFS)

	$(call KCONFIG_DISABLE_OPT,CONFIG_RT_GROUP_SCHED)

	$(SYSTEMD_OOMD_LINUX_CONFIG_FIXUPS)
endef

# We need a very minimal host variant, so we disable as much as possible.
HOST_SYSTEMD_CONF_OPTS = \
	-Dsplit-bin=true \
	--prefix=/usr \
	--libdir=lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	-Dcreate-log-dirs=false \
	-Dvcs-tag=false \
	-Dmode=release \
	-Dutmp=false \
	-Dhibernate=false \
	-Dtpm2=disabled \
	-Dldconfig=false \
	-Dresolve=false \
	-Dbootloader=disabled \
	-Defi=false \
	-Dtpm=false \
	-Denvironment-d=false \
	-Dbinfmt=false \
	-Drepart=disabled \
	-Dcoredump=false \
	-Ddbus=disabled \
	-Ddbus-interfaces-dir=no \
	-Dpstore=false \
	-Doomd=false \
	-Dlogind=false \
	-Dhostnamed=false \
	-Dlocaled=false \
	-Dmachined=false \
	-Dpasswdqc=disabled \
	-Dportabled=false \
	-Dsysext=false \
	-Dsysupdate=disabled \
	-Dmountfsd=false \
	-Duserdb=false \
	-Dhomed=disabled \
	-Dnetworkd=false \
	-Dtimedated=false \
	-Dtimesyncd=false \
	-Dremote=disabled \
	-Dcreate-log-dirs=false \
	-Dnsresourced=false \
	-Dnss-myhostname=false \
	-Dnss-mymachines=disabled \
	-Dnss-resolve=disabled \
	-Dnss-systemd=false \
	-Dfirstboot=false \
	-Drandomseed=false \
	-Dbacklight=false \
	-Dvconsole=false \
	-Dvmspawn=disabled \
	-Dquotacheck=false \
	-Dsysusers=false \
	-Dstoragetm=false \
	-Dtmpfiles=true \
	-Dimportd=disabled \
	-Dhwdb=true \
	-Drfkill=false \
	-Dman=disabled \
	-Dhtml=disabled \
	-Dsmack=false \
	-Dpolkit=disabled \
	-Dblkid=disabled \
	-Didn=false \
	-Dadm-group=false \
	-Dwheel-group=false \
	-Dzlib=disabled \
	-Dgshadow=false \
	-Dima=false \
	-Dtests=false \
	-Dfuzz-tests=false \
	-Dinstall-tests=false \
	-Dlog-message-verification=disabled \
	-Dglib=disabled \
	-Dlibarchive=disabled \
	-Dacl=disabled \
	-Dsysvinit-path='' \
	-Dinitrd=false \
	-Dxdg-autostart=false \
	-Dkernel-install=false \
	-Dukify=disabled \
	-Danalyze=false \
	-Dbpf-framework=disabled \
	-Dvmlinux-h=disabled \
	-Dpwquality=disabled \
	-Dmicrohttpd=disabled \
	-Dqrencode=disabled \
	-Dselinux=disabled \
	-Dlibcryptsetup=disabled \
	-Dlibcryptsetup-plugins=disabled \
	-Delfutils=disabled \
	-Dlibiptc=disabled \
	-Dapparmor=disabled \
	-Daudit=disabled \
	-Dxenctrl=disabled \
	-Dlibidn2=disabled \
	-Dlibidn=disabled \
	-Dseccomp=disabled \
	-Dxkbcommon=disabled \
	-Dbzip2=disabled \
	-Dzstd=disabled \
	-Dlz4=disabled \
	-Dpam=disabled \
	-Dfdisk=disabled \
	-Dkmod=disabled \
	-Dxz=disabled \
	-Dlibcurl=disabled \
	-Dgcrypt=disabled \
	-Dgnutls=disabled \
	-Dopenssl=disabled \
	-Dp11kit=disabled \
	-Dlibfido2=disabled \
	-Dpcre2=disabled \
	-Dsysupdated=disabled

HOST_SYSTEMD_DEPENDENCIES = \
	$(BR2_COREUTILS_HOST_DEPENDENCY) \
	host-util-linux \
	host-patchelf \
	host-libcap \
	host-libxcrypt \
	host-gperf \
	host-python-jinja2

HOST_SYSTEMD_NINJA_ENV = DESTDIR=$(HOST_DIR)

# Fix RPATH After installation
# * systemd provides a install_rpath instruction to meson because the binaries
#   need to link with libsystemd which is not in a standard path
# * meson can only replace the RPATH, not append to it
# * the original rpath is thus lost.
# * the original path had been tweaked by buildroot via LDFLAGS to add
#   $(HOST_DIR)/lib
# * thus re-tweak rpath after the installation for all binaries that need it
HOST_SYSTEMD_HOST_TOOLS = busctl journalctl systemctl systemd-* udevadm

define HOST_SYSTEMD_FIX_RPATH
	for f in $(addprefix $(HOST_DIR)/bin/,$(HOST_SYSTEMD_HOST_TOOLS)); do \
		[ -e $$f ] || continue; \
		$(HOST_DIR)/bin/patchelf --set-rpath $(HOST_DIR)/lib:$(HOST_DIR)/lib/systemd $${f} \
		|| exit 1; \
	done
endef
HOST_SYSTEMD_POST_INSTALL_HOOKS += HOST_SYSTEMD_FIX_RPATH

$(eval $(meson-package))
$(eval $(host-meson-package))
