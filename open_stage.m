function [ device_id ] = open_stage(device_name)
%   Device has to be detected first
%   device_name is required

device_id = calllib('libximc','open_device', device_name);

while  device_id ~= 1
device_id = calllib('libximc','open_device', device_name);
end

end

