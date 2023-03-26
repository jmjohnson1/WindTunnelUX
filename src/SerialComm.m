% Open the serial port connected to the arduino

% fprintf("Available Serial Ports:\n")
% fprintf(serialportlist)
% fprintf("\n\n")
%port_name = input("Choose a serial port: ");
port_name = "/dev/ttyACM1";
sp = serialport(port_name, 9600);
%sp.FlowControl = 'none';

spdSetting = 100;
flush(sp);
pause(3);
writeline(sp, num2str(spdSetting));

data = readData(sp, 5);
delete(sp);

p1 = AMSSensor(-2000, 2000);
p2 = AMSSensor(-2000, 2000);
p3 = AMSSensor(0, 2000);
p4 = AMSSensor(0, 2000);
ams_sensors = dictionary(31, p1, 30, p2, 18, p3, 17, p4);

for i = 1:4
    addr = data(i, 1);
    raw_pres = data(i, 2);
    raw_temp = data(i, 3);
    p_min = ams_sensors(addr).p_min;
    p_max = ams_sensors(addr).p_max;
    pres = ams_toPascal(raw_pres, p_min, p_max);
    temp = ams_toCelsius(raw_temp);

    ams_sensors(addr).p_values = [ams_sensors(addr).p_values, pres];
    ams_sensors(addr).t_values = [ams_sensors(addr).t_values, temp];
end
    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pressure = ams_toPascal(dp, p_min, p_max)
    % Description:
    %   Converts the differential pressure value output by an AMS5915 from 
    %   a 16 bit integer to its value in Pascals
    % Synopsis:
    %   pressure = ams_toPascal(dp, p_min, p_max)
    % Inputs:
    %   dp          The raw differential pressure value from the sensor
    %   p_min       The minimum p specified in the datasheet
    %   p_max       The maximum p specified in the datasheet
    % Outputs:
    %   pressure    The pressure in Pa

    dp_max = 14745;
    dp_min = 1638;
    sensp = (dp_max - dp_min)./(p_max - p_min);

    pressure = (dp - dp_min)./sensp + p_min;
end

function temp = ams_toCelsius(dt)
    % Description:
    %   Converts the raw temperature value output by an AMS5915 from an 8
    %   bit integer to its value in Celsius
    % Synopsis
    %   temp = ams_toCelsius(dt)
    % Inputs:
    %   dt          The temperature value from the sensor
    % Outputs:
    %   temp        The temperature in degrees Celsius

    temp = dt*200/2048 - 50;
end

function data = readData(port, num_lines)
    
    flush(port); % Clear unread messages
    data = [];
    while port.NumBytesAvailable < 4
    end
    
    first_line = 1;
    i = 1;
    while i < 50
    %while height(data) < num_lines
        if first_line
            useless = readline(port);
            first_line = 0;
        end
        string = readline(port);
        line = str2double(strsplit(string, "\t"));
        if length(line)>1
            data = [data; line];
            
        else
            disp(line);
        end
        i = i+1;
    end
end
