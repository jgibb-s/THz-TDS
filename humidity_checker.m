function humidity = humidity_checker(humidity_limit)

file_dir = 'F:\purgebox_humidity';
file_name = 'purge_box_humidity.txt';
file_info = fullfile(file_dir, file_name); 

fileID = fopen(file_info,'r');
current_humidity = fscanf(fileID,'%f')
fclose(fileID);   

while current_humidity > humidity_limit
    fprintf("Humidity to high, purging now...")
    pause(10);
    fileID = fopen(file_info,'r');
    current_humidity = fscanf(fileID,'%f')
    fclose(fileID); 
end

humidity = current_humidity
fprintf('Purged, starting scan');


end

