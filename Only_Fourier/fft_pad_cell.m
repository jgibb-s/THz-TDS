function [spec, E_z, res]  = fft_pad_cell(data_cell, pwr)

if nargin < 2
    pwr = 0;
end

n = length(data_cell);

spec = cell(n,1);
E_z  = spec;
res     = zeros(n,1);
for k = 1 : n
    [spec{k}, E_z{k},  res(k)]  = fft_pad(data_cell{k}, pwr);
end





end