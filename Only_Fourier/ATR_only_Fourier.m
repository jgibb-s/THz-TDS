%%
clc
clear all
close all

% Auxiliary functions needed:
% read_compare_file
% get_data_adjust_stvt
% adjust_time
% fft_pad_cell
% plot_from_cell_t
% plot_from_cell_nu_amp
%%

file_directory = 'F:\Josh G\data\2021_04_04';
file_name = 'compare';
[sample, data_file, stvt] = read_compare_file(file_directory, file_name);
nn = length(sample);
pad_pwr = 1;

%% Adjust sensitivity
data.org = get_data_adjust_stvt(data_file, stvt);
sz = size(data.org);
fig.data_org = plot_from_cell_t(data.org, sample, 0, 0);
title(fig.data_org(2), 'Waveform')

%% Adjust time
y_offset = 0;
x_offset = 0;
data.t = adjust_time(data.org);
fig.data = plot_from_cell_t(data.t, sample, y_offset, x_offset);
title((fig.data(2)), 'Waveform')

%% Nu domain
nu_y_offset = 0;
nu_scale_y = 10;
[spec, res]  = fft_pad_cell(data.t, pad_pwr);

fig_nu = plot_from_cell_nu_amp(spec, sample, nu_y_offset, nu_scale_y);
fig_nu(2).XLim = [0.2 5];

%% Close unnecessary figs
close(fig.data_org(1))