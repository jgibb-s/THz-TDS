function [freq_amp, Fs, fig_fft  ] = fun_fft(time, signal , n, leg)
% This function will calculate FFT of the supplied arrays time and signal.
% We will do custom zero padding with 'n'

% The output will be an 'N X 2' matrix with 1st col being freq and 2nd
% amplitude

%% FFT Calculations
% # of samples/ pico-sec (sampling freq)
Fs = 1 / (time(2) - time(1) );

% frequency array 
freq = ((0:(n/2)) * (Fs/n))';     

% spectrum amplitudes
Y = fft(signal,n);
P = abs(Y/n);               % power spectrum (2 sided)
amp = P(1: n/2 +1);         % single sided


%%

freq_amp = [freq , amp];
fig_fft = figure;
plot(freq, amp, 'DisplayName', 'FFT');
xlabel('Frequency (THz)')
ylabel('A.U.')
xlim([0.1 7])
legend(leg);
title('Amplitude Spectrum')
grid on

end

