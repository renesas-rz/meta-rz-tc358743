#!/bin/bash

export MEDIA_DEV="/dev/media1"
export TC358743_SUBDEV="/dev/v4l-subdev4"
export VIDEO_DEV="/dev/video1"

echo "=== TC358743 V4L2 Event Trigger ==="

# 1. Complete clean setup
echo "1. Clean setup..."
media-ctl -d $MEDIA_DEV -r
sleep 3

# 2. Setup pipeline with ALL formats specified
echo "2. Setting up complete pipeline..."
media-ctl -d $MEDIA_DEV -l '"tc358743 1-000f":0 -> "csi-16010400.csi21":0 [1]'
media-ctl -d $MEDIA_DEV -l '"cru-ip-16010000.cru1":1 -> "CRU output":0 [1]'

# Set formats on ALL entities
media-ctl -d $MEDIA_DEV -V '"tc358743 1-000f":0 [fmt:UYVY8_1X16/1920x1080 field:none colorspace:rec709]'
media-ctl -d $MEDIA_DEV -V '"csi-16010400.csi21":0 [fmt:UYVY8_1X16/1920x1080 field:none]'
media-ctl -d $MEDIA_DEV -V '"csi-16010400.csi21":1 [fmt:UYVY8_1X16/1920x1080 field:none]'

sleep 2

# 3. Set video device format
echo "3. Setting video device..."
v4l2-ctl -d $VIDEO_DEV --set-fmt-video=width=1920,height=1080,pixelformat=UYVY

# 4. Load 1080p60 EDID
echo "4. Loading EDID ..."
v4l2-ctl -d $TC358743_SUBDEV --set-edid=file=1080p60.edid --fix-edid-checksums
sleep 1
v4l2-ctl -d $TC358743_SUBDEV --set-dv-bt-timings=width=1920,height=1080,interlaced=0,pixelclock=148500000
sleep 1

# 5. Start Capture to file with V4L2
echo "5. Start Capture to File with V4L2 ..."
# This might trigger the TC358743 to start transmitting
# This will capture 5 frames to raw file
v4l2-ctl -d $VIDEO_DEV --set-fmt-video=width=1920,height=1080,pixelformat='UYVY'
v4l2-ctl -d $VIDEO_DEV --stream-mmap --stream-count=5 --stream-to=/tmp/test_event.raw &
sleep 5

# Test file capture
if [ -s "/tmp/test_event.raw" ]; then
    echo "✅ SUCCESS! CSI-TX activated: $(ls -lh /tmp/test_event.raw)"
else
    echo "❌ V4L2 events failed"
    
    echo "checking TC358743 Status"
	# Need to run the tc358743 to get propoer log
	v4l2-ctl -d $VIDEO_DEV --stream-mmap --stream-count=5 &
	v4l2-ctl -d $TC358743_SUBDEV --log-status 2>/dev/null
	sleep 5

	# 7. Last attempt: Check if there are any V4L2 controls we can use
    echo "7. Checking for V4L2 controls..."
    v4l2-ctl -d $TC358743_SUBDEV --list-ctrls-menus
    
    # Try to find any control that might enable transmission
    echo "8. Testing available controls..."
    v4l2-ctl -d $TC358743_SUBDEV --list-ctrls | while read line; do
        if echo "$line" | grep -q "(int)"; then
            ctrl=$(echo "$line" | awk '{print $1}')
            echo "Testing control: $ctrl"
            v4l2-ctl -d $TC358743_SUBDEV -c "$ctrl=1" 2>/dev/null
        fi
    done
	exit 0
fi

gst-launch-1.0 v4l2src device=$VIDEO_DEV io-mode=dmabuf ! \
"video/x-raw,format=UYVY,width=1920,height=1080,framerate=60/1" \
! videoconvert ! waylandsink sync=false

