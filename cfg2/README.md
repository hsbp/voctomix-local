HAVOC voctomix configuration 1
==============================

	 _______________________
	| Black PC              |
	|                       |
	|     ,-----<DeckLink 1=+==<-HDMI)==[Canon XF100]==<-2xBalanced)==[Audio mixing console]
	|    /                  |
	|    |   ,--<DeckLink 2=+==<-HDMI)==[Zidoo]==<-HDMI)==[Speaker notebook]
	|    |   \              |
	|    '---->->Ethernet===+==(2xTCP->==[Voctomix notebook]
	|_______________________|

Hardware
--------

 - Black PC
   - 2 DeckLink cards
   - integrated sound card
   - two gigabit Ethernet ports (one integrated, one PCI)
 - Canon XF100 camera (connected to DeckLink marked with yellow tape)
 - Zidoo X9 (connected to the other DeckLink)

Constraints
-----------

 - XF100 can output 720p 50 FPS over HDMI
 - HDMI stream from XF100 contains stereo audio at 48 kHz
 - Black PC doesn't have enough computing power to run `voctocore`
 - notebooks don't have full-sized PCIe slots
 - Zidoo X9 HDMI resolution can be changed, but it cannot send 25 FPS over HDMI

Parameters
----------

 - Video:
   - 1280x720 so that two streams can fit within the gigabit pipe and 1080p
     is too much for some voctomix notebooks
   - 25 FPS which is evenly divisible of the 50 FPS produced by XF100
 - Audio: stereo 16-bit input at 48 kHz over HDMI from the camera

Operation
---------

### Management
 - Black PC uses DHCP to acquire an IP address on any of its Ethernet ports
 - SSH can be used to log in using the username `a` with the same password

### Camera

Running `cam.sh` on the black PC causes the DeckLink
inputs to be streamed over to TCP port 10000 of the SSH client

 - the audio from the HDMI input is used
 - DeckLink is configured to use the HDMI input in `hp50` format
 - the frame rate is converted by FFmpeg to 25

### Slides

Running `slides.sh` on the black PC causes video from the other DeckLink input
to be streamed over to TCP port 10001 of the SSH client

 - Zidoo X9 is configured for 1280x720 60 FPS output (TODO: it can do 50 as well)
 - DeckLink is configured to use the HDMI input in `hp60` format
 - the frame rate is converted by FFmpeg to 25
