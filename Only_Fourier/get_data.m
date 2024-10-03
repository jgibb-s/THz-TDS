function data = get_data(file_info, headerlines)

if nargin < 2
    headerlines = 0;
end

fid = fopen(file_info, 'rt');
C = textscan(fid, '%f %f', 'HeaderLines', headerlines);
fclose(fid);
data = cell2mat(C);

end