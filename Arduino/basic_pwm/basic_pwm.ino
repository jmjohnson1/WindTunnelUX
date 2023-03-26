#include "Wire.h"

// AMS5915 Device Addresses:
const uint8_t addr_p1 = 0x1F;
const uint8_t addr_p2 = 0x1E;
const uint8_t addr_p3 = 0x12;
const uint8_t addr_p4 = 0x11;

int pwr = 10;       // Determines the command sent to the fan as a percentage of max power (10-100%)
int pwm_pin = 6;    // Pin for the fan's PWM signal
int write_val = 0;  // The value that will be sent over analogWrite()


void setup() {
 pinMode(pwm_pin, OUTPUT);  // Set the fan pin to be an output
 Serial.begin(9600);        // start serial at 9600 baud for monitoring pwr setting
}

void loop() {
  // The value to write to analogWrite is between 0 and 255. 0 is 0% duty cycle. 255 is 100% duty cycle
  write_val = pwr*255/100;

  // Output the initial power setting to the fan
  analogWrite(6, write_val);

  // Check if the user has input a change to the power setting.
  if(Serial.available()) 
    // Set pwr to be the user's new desired value
    pwr = Serial.parseInt();   // parse the power setting from serial
    while (Serial.available() != 0 ) {
    Serial.read();
  }

  // Print pwr to the serial line for debug purposes
  Serial.println(pwr);

}
