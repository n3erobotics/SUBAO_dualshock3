all:	joystick

joystick: joystick.cpp
	g++ Dualshock3.cpp SerialPort.cpp joystick.cpp -o joystick -lbluetooth
