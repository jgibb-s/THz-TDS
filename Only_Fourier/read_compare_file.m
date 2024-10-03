function [ sample_cell, file_info_cell, sensitivity_mat] = read_compare_file(file_directory, file_name)
% 
% do NOT put .txt in any file names
% input1: directory_address where your compare file is
% input2: file_name of compare file; default is 'compare' if you do not
% supply 2nd argument of function
%
% This function reads 'compare' text file containing:
%
%
% sample  ;  data_file_name ; sensitivity
%
%
% fields have to be delimited by semicolon --> ;
% # is used for comment
% 1st 2 lines in 'compare' file are headerlines
%
% 3 Outputs are self-explanatory


%% BODY

if nargin < 2
   file_name = 'compare'; 
end

file_info = fullfile(file_directory, file_name);
file_info = strcat(file_info,'.txt');

file_id = fopen(file_info);

%info_cell = textscan(file_id, '%s %s %f','Delimiter',';', 'HeaderLines', 2, 'CommentStyle','#');
info_cell = textscan(file_id, '%s %s %f','Delimiter',',','HeaderLines', 2, 'CommentStyle','#');

sample_cell = info_cell{1};
file_info_cell = strcat(fullfile(file_directory,info_cell{2}), '.txt');
sensitivity_mat = info_cell{3};


fclose(file_id);
end

