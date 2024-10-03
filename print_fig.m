%print_fig
close all

f_corrected = figure(1)
plot(freq_amp_corrected(:,1), freq_amp_corrected(:,2));
xlim([0 5])
ylim([0 0.04])
title('corrected signal')
xlabel('THz')
ylabel('A.U.')
grid on
 fig_file_corrected = 'corrected_spectrum';
 
 
 
 
 f_uncorrected = figure(2);
plot(freq_amp_uncorrected(:,1), freq_amp_uncorrected(:,2), 'r');
xlim([0 5])
ylim([0 0.04])
title('uncorrected signal')
xlabel('THz')
ylabel('A.U.') 
grid on
fig_file_uncorrected = 'uncorrected_spectrum'; 
 
 
 
 
 
 
 
 
 
 
 print(f_corrected, fig_file_corrected, '-djpeg', '-r400')
 print(f_uncorrected, fig_file_uncorrected, '-djpeg', '-r400')