#include "Wire.h"
#include "stdint.h"
#include "math.h"
#include "ams5915.h"
#define varName(var) #var // Allows printing of variable names

// AMS5915 Device Addresses:
const uint8_t addr_p1 = 0x1F;
const uint8_t addr_p2 = 0x1E;
const uint8_t addr_p3 = 0x12;
const uint8_t addr_p4 = 0x11;

// Using the AMS5915 library by Brian Taylor (Bolder Flight Systems)
bfs::Ams5915 p1(&Wire, addr_p1, bfs::Ams5915::AMS5915_0020_D_B, 0);
bfs::Ams5915 p2(&Wire, addr_p2, bfs::Ams5915::AMS5915_0020_D_B, 0);
bfs::Ams5915 p3(&Wire, addr_p3, bfs::Ams5915::AMS5915_0020_D, 0);
bfs::Ams5915 p4(&Wire, addr_p4, bfs::Ams5915::AMS5915_0020_D, 0);

// Values needed for fan setting
const int pwm_pin = 6; // Pin for the fan's PWM signal
int pwr           = 0; // Determines the command sent to the fan as a percentage of max power (10-100%)
int write_val     = 0; // The value that will be sent over analogWrite()

// Density. Kind of a placeholder.
float rho = 1.225;


void setup() {
  pinMode(pwm_pin, OUTPUT);  // Set the fan pin to be an output
  Serial.begin(9600);        // start serial at 9600 baud for monitoring pwr setting
  while (!Serial){}          // Wait until the serial port is ready
  // Initalize wire library for I2C communication
  Wire.begin();
  Wire.setClock(100000);     // A wire frequency of 400 kHz (fast mode) is the max supported by AMS 5915
  // Print error messages if communication can't be established
  if (!p1.Begin()) {
    Serial.println("Error communicating with p1");
    while(1){};
  }
  if (!p2.Begin()) {
    Serial.println("Error communicating with p2");
    while(1){};
  }
  if (!p3.Begin()) {
    Serial.println("Error communicating with p3");
    while(1){};
  }
  if (!p4.Begin()) {
    Serial.println("Error communicating with p4");
    while(1){};
  }
}

void CollectAMSData(bfs::Ams5915 sensor, int purpose, String name) {
  uint16_t pres_cnts = sensor.pres_cnts();
  float pres_mbar;
  float extra_val;
  float press;
  float temp;
  if (sensor.Read()) {
    press     = sensor.pres_pa();
    temp      = sensor.die_temp_c();
    pres_mbar = sensor.pres_mbar();
  }
  // Determine what the sensor is used for (i.e. speed or aoa). This will
  // determine what is printed in the "extra_val" column of the serial line
  switch (purpose) {
    case 1: {
      extra_val = calcAirspeed(press);
      break;
    }
    case 2: {
      extra_val = 0;
      break;
    }
    default: {
      extra_val = 0;
    }
  }

  // Print to serial with tabs separating pressure and temp and a return
  Serial.print(name);
  //Serial.print("\t");
  //Serial.print(pres_cnts);
  //Serial.print("\t");
  //Serial.print(pres_mbar);
  Serial.print("\t");
	Serial.print(press);
  Serial.print("\t");
  //Serial.print(temp);
  //Serial.print("\t");
  Serial.println(extra_val);
}

float calcAirspeed(float dp) {
  if (dp < 0) {
		dp = 0.0f;
  }
  float spd = sqrt(2.0f*dp/rho);
  return spd;
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
  CollectAMSData(p1, 2, "1");
  CollectAMSData(p2, 0, "2");
  CollectAMSData(p3, 1, "3");
  CollectAMSData(p4, 1, "4");

}

