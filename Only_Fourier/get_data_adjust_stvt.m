function data = get_data_adjust_stvt(data_file, stvt)

n = length(stvt);
%l_vals = zeros(n,1);

data = cell(n,1);
for k = 1: n
    data{k} = get_data(data_file{k});
    data{k}(:,2) = (stvt(k)/10 ) * data{k}(:,2);
end

% earliest_t =  l_vals(    find(min(l_vals))   );


% 
% for k = 1: n
%  data{k}(:,1) = data{k}(:,1) - earliest_t  ;
%  data{k}(:,2) = (stvt(k)/10 ) * data{k}(:,2);
%  
% end

end