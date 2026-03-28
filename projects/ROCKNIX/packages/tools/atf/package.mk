# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

PKG_NAME="atf"

PKG_ARCH="arm aarch64"
PKG_LICENSE="BSD-3c"
PKG_SITE="https://github.com/ARM-software/arm-trusted-firmware"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="ARM Trusted Firmware is a reference implementation of secure world software, including a Secure Monitor executing at Exception Level 3 and various Arm interface standards."
PKG_TOOLCHAIN="manual"
PKG_PATCH_DIRS+="${DEVICE}"

PKG_VERSION="8dae0862c502e08568a61a1050091fa9357f1240"
PKG_URL="https://review.trustedfirmware.org/plugins/gitiles/TF-A/trusted-firmware-a/+archive/${PKG_VERSION}.tar.gz"

unpack() {
  # For some reason or build system can't unpack this appropraitely so it manually
  mkdir -p "${PKG_BUILD}"
  cd "${PKG_BUILD}"
  tar -xzf "${SOURCES}/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
}


[ -n "${KERNEL_TOOLCHAIN}" ] && PKG_DEPENDS_TARGET+=" gcc-${KERNEL_TOOLCHAIN}:host"

if [ "${ATF_PLATFORM}" = "rk3399" ]; then
  PKG_DEPENDS_TARGET+=" gcc-arm-none-eabi:host"
  export M0_CROSS_COMPILE="${TOOLCHAIN}/bin/arm-none-eabi-"
fi

make_target() {
  if [ "${DEVICE}" = "H700" ]; then
    STUB_DIR="${SYSROOT_PREFIX}/usr/share/h700-suspend-stub"
    ATF_SUSPEND="SUNXI_SYSTEM_SUSPEND=1 SUNXI_SUSPEND_STUB=${STUB_DIR}/suspend_stub_lpddr4.bin"
    ATF_SUSPEND+=" SUNXI_SUSPEND_STUB2=${STUB_DIR}/suspend_stub_lpddr3.bin"
  fi

  CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" CFLAGS="" make PLAT=${ATF_PLATFORM} ${ATF_SUSPEND} bl31
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/bootloader
  cp -a build/${ATF_PLATFORM}/release/${ATF_BL31_BINARY} ${INSTALL}/usr/share/bootloader

  # u-boot embeds BL31 at build time. It read it straight out of this package's
  # build directory, which neither survives AUTOREMOVE nor crosses a CI job
  # boundary. Stage it in the sysroot, which is carried between jobs.
  if [ -n "${ATF_BL31_BINARY}" ]; then
    mkdir -p ${SYSROOT_PREFIX}/usr/share/${PKG_NAME}
    cp -a build/${ATF_PLATFORM}/release/${ATF_BL31_BINARY} ${SYSROOT_PREFIX}/usr/share/${PKG_NAME}
  fi
}
