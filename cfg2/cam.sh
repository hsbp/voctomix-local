#!/bin/sh
SSH_IP=$(echo $SSH_CLIENT | cut -f 1 -d ' ')

ffmpeg -y -nostdin -thread_queue_size 1024 -f decklink \
	-thread_queue_size 1024 -format_code hp50 -video_input hdmi \
	-i 'DeckLink Mini Recorder (2)' -r 25 \
	-c:v rawvideo -c:a pcm_s16le -pix_fmt yuv420p -f matroska tcp://$SSH_IP:10000
