# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="g610-mali-csffw"
PKG_VERSION="1.1"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/JeffyCN/mirrors"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="Mali blob needed for RK3588 gpu"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="manual"

#Panfork needs v
makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_firmware_dir)
    cp -a ${PKG_BUILD}/firmware/g610/mali_csffw.bin ${INSTALL}/$(get_full_firmware_dir)
}
