#!/usr/bin/env sh

set -e # Exit on false

# Enabled AXP20X linux drivers

pmbootstrap -y zap

pmbootstrap checksum \
	device-olimex-teres_i
	# linux-olimex-teres_i \
	# linux-postmarketos-allwinner

pmbootstrap -v --details-to-stdout build --force device-olimex-teres_i

pmbootstrap -y install --password 0000 --sdcard /dev/sdd
