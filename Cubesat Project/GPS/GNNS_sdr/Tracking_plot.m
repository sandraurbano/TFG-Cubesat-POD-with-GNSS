function Tracking_plot(trk,samplingFreq)
% Aim: Creates a tracking plot
% INPUT  --> trk: structure that contains the data of tracking for and
%            specific channel
% OUTPUT --> figure

trk.PRN_start_time_s = trk.PRN_start_sample_count/samplingFreq;


figure
set(gcf, 'Position', get(0, 'Screensize'));

% Discrete Time Scatter plot
subplot(3,3,1)
scatter(trk.Prompt_I,trk.Prompt_Q,10,'filled');
title('$\textbf{Discrete Time Scatter plot}$')
xlabel('I Prompt')
ylabel('Q Prompt')
grid on

% Bits of the navigation message
subplot(3,3,[2 3])
plot(trk.PRN_start_time_s,trk.Prompt_I);
title('$\textbf{Bits of the navigation message}$')
xlabel('RX Time [s]')
grid on

% Raw PLL discriminator
subplot(3,3,4)
plot(trk.PRN_start_time_s,trk.carr_error_hz,'Color',[0.8500 0.3250 0.0980]);
title('$\textbf{Raw PLL discriminator}$')
xlabel('RX Time [s]')
grid on

% Correlation results
subplot(3,3,[5 6])
hold on
plot(trk.PRN_start_time_s,trk.abs_VE,'-*');
plot(trk.PRN_start_time_s,trk.abs_E,'-*');
plot(trk.PRN_start_time_s,trk.abs_P,'-*');
plot(trk.PRN_start_time_s,trk.abs_L,'-*');
plot(trk.PRN_start_time_s,trk.abs_VL,'-*');
title('$\textbf{Correlation results}$')
xlabel('RX Time [s]')
legend('$\sqrt(I_{VE}^2 + Q_{VE}^2)$','$\sqrt(I_E^2 + Q_E^2)$', ...
     '$\sqrt(I_P^2 + Q_P^2)$','$\sqrt(I_L^2 + Q_L^2)$',...
     '$\sqrt(I_{VL}^2 + Q_{VL}^2)$')
grid on

% Filtered PLL discriminator
subplot(3,3,7)
plot(trk.PRN_start_time_s,trk.carr_error_filt_hz,'Color',[0.3010 0.7450 0.9330]);
title('$\textbf{Filtered PLL discriminator}$')
xlabel('RX Time [s]')
grid on


% Raw DLL discriminator
subplot(3,3,8)
plot(trk.PRN_start_time_s,trk.code_error_chips,'Color',[0.8500 0.3250 0.0980]);
title('$\textbf{Raw DLL discriminator}$')
xlabel('RX Time [s]')
grid on

% Filtered DLL discriminator
subplot(3,3,9)
plot(trk.PRN_start_time_s,trk.code_error_filt_chips,'Color',[0.3010 0.7450 0.9330]);
title('$\textbf{Filtered DLL discriminator}$')
xlabel('RX Time [s]')
grid on


end

