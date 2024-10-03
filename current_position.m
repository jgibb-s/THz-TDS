function [current_step_pos, current_ustep_pos] = current_position(device_id)


status = ximc_get_status(device_id);
current_step_pos = status.CurPosition;
current_ustep_pos = status.uCurPosition;

%fprintf('Current:  step_pos: %d, \t ustep_pos: %d \n',current_step_pos, current_ustep_pos);

end