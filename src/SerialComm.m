% Open the serial port connected to the arduino
port_name = "/dev/ttyACM1";
sp = serialport(port_name, 9600);
flush(sp);

data = readData(sp, 1000);
delete(sp);

p1_dat = data(data(:, 1)==1, :);
p2_dat = data(data(:, 1)==2, :);
p3_dat = data(data(:, 1)==3, :);
p4_dat = data(data(:, 1)==4, :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = readData(port, num_lines)
    
    flush(port); % Clear unread messages
    data = [];
    while port.NumBytesAvailable < 4
    end
    
    first_line = 1;
    i = 1;
    while i <= 1000
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
