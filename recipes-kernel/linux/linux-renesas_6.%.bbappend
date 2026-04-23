FILESEXTRAPATHS:prepend := "${THISDIR}/linux-renesas:"

SRC_URI += "file://tc358743.cfg"

SRC_URI:append:rzv2n-evk = " \
    file://0001-Add-tc358743-frequency-control.patch \
    file://0002-Remove-OV5645.patch \
    file://0003-Add-tc358743-Power-and-Clock.patch \
    file://0004-Add-tc358743-camera-CAM0-CN7.patch \
    file://0005-Add-tc358743-camera-CAM1-CN8.patch \
"

SRC_URI:append:rzv2h-evk = " \
    file://0001-Add-tc359743-freguency-control.patch \
    file://0002-Remove-OV5645.patch \
    file://0003-Add-tc358743-Camera-CAM0-CN7.patch \
    file://0004-Add-tc358743-Camera-CAM1-CN8.patch \
    file://0005-Add-tc358743-Camera-CAM2-CN9.patch \
    file://0006-Add-tc358743-Camera-CAM3-CN10.patch \
"

do_configure:append() {
    cat ${WORKDIR}/tc358743.cfg >> ${B}/.config
}