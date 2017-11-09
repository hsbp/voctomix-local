#!/bin/sh
SSH_IP=$(echo $SSH_CLIENT | cut -f 1 -d ' ')

ffmpeg -y -nostdin -f alsa -thread_queue_size 1024 -i hw:0 -f decklink \
	-thread_queue_size 1024 -format_code Hi59 -video_input hdmi \
	-i 'DeckLink Mini Recorder (2)' -vf crop=1600:900:160:90,yadif,scale=1280:720 \
	-c:v rawvideo -c:a pcm_s16le -pix_fmt yuv420p -f matroska tcp://$SSH_IP:10000
