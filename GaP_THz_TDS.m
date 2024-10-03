% Orginally written by Akif Ahmed, modified by Josh Gibbs (2021)
clearvars -except ard shield sm_sample
close all

%% Global variables
global shift_delay callibration_factor device_name dq ;
shift_delay = 150 / 1000;
callibration_factor = 0.033356409519815; % multiply step positions to convert to time delay in pico sec.

%% Experimental parameters
data_folder = fullfile('F:\Josh G', 'data');
experiment_name =  'L+-Glutamic acid (80 ps)';
peak_step = 3567;         % Free space peak located around 3545 steps

pre_scan_length = 3;      % ps before peak.  Default 3 ps
scan_length = 80;         % ps after peak. 50 ps = 20 GHz resolution, 100 ps = 10 GHz
sweeps = 5;               % 10+ for noise reduction in samples
step_size = 2;            % Default: 2 steps (4 steps cutoff is 3.75 THz) 

%humidity
check_humidity = false;    
current_humidity = 6;
humidity_limit = 1;       % Consistency is key. Better to have sample and ref within 0.1% of each other than to try to get both to 0%

%lalser parameters
laser_amp_percentage = '54%';
laser_rep_rate = '10 MHz'; 
laser_power = '10 Watts'; 
laser_steps = '425 Steps'; 

%lock-in parameters
sensitivity = '50 mV';    
time_constant = '30 ms';  % Default: 30 ms 
roll_off = '18 dB';       % Default: 18 dB
ref_freq = '997 Hz';      % 997 Hz for Nirvana, 23 Hz for homebrew detector

comments = 'L-(+)-Glutamic acid on polyolefin film - transmission';
%% Start DAQ
daq.getDevices;
dq = daq.createSession('ni'); %set daq parameters
dq.Rate = 250000;
daq_sample = 5000;
dq.DurationInSeconds = (daq_sample/dq.Rate);  
daq_sig_channel = 'ai2';
daq_pwr_channel = 'ai7';
addAnalogInputChannel(dq,'Dev1', daq_sig_channel, 'Voltage');
% data_daq = dq.startForeground; % this command will output an coloumn array of data 

%% Start/detect Stage
device_name = detect_stage();

%% Create data folder
if ~exist(data_folder, 'dir')
    mkdir(data_folder)
end

dt_folder = datestr(now, 'yyyy_mm_dd');
folder_info = fullfile(data_folder, dt_folder);
if ~exist(folder_info, 'dir')
    mkdir(folder_info)
end

%% Show current position
device_id = open_stage(device_name);
[current_step_pos, current_ustep_pos] = current_position(device_id); % shows current position before move
fprintf('\nCurrent stage position: %d; ustep_pos: %d \n',current_step_pos, current_ustep_pos);
close_stage(device_id)

%% Step or micro-step?
% s_or_m = step_or_microstep();
s_or_m =0;

%% Detect background offset 
tic;
start_scan = 12;    % ps before peak [default value 12]
scan_for = 3;       % scan for 3ps [default value 3]
back_step_size = 2; % this stepping is only for measuring background offset.

start_step_scan_background = time_delay_to_step_pos(start_scan, peak_step);
[~, end_step_scan_background] = time_delay_to_step_pos(scan_for, start_step_scan_background);
data_mat_background = step_stage_and_measure(1, start_step_scan_background , end_step_scan_background, back_step_size);
background = mean(data_mat_background(:,2));

% This function block can be uncommented to allow for matlab to monitor
% humidity before starting individual sweeps
%% Step OR Microstep --- and measure THz waveform
step_start = time_delay_to_step_pos(pre_scan_length, peak_step); % start_step before peak
[~, step_end] = time_delay_to_step_pos(scan_length, peak_step);  % end_step after peak 

step_count = ceil(abs(step_end - step_start) / step_size); % adjust this 
array_size =  step_count + 1; 
array_step_pos = NaN(sweeps, array_size);
array_signal   = NaN(sweeps, array_size);

device_id = open_stage(device_name);

for j = 1:sweeps
    move_stage(device_id, step_start, 0);
    [current_step, ~] = current_position(device_id);
    
    array_step_pos(j,1) = current_step;
    % close_stage(device_id)
    pause(shift_delay);
    
    % Check if humidity is below allowable threshold
    if check_humidity == true
        humidity = humidity_checker(humidity_limit); 
    else
        humidity = current_humidity;
    end
    
    % measure
    data_daq = dq.startForeground;
    array_signal(j,1) = mean(data_daq);
    
    % open a figure handle and do not number it
    figure
    for i = 1: step_count
        move_to_step = current_step + step_size;
        move_stage(device_id, move_to_step, 0);
        
        [current_step, ~] = current_position(device_id);
        array_step_pos(j, i+1) = current_step;
        
        pause(shift_delay);
        
        % measure
        data_daq = dq.startForeground;
        array_signal(j,i+1) = mean(data_daq);
      
        plot(array_step_pos(j,:), array_signal(j, :),'.');
        xlim([step_start, step_end]);
        ylim([-10 10]);
    
    end
  xlabel('Steps')
