function [step_pos_after_move,  ustep_pos_after_move] = move_stage( device_id, move_to_step, move_to_ustep)
%   stop_time is in miliseconds
    stop_time = 5;
result_move = calllib('libximc','command_move', device_id, move_to_step, move_to_ustep);
    if result_move ~= 0
       disp(['Failed to move with error: ' , num2str(result_move)]);
    end
result_stop =calllib('libximc','command_wait_for_stop', device_id, stop_time); % adjust this 100 values to something else use tic-toc to figure time out
if result_stop ~= 0
    disp(['Failed to stop movement with error: ', num2str(result_stop)]);
end    
    
status = ximc_get_status(device_id);
step_pos_after_move     =   status.CurPosition;
ustep_pos_after_move    =  status.uCurPosition;



%fprintf('after moving: step_pos: %d, \t ustep_pos: %d \n', step_pos_after_move,  ustep_pos_after_move);
end

