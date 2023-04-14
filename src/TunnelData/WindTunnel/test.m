files = ls('*.dat');
files = strsplit(files);
files(end) = [];
commentMatch = 'User comment: (*.)';


for i = 1:length(files)
    contents = fileread(files(i));
    comment(i) = regexp(contents, commentMatch, 'tokens');
end