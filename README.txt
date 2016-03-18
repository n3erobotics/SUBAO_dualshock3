For compilation:

sudo apt-get install libbluetooth-dev

For pairing and running:

https://help.ubuntu.com/community/Sixaxis

1. Add the qtsixa ppa which contains an updated version of sixad

	sudo apt-add-repository ppa:falk-t-j/qtsixa

2. Update and install the sixad package.

	sudo apt-get update
	sudo apt-get install sixad

----- Running -----

1. Connect your ps3 controller to your computer via usb and run:

	sudo sixpair

2. Unplug your ps3 controller from the usb cable and run:

	sixad --start

3. When prompted, press the PS button on the controller. 
If it's detected correctly, the controller will vibrate.
Then use jstest-gtk to test your controller.
