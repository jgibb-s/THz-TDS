function [step_before, step_after] = time_delay_to_step_pos(time_delay,ref_step_pos)

%   time delay is in pico-sec

c = 299792458; % m/s
step_delay = 10* 1e-6; % single step --> 10micron delay
total_steps = (c * time_delay *1e-12) / step_delay ;

step_before = floor( ref_step_pos - total_steps);

step_after  = ceil(ref_step_pos + total_steps);


end

 