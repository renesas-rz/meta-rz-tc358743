SUMMARY = "Copy scripts and EDID to root home"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS:${PN} += "bash"

# Common files for both RZ/V2N and RZ/V2H
SRC_URI = " \
    file://1080p60.edid \
    file://gstreamer_tc358743_1080p60_CAM0_CN7.sh \
    file://gstreamer_tc358743_1080p60_CAM1_CN8.sh \
"

# Extra files ONLY for RZ/V2H
SRC_URI:append:rzv2h = " \
    file://gstreamer_tc358743_1080p60_CAM2_CN9.sh \
    file://gstreamer_tc358743_1080p60_CAM3_CN10.sh \
"

do_install() {
    install -d ${D}${ROOT_HOME}
    
    # Define a local variable to find where the files actually landed
    # In Scarthgap, UNPACKDIR is preferred, but WORKDIR is the classic location
    if [ -n "${UNPACKDIR}" ] && [ -d "${UNPACKDIR}" ]; then
        SRCPATH="${UNPACKDIR}"
    else
        SRCPATH="${WORKDIR}"
    fi

    # Install EDID using the verified path
    if [ -f "${SRCPATH}/1080p60.edid" ]; then
        install -m 0644 ${SRCPATH}/1080p60.edid ${D}${ROOT_HOME}/
    fi
    
    # Install all shell scripts found
    for script in ${SRCPATH}/*.sh; do
        if [ -f "$script" ]; then
            install -m 0755 "$script" ${D}${ROOT_HOME}/
        fi
    done
}

FILES:${PN} += "${ROOT_HOME}/*"