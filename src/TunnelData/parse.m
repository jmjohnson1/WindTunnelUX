function jointArray = parse()
    % Sort dat files based on their comments
    files = ls('ReferenceDat/*.dat');
    files = strsplit(files);
    files(end) = [];
    commentMatch = 'User comment: (\S*)';
    for i = 1:length(files)
        fname(i) = string(files(i));
        contents = fileread(fname(i));
        comment(i) = string(regexp(contents, commentMatch, 'tokens'));
    end
    [commentSorted, sortIdx] = sort(comment, 'descend');
    jointArray = [fname(sortIdx)', commentSorted'];
    
    for i = 1:length(jointArray)
        datafile = fileread(jointArray(i, 1));
        density(i) = str2double( ...
            string( ...
                    regexp(datafile, 'Density\s*=\s(\d+.\d+)', 'tokens') ...
                ) ...
            );
        pressureDiff(i) = str2double( ...
            string( ...
                    regexp(datafile, 'Fixed Pitot Probe Pressure\s*=\s(\d+.?\d*)', 'tokens') ...
                ) ...
            );
        sensorTemp = str2double(string(regexp(commentSorted(i), 'Sensor(\d)', 'tokens')));
        if isempty(sensorTemp)
            sensor(i) = 0;
        else
            sensor(i) = sensorTemp;
        end
        refSpeed(i) = str2double(string(regexp(datafile, 'Fixed Pitot Probe Speed\s*=\s(\d*.?\d*)', 'tokens')));
    end
    
    jointArray = [jointArray, sensor', density', pressureDiff', refSpeed'];
end