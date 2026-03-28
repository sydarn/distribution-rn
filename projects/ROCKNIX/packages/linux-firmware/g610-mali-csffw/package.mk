# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="g610-mali-csffw"
PKG_VERSION="1.1"
PKG_LICENSE="nonfree"
PKG_LONGDESC="Mali blob needed for RK3588 gpu"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="manual"
PKG_ACE_FIRMWARE="https://github.com/JeffyCN/mirrors/raw/da680ba8d7f9bb623cdb8bfa6b087bcec24a79ff/firmware/g610/mali_csffw.bin"

#Panfork needs v
makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_firmware_dir)
  curl -Lo ${INSTALL}/$(get_full_firmware_dir)/mali_csffw.bin ${PKG_ACE_FIRMWARE}
}
