#!/bin/sh
SSH_IP=$(echo $SSH_CLIENT | cut -f 1 -d ' ')

ffmpeg -y -nostdin -f decklink -format_code hp60 -video_input hdmi \
	-i 'DeckLink Mini Recorder (1)' -r 25 -c:v rawvideo -c:a pcm_s16le \
	-pix_fmt yuv420p -f matroska tcp://$SSH_IP:10001
