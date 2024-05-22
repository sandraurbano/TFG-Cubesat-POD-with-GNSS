function Tracking_plot(trk,channels,samplingFreq,results_path)
% Aim: Creates a tracking plot
%
% INPUT  --> trk: structure that contains tracking data from GNSS-sdr
%            channels: number of channels using
%            samplingFreq: sampling frequency used for the reception of data
%            results_path: string with the path of the results folder
% OUTPUT --> figure: tracking plot


for N=1:channels

    trk(N).PRN_start_time_s = trk(N).PRN_start_sample_count/samplingFreq;
    
    figure
    set(gcf,'WindowState','maximized');
    sgtitle(sprintf('Tracking data channel %i',N));
     
    
    % Discrete Time Scatter plot
    subplot(3,3,1)
    scatter(trk(N).Prompt_I,trk(N).Prompt_Q,10,'filled');
    title('$\textbf{Discrete Time Scatter plot}$','FontSize',10)
    xlabel('I Prompt')
    ylabel('Q Prompt')
    grid on
    
    % Bits of the navigation message
    subplot(3,3,[2 3])
    plot(trk(N).PRN_start_time_s,trk(N).Prompt_I);
    title('$\textbf{Bits of the navigation message}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    
    % Raw PLL discriminator
    subplot(3,3,4)
    plot(trk(N).PRN_start_time_s,trk(N).carr_error_hz,'Color',[0.8500 0.3250 0.0980]);
    title('$\textbf{Raw PLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    
    % Correlation results
    subplot(3,3,[5 6])
    hold on
    plot(trk(N).PRN_start_time_s,trk(N).abs_VE,'-*');
    plot(trk(N).PRN_start_time_s,trk(N).abs_E,'-*');
    plot(trk(N).PRN_start_time_s,trk(N).abs_P,'-*');
    plot(trk(N).PRN_start_time_s,trk(N).abs_L,'-*');
    plot(trk(N).PRN_start_time_s,trk(N).abs_VL,'-*');
    title('$\textbf{Correlation results}$','FontSize',10)
    xlabel('RX Time [s]')
    legend('$\sqrt(I_{VE}^2 + Q_{VE}^2)$','$\sqrt(I_E^2 + Q_E^2)$', ...
         '$\sqrt(I_P^2 + Q_P^2)$','$\sqrt(I_L^2 + Q_L^2)$',...
         '$\sqrt(I_{VL}^2 + Q_{VL}^2)$')
    grid on
    
    % Filtered PLL discriminator
    subplot(3,3,7)
    plot(trk(N).PRN_start_time_s,trk(N).carr_error_filt_hz,'Color',[0.3010 0.7450 0.9330]);
    title('$\textbf{Filtered PLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    
    
    % Raw DLL discriminator
    subplot(3,3,8)
    plot(trk(N).PRN_start_time_s,trk(N).code_error_chips,'Color',[0.8500 0.3250 0.0980]);
    title('$\textbf{Raw DLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    
    % Filtered DLL discriminator
    subplot(3,3,9)
    plot(trk(N).PRN_start_time_s,trk(N).code_error_filt_chips,'Color',[0.3010 0.7450 0.9330]);
    title('$\textbf{Filtered DLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
 
    filename = fullfile(results_path, sprintf('trk_ch%i.png',N));
    saveas(gcf, filename);


end 



end

