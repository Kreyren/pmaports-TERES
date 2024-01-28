#!/usr/bin/env ash
# shellcheck shell=ash # Busybox ash
# Copyright 2023 Oliver Smith
# Copyright 2024 Jacob Hrbek
# SPDX-License-Identifier: GPL-3.0-or-later AND EUPL-1.2-or-later
# Description: lint all shell scripts
# https://postmarketos.org/pmb-ci

set -e # Exit on false return

# shellcheck source=./common.ash
. ./common.ash

DIR="$(cd "$(dirname "$0")/.." && pwd -P)"

id -u || die "Priviledged user is required to run this script, but user with ID $(id -u) was used"

[ "$(id -u)" != 0 ] || {
	set -x
	apk -q add shellcheck
	exec su "${TESTUSER:-build}" -c "sh -e $0"
}

# Shell: shellcheck
sh_files="
	./main/mdss-fb-init-hack/mdss-fb-init-hack.sh
	./main/osk-sdl/unlock.sh
	./main/postmarketos-base/rootfs-usr-lib-firmwareload.sh
	./main/postmarketos-base-ui/rootfs-usr-lib-NetworkManager-dispatcher.d-50-dns-filter.sh
	./main/postmarketos-base-ui/rootfs-usr-lib-NetworkManager-dispatcher.d-50-tethering.sh
	./main/postmarketos-installkernel/installkernel-pmos
	./main/postmarketos-initramfs/init.sh
	./main/postmarketos-initramfs/init_functions.sh
	./main/postmarketos-mkinitfs-hook-debug-shell/20-debug-shell.sh
	./main/postmarketos-mkinitfs-hook-debug-shell/setup_usb_storage.sh
	./main/postmarketos-mkinitfs-hook-netboot/netboot.sh
	./main/postmarketos-update-kernel/update-kernel.sh
	./main/ttyescape/*.post-install
	./main/unl0kr/unlock.sh
	./main/msm-firmware-loader/*.post-install
	./device/community/soc-qcom-sdm845/call_audio_idle_suspend_workaround.sh

	$(find . -path './main/postmarketos-ui-*/*.sh')
	$(find . -path './main/postmarketos-ui-*/*.pre-install')
	$(find . -path './main/postmarketos-ui-*/*.post-install')
	$(find . -path './main/postmarketos-ui-*/*.pre-upgrade')
	$(find . -path './main/postmarketos-ui-*/*.post-upgrade')
	$(find . -path './main/postmarketos-ui-*/*.pre-deinstall')
	$(find . -path './main/postmarketos-ui-*/*.post-deinstall')

	$(find . -name '*.trigger')
	$(find . -path './main/devicepkg-dev/*.sh')
	$(find . -path './main/postmarketos-mvcfg/*.sh')

	$(find . -path './.ci/**.sh')
"

for file in $sh_files; do
	echo "Test with shellcheck: $file"
	cd "$DIR/$(dirname "$file")"
	shellcheck -e SC1008 -e SC3043 -x "$(basename "$file")"
done
