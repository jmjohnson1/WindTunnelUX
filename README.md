# WindTunnelUX
User interface for desktop wind tunnel.

# Arduino
The microcontroller code is located in the "Arudino" directory. For the sake of documentation, several versions of the program exist. Once a final version is created, it will be indicated by the suffix "-final".

Current version: pwm_with_ams5915_SPEED

Note that you will need to copy the directory Arduino/libs/ams5915 to your Arduino libraries folder. This contains class definitions for the AMS pressure sensors that are used in the Arduino program. This library was originally created by Brian Taylor at Bolder Flight Systems, and slightly modified for this project by James Johnson.

# Source files
The files located in src/ -- perhaps not the greatest name for the directory -- include various Matlab scripts and the Matlab app. Some scripts only exist for feature testing and will be removed later.

# List of Source Files and their Purpose
- AMSSensor.m (Deprecated)      A Matlab class for the AMS5915 sensor that was used in an earlier version of the app
- AOA_TABLE_LOOKUP_SCRIPT.m     Script for populating a lookup table for the angle of attack pressure measurements from the PSA (pitot-static-alpha) probe.
- SerialComm.m                  Script used for testing the ability to read/write data from/to the Arduino in matlab
- TunnelApp2.m                  The current version of the user interface
- aoa_ratio_to_AOA.m            
- calculate_AOA.m               Function to calculate AoA from q_cm
- test.m                        Testing input from Arduino again
