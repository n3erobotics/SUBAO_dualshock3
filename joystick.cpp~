#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/joystick.h>
#include <cstdlib>
#include <iostream>
#include <signal.h>
#include <sys/socket.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/rfcomm.h>

#include "SerialPort.h"
#include "Dualshock3.h"

#define JOY_DEV "/dev/input/js0"

#define FWD 0
#define BCK	1
#define LEFT 2
#define RIGHT 3
#define DIR 4

using namespace std;

int s, joy_fd;

int processed_values[4] = {0,0,0,0};

SerialPort serialPort;

void my_handler(int signal){
           printf("Caught CTRL+C\n");
           serialPort.disconnect();
           exit(1);
}

void send_message(char aux, int value){
	char buffer[5];
	
	sprintf (buffer, "%c%03d\n", aux, value);
	cout << buffer << endl;
	serialPort.sendArray(buffer);
}

void apply_values(){
	//Send data to robot
	char aux;
	int value;
  	
	if (processed_values[FWD] != 0){
		aux = 'f';
		value = processed_values[FWD];
	}
	
	if (processed_values[BCK] != 0){
		aux = 'b';
		value = processed_values[BCK];
	}
	
	if(processed_values[FWD] == 0 && processed_values[BCK] == 0){
		aux = 'n';
		value = 0;
	}
	
	send_message(aux, value);
	
	if (processed_values[LEFT] != 0){
		aux = 'l';
		value = processed_values[LEFT];
	}
	
	if (processed_values[RIGHT] != 0){
		aux = 'r';
		value = processed_values[RIGHT];
	}
	
	if(processed_values[LEFT] == 0 && processed_values[RIGHT] == 0){
		aux = 'l';
		value = 0;
	}
	
	send_message(aux, value);
	
	cout << "FWD [" << processed_values[FWD] << "] | BCK ["<< processed_values[BCK] << "] | LEFT [" << processed_values[LEFT] << "] | RIGHT [" << processed_values[RIGHT] << "]" << endl;
}

void input_processing (int cmd, int input){
	if (cmd == DIR){
		if (input > 0){
			cmd = LEFT;
			input_processing(cmd, 0);
			cmd = RIGHT;
		}else if(input < 0){
			cmd = RIGHT;
			input_processing(cmd, 0);
			cmd = LEFT;
			input = abs(input);
		}else{
			cmd = LEFT;
			input_processing(cmd, input);
			cmd = RIGHT;
		}
	}
	if (processed_values[cmd] == 0 && input != 0 || processed_values[cmd] != 0 && input == 0 || processed_values[cmd] != 0 && input != 0){
		switch(cmd){
			case FWD:
				processed_values[cmd] = input/300;
				break;
			case BCK:
				processed_values[cmd] = input/300;
				break;
			case LEFT:	
				processed_values[cmd] = input/547;
				break;
			case RIGHT:
				processed_values[cmd] = input/547;
				break;
		}
		
		apply_values();
	}
	
	
}

int main()
{
	Dualshock3 joystick;
	joystick.connect();
	
	int err=serialPort.connect("//dev//ttyACM0");

	while( 1 ) 	/* infinite loop */
	{

		joystick.getData();
		
		if (joystick.button[16]){
			serialPort.disconnect();
			close( joy_fd );
			system("sixad --stop &");
			//wait_for_joystick();
			exit(0);
		}
		
		// Detect conflits and process input
		
		if (joystick.axis[12] != 0 && joystick.axis[13] != 0){
			// Rumbleeeeeee
			send_message('n', 0);
		}else if(joystick.axis[12] != 0 && joystick.axis[13] == 0){
			send_message('b', joystick.axis[12]/300);
		}else if(joystick.axis[13] != 0 && joystick.axis[12] == 0){
			send_message('f', joystick.axis[13]/300);
		}
		
		input_processing(DIR, joystick.axis[0]);
	
	}


	serialPort.disconnect();
	close( joy_fd );	/* too bad we never get here */
	return 0;
}
