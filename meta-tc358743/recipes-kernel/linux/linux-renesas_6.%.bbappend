FILESEXTRAPATHS:prepend := "${THISDIR}/linux-renesas:"

SRC_URI += " \
    file://0001-Add-tc358743-driver.patch \
    file://0002-Remove-OV5645-and-added-TC358743-power.patch  \
    file://0003-add-tc358743-camera-CAM0-CN7.patch \
    file://0004-add-tc358743-camera-CAM1-CN8.patch \
    file://tc358743.cfg \
"
