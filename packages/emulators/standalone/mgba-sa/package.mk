# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2023-present - The JELOS Project (https://github.com/JustEnoughLinuxOS)

PKG_NAME="mgba-sa"
PKG_VERSION="09f456484cb401856d5dda1af5b80a659b7c2097"
PKG_LICENSE="Mozilla Public License Version 2.0"
PKG_SITE="https://mgba.io/"
PKG_URL="https://github.com/mgba-emu/mgba.git"
PKG_DEPENDS_TARGET="toolchain ffmpeg libzip qt5"
PKG_LONGDESC="mGBA is an emulator for running Game Boy Advance games. It also supports Game Boy and Game Boy Color games."
GET_HANDLER_SUPPORT="git"
PKG_GIT_CLONE_BRANCH="master"
PKG_GIT_CLONE_SINGLE="yes"
PKG_TOOLCHAIN="cmake"

if [ "${OPENGL_SUPPORT}" = "yes" ] && [ ! "${PREFER_GLES}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd"
elif [ "${OPENGLES_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGLES}"
fi

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET+="-DUSE_DISCORD_RPC=OFF \
					   -DBUILD_GL=OFF \
					   -DBUILD_SDL=OFF \
					   -DBUILD_QT=ON \
					   -DCMAKE_BUILD_TYPE=Release \
					   -DBUILD_LTO=ON"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/lib
  cp -rf ${PKG_BUILD}/.${TARGET_NAME}/qt/mgba-qt ${INSTALL}/usr/bin
  cp -rf ${PKG_BUILD}/.${TARGET_NAME}/libmgba.so* ${INSTALL}/usr/lib
  cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin

  chmod +x ${INSTALL}/usr/bin/start_mgba.sh

  mkdir -p ${INSTALL}/usr/config/${PKG_NAME}
  cp ${PKG_DIR}/config/common/* ${INSTALL}/usr/config/${PKG_NAME}
}

