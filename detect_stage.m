% detect stage and find its name
function device_name = detect_stage()

[~,maxArraySize]=computer;
is64bit = maxArraySize > 2^31;
if (ispc)
	if (is64bit)
			disp('Using 64-bit version')
			disp('NOTE! Copy ximc.h, libximc.dll, bindy.dll, xiwrapper.dll, wrappers/matlab/libximc_thunk_pcwin64.dll, wrappers/matlab/ximc.m to the current directory')
	else
			disp('Using 32-bit version')
			disp('NOTE! Copy ximc.h, libximc.dll, bindy.dll, xiwrapper.dll and wrappers/matlab/ximcm.h to the current directory')
	end
elseif ismac
	disp('NOTE! Copy libximc.framework to the current directory')
elseif isunix
	disp('Unsupported')
end

if not(libisloaded('libximc'))
    disp('Loading library')
		if ispc
			if (is64bit)
					[~,warnings] = loadlibrary('libximc.dll', @ximcm);
			else
					[notfound, warnings] = loadlibrary('libximc.dll', 'ximcm.h', 'addheader', 'ximc.h');
			end
		elseif ismac
			[notfound, warnings] = loadlibrary('libximc.framework/libximc', 'ximcm.h', 'mfilename', 'ximcm.m', 'includepath', 'libximc.framework/Versions/Current/Headers', 'addheader', 'ximc.h')
		elseif isunix
			[notfound, warnings] = loadlibrary('libximc.so', 'ximcm.h', 'addheader', 'ximc.h');
		end
end

device_names = ximc_enumerate_devices_wrap(0);
devices_count = size(device_names,2);
if devices_count == 0
    disp('No devices found')
    return
end
for i=1:devices_count
    disp(['Found device: ', device_names{1,i}]);
    disp(i)
end
device_name = device_names{1,1};
disp(['Using device name ', device_name]);

end