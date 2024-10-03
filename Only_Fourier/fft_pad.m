function  [spec,E_z, freq_res] = fft_pad( time_signal_mat, pwr)

% This function will calculate FFT of the supplied matrix: time_signal_mat.
% 1st col of time_signal_mat is time
% 2nd col of time_signal_mat is signal

% 2nd argument pwr is explained as follows:
% pwr can be : {0 , 1, 2, 3, ...}. Default:0
% if pwr is 0: 2^0 times padding is done to nextpow2
% if pwr is 0: 2^1 times padding is done to nextpow2

if nargin < 2
   pwr = 0;
end

%% Extract to col's to arrays

time = time_signal_mat(:,1);
signal = time_signal_mat(:,2);
pwr = floor(pwr); %

%% sampling parameters




N           =  length(time);
Nfft        = 2^pwr * 2 ^ (nextpow2(N)) ;
del_t       = mean(diff(time)); % time resolution
fs          = (1 / del_t) ;            % # of samples/ pico-sec (sampling freq)



%% frequency array 
freq_res = round(fs/Nfft, 5);
Nyq = fs/2;
nu = ((0:(Nfft/2)) * freq_res)';     


%% Perform FFT and Normalize
Y   = fft(signal, Nfft);
Y   = Y/Nfft;           % here you have to know what N is
Y   = Y(1: Nfft/2 +1);  % for real valued even samples this is sufficient as
Y(2: end-1) = 2* Y(2: end-1) ;                       % a single sided spectrum

                                    % power spectrum (2 sided)
                                         % multiplied by 2 for correcting power in Parseval's theorem
                                        % but DC and Nyquist freqs do not
                                        % get multiplied by 2
%% amplitude spectrum
amp = abs(Y);                           
                                       

%% phase spectrum                            
tol = 1e-9;
Y(abs(Y)< tol ) = 0;

phase = angle(Y);
phase = unwrap(phase) - 2*pi*nu* time(1);                  % unwrapped phase in radians


%% output matrix of 3 cols
spec = [nu , amp, phase];
E_z  = [nu, amp.* exp(1i*phase)];

end
