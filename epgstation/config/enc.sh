#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64

ffprobe_cmd=/usr/local/bin/ffprobe
ffmpeg_cmd=/usr/local/bin/ffmpeg
mode=$1
deint=bob

if [ "$mode" = "" ]; then
    mode="main"
fi

function getHeight() {
    echo `$ffprobe_cmd -v 0 -show_streams -of flat=s=_:h=0 "$INPUT" | grep stream_0_width | awk -F= '{print \$2}'`
}

if [ `getHeight` -gt 720 ]; then
    $ffmpeg_cmd -y -hwaccel cuvid -c:v mpeg2_cuvid -deint $deint -dual_mono_mode $mode -i "$INPUT" -f mp4 -vf scale_npp=1280:720 -c:v h264_nvenc -qp 23 -c:a aac -ar 48000 -ab 192k -ac 2 "$OUTPUT"
else
    $ffmpeg_cmd -y -c:v mpeg2_cuvid -deint $deint -dual_mono_mode $mode -i "$INPUT" -f mp4 -c:v h264_nvenc -qp 23 -c:a aac -ar 48000 -ab 192k -ac 2 "$OUTPUT"
fi

