num_lines = 100;  % Number of serial lines to read
port = serialport("/dev/ttyACM1", 9600); % Initialize the serial port
flush(port); % Clear unread messages
data = [];
while port.NumBytesAvailable < 4   % Wait until the serial port is ready
end

for i = 1:num_lines
    if i == 1
        useless = readline(port);   % Dump the first line to an unused variable
    end
    string = readline(port);
    line = str2double(strsplit(string, "\t"));
    data = [data; line];
end
clear port

aoa_dat = data(data(:, 1)==1, :);
ref_dat = data(data(:, 1)==3, :);
uut_dat = data(data(:, 1)==4, :);
plot(app.AspdPlot, uut_dat(3));
plot(app.AoaPlot, aoa_dat(2));

app.DynamicPressureGauge.Value = ref_dat(2);
app.MeasuredAirspeedGauge = ref_dat(3);