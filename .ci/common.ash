#!/usr/bin/env ash
# Copyright 2024 Jacob Hrbek
# SPDX-License-Identifier: EUPL-1.2-or-later
# Description: Common functions used across CI's ash scripts
# https://postmarketos.org/pmb-ci

# Exit with message
die() { printf "ERROR: %s\n" "$@"; exit 1 ;}