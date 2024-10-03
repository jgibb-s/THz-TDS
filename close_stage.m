function close_stage(device_id)

device_id_ptr = libpointer('int32Ptr', device_id);
calllib('libximc','close_device', device_id_ptr);
%disp('stage closed');

end