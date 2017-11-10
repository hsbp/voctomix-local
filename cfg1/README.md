HAVOC voctomix configuration 1
==============================

	 _______________________
	| Black PC              |
	|                       |
	|     ,-----<DeckLink 1=+==<-HDMI)==[DSLR]
	|    /                  |
	|    |   ,--<DeckLink 2=+==<-HDMI)==[Zidoo]==<-HDMI)==[Speaker notebook]
	|    |   \              |
	|    v    >->Ethernet===+==(2xTCP->==[Voctomix notebook]
	|   MUX>-'              |
	|    ^------<Sound card=+==<-2xUnbalanced)==[Audio mixing console]
	|_______________________|

Hardware
--------

 - Black PC
   - 2 DeckLink cards
   - integrated sound card
   - two gigabit Ethernet ports (one integrated, one PCI)
 - Canon EOS 700D DSLR (connected to DeckLink marked with yellow tape)
   - for easier connections, an HDMI-HDMI cable has an HDMI to mini-HDMI
     adapter on one end, and the other end is also marked with yellow tape
 - Zidoo X9 (connected to the other DeckLink)

Constraints
-----------

 - DSLR can only output 1080i 29.97 FPS over mini-HDMI
   - and only approx. 1600x900 is the real picture
 - HDMI stream from DSLR doesn't contain audio
 - Black PC doesn't have enough computing power to run `voctocore`
 - notebooks don't have full-sized PCIe slots
 - Zidoo X9 HDMI resolution can be changed, but it cannot send 29.97 FPS over HDMI

Parameters
----------

 - Video:
   - 1280x720 so that two streams can fit within the gigabit pipe and 1080p
     is too much for some streams
   - 29.97 FPS to match the DSLR
 - Audio: stereo 16-bit input from ALSA since no audio comes over HDMI

Operation
---------

### Management
 - Black PC uses DHCP to acquire an IP address on any of its Ethernet ports
 - SSH can be used to log in using the username `a` with the same password

### Camera

Running `cam.sh` on the black PC causes the DeckLink (video) and ALSA (audio)
inputs to be streamed over to TCP port 10000 of the SSH client

 - the first audio input is used
 - because of the framing of the DSLR, the input is cropped to 1600x900 and
   scaled to 1280x720
 - because of the interlaced input, the `yadif` deinterlacing filter is used
   between the crop and scale operations
 - DeckLink is configured to use the HDMI input in `Hi59` format
 - the thread queue size is [enlarged for both inputs to avoid buffer underruns][thread_queue_size]

### Slides

Running `slides.sh` on the black PC causes video from the other DeckLink input
to be streamed over to TCP port 10001 of the SSH client

 - Zidoo X9 is configured for 1280x720 60 FPS output
 - DeckLink is configured to use the HDMI input in `hp60` format
 - the frame rate is converted by FFmpeg to 29.97

  [thread_queue_size]: https://stackoverflow.com/questions/28359855/alsa-buffer-xrun-induced-by-low-quality-source-in-ffmpeg-capture/31016087#31016087
