# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="yq"
PKG_LICENSE="MIT"
PKG_DEPENDS_TARGET="toolchain"
PKG_SITE="https://github.com/mikefarah/yq"
PKG_VERSION="4.50.1"
PKG_URL="${PKG_SITE}/releases/download/v${PKG_VERSION}/yq_linux_arm64"
PKG_ARCH="aarch64" # can easily be extended since we just pull blobs
PKG_LONGDESC="yq is a portable command-line YAML, JSON, XML, CSV, TOML, HCL and properties processor"
PKG_TOOLCHAIN="manual"

unpack() {
 true
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${ROOT}/sources/yq/yq-${PKG_VERSION}.yq_linux_arm64 ${INSTALL}/usr/bin/yq
  chmod 755 ${INSTALL}/usr/bin/*
}
