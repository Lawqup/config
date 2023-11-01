#!/usr/bin/zsh

for i in *.mov
do
    ffmpeg -i "$i"\
           -c:v dnxhd -profile:v dnxhr_hq -pix_fmt yuv422p -c:a pcm_s16le -f mov\
           "${i%.*}.output.mov"

    mv "${i%.*}.output.mov" "${i%.*}.mov"
done
