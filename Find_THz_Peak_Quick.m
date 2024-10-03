clearvars -except ard shield sm_sample
close all

%%%%%%%%%%%%%%%%%%% MUST PROVIDE THE FOLLOWING VARIABLE VALUES %%%%%%%%%%%%%%%%%%%
step_size = 1;     % 
start_step = 3535; %Free space peak around 3550, Si ATR prism 2170-2180
end_step = 3585; 

%% GLOBAL variables
global shift_delay device_name dq callibration_factor
shift_delay = 150 / 1000; % 50 ms for lock-in 10ms time-const. 5 times the time-constant of lock-in
callibration_factor = 1;  % since we want signal VS step (not time-delay) graph

%% Start DAQ
daq.getDevices;
daq_rate = 250000;  % change it if needed; 250 000 ---> default
daq_sample = 1000;  % change it if needed;  5000 ---> default
daq_channel = 'ai2';
duration_daq = (daq_sample/daq_rate);  

%set daq parameters
dq = daq.createSession('ni');
addAnalogInputChannel(dq,'Dev1', daq_channel, 'Voltage');
dq.Rate = daq_rate;
dq.DurationInSeconds = duration_daq;  
% this command will output an coloumn array of data --> data_daq = dq.startForeground;

%% Start/detect Stage
device_name = detect_stage();

%% Sweep to find peak
%[data_mat] = microstep_stage_and_measure(total_sweeps , start_step, end_step, u_step_size);
[data_mat] = step_stage_and_measure(1, start_step, end_step, step_size);

%% find the max signal info
ind = find(abs(data_mat(:,2)) == max(abs(data_mat(:,2))));
fprintf('\nThe peak is at: %d steps \nSignal strength: %.2f \n', data_mat(ind,1), data_mat(ind,2));  

%% Move to peak position
device_id = open_stage(device_name);
move_stage(device_id, data_mat(ind,1), 0);
fprintf('Stage has moved to the peak\n\n');
close_stage(device_id); 