end

close_stage(device_id);

time_ps = callibration_factor * array_step_pos(1, :);
raw_data_sweeps = [time_ps; array_signal]';
mean_array_signal = mean(array_signal,1) ; % this is a row array
data_matrix_uncorrected = [time_ps ; mean_array_signal]';

%if s_or_m == 1    
%    data_matrix_uncorrected =  microstep_stage_and_measure(sweeps, step_start, step_end, par.u_step_size);
%elseif s_or_m == 0
%    [data_matrix_uncorrected, raw_data_sweeps]= step_stage_and_measure(sweeps, step_start, step_end, step_size );
%end

time_taken_for_measurement_mins = toc / 60; % measurement time
fprintf('Scan time: %4.2f min\n\n',time_taken_for_measurement_mins);

%% close daq
release(dq);

%% Write raw data
time_delay = data_matrix_uncorrected(:,1);
signal_uncorrected = data_matrix_uncorrected(:,2);
no_of_data_points = length(signal_uncorrected);
time_now = strcat(dt_folder,'_',datestr(now, 'HH_MM')); % find current time after measurement

% print raw data
file_name_uncorrected = strcat(time_now,'_',experiment_name,'_raw.txt'); % simplified
file_info_uncorrected = fullfile(folder_info, file_name_uncorrected);
dlmwrite(file_info_uncorrected,data_matrix_uncorrected  ,'delimiter', '\t', 'precision', 10)

% print raw data sweeeps
file_name_uncorrected_sweeps = strcat(time_now,'-',experiment_name,'_raw_sweeps.txt'); %simplified
file_info_uncorrected_sweeps = fullfile(folder_info, file_name_uncorrected_sweeps);
dlmwrite(file_info_uncorrected_sweeps,raw_data_sweeps ,'delimiter', '\t', 'precision', 10)

raw_fig = figure;
plot(time_delay,signal_uncorrected, '.')
 title('THz Waveform - uncorrected')
    xlim([time_delay(1)-0.1, time_delay(end)+0.1]);
    ylim([-5 10]);
    ylabel('Au')
    xlabel('Picosecond')
    grid on;

%% Correct the offset in the signal
file_name_corrected = strcat(time_now,'.txt');
file_info_corrected = fullfile(folder_info, file_name_corrected);

signal_corrected = signal_uncorrected - background; % Removing background offset to remove 0 Hz contribution in FFT
data_matrix_corrected = [time_delay, signal_corrected]; 

% print corrected data
dlmwrite(file_info_corrected,data_matrix_corrected  ,'delimiter', '\t', 'precision', 10)
fig_file_name = strcat(time_now,'_',experiment_name,'_waveform');   %Akif simplified
fig_file_info = fullfile(folder_info,fig_file_name);

corrected_fig = figure;
plot(time_delay,signal_corrected, 'k')
 title('THz Waveform')
    xlim([time_delay(1)-0.1, time_delay(end)+0.1]);
    ylim([-10 10]);
    ylabel('Au')
    xlabel('ps')
    grid on;
    legend(experiment_name)
print(corrected_fig , fig_file_info,'-djpeg', '-r400')   

%% FFT
n = 4*(2^nextpow2(no_of_data_points)) ; % Edit the factor before perenthesis if necessary
[freq_amp, ~, fig_fft  ] = fun_fft(time_delay, signal_corrected , n, experiment_name);
 
fig_fft_file_name  = strcat(time_now,'_',experiment_name,'_fft');   % Akif simplified
fig_fft_file_info = fullfile(folder_info,fig_fft_file_name);
print(fig_fft , fig_fft_file_info,'-djpeg', '-r400') 

% print fft data
file_name_fft = strcat(time_now,'_',experiment_name,'_fft_data.txt'); % simplified
file_info_fft = fullfile(folder_info, file_name_fft);
dlmwrite(file_info_fft,freq_amp,'delimiter', '\t', 'precision', 10)

%% print parameters file that has experiment info
print_parameters(time_now,...
    folder_info,...
    experiment_name,...
    laser_amp_percentage,...
    laser_power,...
    laser_steps,...
    laser_rep_rate,...
    ref_freq,...
    time_constant,...
    roll_off,...
    sensitivity,...
    sweeps,...
    no_of_data_points,...
    background,...
    current_humidity,...
    humidity,...
    time_taken_for_measurement_mins,...
    comments )