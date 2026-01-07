SUMMARY = "Copy scripts and EDID to root home"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS:${PN} += "bash"

SRC_URI = "file://gstreamer_tc358743_1080p60_CAM0_CN7.sh \
           file://gstreamer_tc358743_1080p60_CAM1_CN8.sh \
           file://1080p60.edid \
          "

inherit allarch

do_install() {
    install -d ${D}${ROOT_HOME}
    install -m 0755 ${WORKDIR}/gstreamer_tc358743_1080p60_CAM0_CN7.sh ${D}${ROOT_HOME}/
    install -m 0755 ${WORKDIR}/gstreamer_tc358743_1080p60_CAM1_CN8.sh ${D}${ROOT_HOME}/
    install -m 0644 ${WORKDIR}/1080p60.edid ${D}${ROOT_HOME}/
}

# SCARTHGAP SYNTAX: Use the colon (:) instead of underscore (_)
FILES:${PN} += "${ROOT_HOME}/*"