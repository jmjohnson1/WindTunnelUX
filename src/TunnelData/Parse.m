

datafile = fileread("WindTunnel_cali_1-1.dat");
density = str2double(string(regexp(datafile, 'Density\s*=\s(\d+.\d+)', 'tokens')));


