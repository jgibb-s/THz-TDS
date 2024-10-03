function [ data_matrix, raw_data_sweeps ] = step_stage_and_measure( total_sweeps, start_step, end_step, step_size )
% Only stepping and no microstepping here
% Funciton outputs a matrix with time and signal in 
% 1st and 2nd col respectively


global shift_delay callibration_factor device_name dq

step_count = ceil(abs(end_step - start_step) / step_size); % adjust this 
array_size =  step_count + 1; 
array_step_pos = NaN(total_sweeps, array_size);
array_signal   = NaN(total_sweeps, array_size);

device_id = open_stage(device_name);
for j = 1: total_sweeps
    move_stage( device_id, start_step , 0);
    [current_step, ~] = current_position(device_id);
    
    array_step_pos(j,1) = current_step;
   % close_stage(device_id)
    pause(shift_delay);
    
    % measure
    data_daq = dq.startForeground;
    array_signal(j,1) = mean(data_daq);
    
     % open a figure handle and do not number it
    figure
    for i = 1: step_count
    %    device_id = open_stage(device_name);
        
        move_to_step = current_step + step_size;
        move_stage( device_id, move_to_step , 0);
        
        [current_step, ~] = current_position(device_id);
        array_step_pos(j, i+1) = current_step;
        
      %  close_stage(device_id)
        
        pause(shift_delay);
        
        % measure
        data_daq = dq.startForeground;
        array_signal(j,i+1) = mean(data_daq);
      
        
        
    plot(array_step_pos(j,:), array_signal(j, :),'.');
    %line(final_array_position,final_array_signal);
    % put the line in if necessary

     xlim([start_step, end_step]);
     ylim([-10 10]);
    
    end
  xlabel('Steps')
end

close_stage(device_id);

time_ps = callibration_factor * array_step_pos(1, :);
raw_data_sweeps = [time_ps; array_signal]';
mean_array_signal = mean(array_signal,1) ; % this is a row array
data_matrix = [time_ps ; mean_array_signal]';














end

