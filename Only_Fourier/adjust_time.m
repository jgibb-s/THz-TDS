function data_out = adjust_time(data_cell)

n = length(data_cell);
l_vals = zeros(n,1);
data_out = cell(size(data_cell));


for k = 1: n
        data_out = data_cell;
        l_vals(k) = min(data_cell{k}(:,1));
end

earliest_t =  l_vals(    find(min(l_vals))   );



for k = 1: n
 data_out{k}(:,1) = data_out{k}(:,1) - earliest_t  ;
end

end