#include "Wire.h"
#include "stdint.h"

// AMS5915 Device Addresses:
const uint8_t addr_p1 = 0x1F;
const uint8_t addr_p2 = 0x1E;
const uint8_t addr_p3 = 0x12;
const uint8_t addr_p4 = 0x11;


int pwr = 0;       // Determines the command sent to the fan as a percentage of max power (10-100%)
int pwm_pin = 6;    // Pin for the fan's PWM signal
int write_val = 0;  // The value that will be sent over analogWrite()


void setup() {
 pinMode(pwm_pin, OUTPUT);  // Set the fan pin to be an output
 Serial.begin(9600);        // start serial at 9600 baud for monitoring pwr setting
 while (!Serial){}          // Wait until the serial port is ready
 // Initalize wire library for I2C communication
 Wire.begin();
 Wire.setClock(100000);     // A wire frequency of 400 kHz (fast mode) is the max supported by AMS 5915
}

void CollectAMSData(uint8_t addr) {
 // Request data from the pressure sensor
  const uint8_t buff_size = 4;
  Wire.requestFrom(addr, buff_size);
  //Serial.println("Called wire_Request");
  if (4 <= Wire.available()) {
    //Serial.println("Wire is available");
    int press_read = Wire.read(); // Read the first byte
    press_read = press_read << 8; // The first byte contains the 8 high bits
    press_read |= Wire.read();    // Read the second byte and OR it with the 8 high bits

    int temp_read = Wire.read(); // Similar thing for temperature
    temp_read = temp_read << 3;
    temp_read |= (Wire.read() >> 5);

    // Print to serial with tabs separating pressure and temp and a return
    Serial.print(addr);
    Serial.print("\t");
    Serial.print(press_read);
    Serial.print("\t");
    Serial.println(temp_read);
  }
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
  // Serial.println(pwr);
  // Serial.println(write_val);
  CollectAMSData(addr_p1);
  CollectAMSData(addr_p2);
  CollectAMSData(addr_p3);
  CollectAMSData(addr_p4);

}

