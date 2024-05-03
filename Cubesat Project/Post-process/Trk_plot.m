function Trk_plot(trk,samplingFreq)
    % Aim: Creates an animated tracking plot
    % INPUT  --> trk: structure that contains the data of tracking
    %           samplingFreq: sampling frequency
    % OUTPUT --> figure

    trk.PRN_start_time_s = trk.PRN_start_sample_count/samplingFreq;
    nImages = length(trk.PRN_start_sample_count);

    fig = figure;
    set(fig, 'Position', get(0, 'Screensize'));
    sgtitle('Animated Tracking Data');


    % Discrete Time Scatter plot
    subplot(3,3,1)
    scatter_allpoints = plot(NaN, NaN, '.', 'MarkerSize', 5, 'Color', [0 0.4470 0.7410]);
    hold on
    scatter_newpoints = plot(NaN, NaN, '.', 'MarkerSize', 5, 'Color', [0.6350 0.0780 0.1840]);
    hold off
    title('$\textbf{Discrete Time Scatter plot}$','FontSize',10)
    xlabel('I Prompt'); xlim([-2e4 2e4]);
    ylabel('Q Prompt'); ylim([-2e4 2e4]);
    grid on


    % Bits of the navigation message
    subplot(3,3,[2 3])
    % curve1_allpoints = plot(NaN, NaN, 'Linewidth',1,'Color',[0 0.4470 0.7410]);
    hold on
    % curve1_newpoints = plot(NaN, NaN, 'Linewidth',1,'Color',[0 0.4470 0.7410]);
    hold off
    curve1 = animatedline('Linewidth',1,'Color',[0 0.4470 0.7410]);
    title('$\textbf{Bits of the navigation message}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    xlim([trk.PRN_start_time_s(1) trk.PRN_start_time_s(end)]);
    
    % Raw PLL discriminator
    subplot(3,3,4)
    curve2 = animatedline('Linewidth',1,'Color',[0.8500 0.3250 0.0980]);
    title('$\textbf{Raw PLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    xlim([trk.PRN_start_time_s(1) trk.PRN_start_time_s(end)]);

    % Raw PLL discriminator
    subplot(3,3,4)
    curve3 = animatedline('LineWidth',1,'Color',[0.8500 0.3250 0.0980]);
    title('$\textbf{Raw PLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    xlim([trk.PRN_start_time_s(1) trk.PRN_start_time_s(end)]);
    
    % Correlation results
    subplot(3,3,[5 6])
    hold on
    curve4 = animatedline('LineWidth',1,'Marker','*','Color',[0 0.4470 0.7410]);
    curve5 = animatedline('LineWidth',1,'Marker','*','Color',[0.8500 0.3250 0.0980]);
    curve6 = animatedline('LineWidth',1,'Marker','*','Color',[0.9290 0.6940 0.1250]);
    curve7 = animatedline('LineWidth',1,'Marker','*','Color',[0.4940 0.1840 0.5560]);
    curve8 = animatedline('LineWidth',1,'Marker','*','Color',[0.4660 0.6740 0.1880]);
    title('$\textbf{Correlation results}$','FontSize',10)
    xlabel('RX Time [s]')
    legend('$\sqrt(I_{VE}^2 + Q_{VE}^2)$','$\sqrt(I_E^2 + Q_E^2)$', ...
         '$\sqrt(I_P^2 + Q_P^2)$','$\sqrt(I_L^2 + Q_L^2)$',...
         '$\sqrt(I_{VL}^2 + Q_{VL}^2)$')
    grid on
    xlim([trk.PRN_start_time_s(1) trk.PRN_start_time_s(end)]);

    % Filtered PLL discriminator
    subplot(3,3,7)
    curve9 = animatedline('LineWidth',1,'Color',[0.3010 0.7450 0.9330]);
    title('$\textbf{Filtered PLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    xlim([trk.PRN_start_time_s(1) trk.PRN_start_time_s(end)]);
    
    % Raw DLL discriminator
    subplot(3,3,8)
    curve10 = animatedline('LineWidth',1,'Color',[0.8500 0.3250 0.0980]);
    title('$\textbf{Raw DLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    xlim([trk.PRN_start_time_s(1) trk.PRN_start_time_s(end)]);

    % Filtered DLL discriminator
    subplot(3,3,9)
    curve11 = animatedline('LineWidth',1,'Color',[0.3010 0.7450 0.9330]);
    title('$\textbf{Filtered DLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    xlim([trk.PRN_start_time_s(1) trk.PRN_start_time_s(end)]);

    % Animate
    for i = 1:nImages
        set(scatter_newpoints, 'XData', trk.Prompt_I(i), 'YData', trk.Prompt_Q(i));
        % set(curve1_newpoints, 'XData', trk.PRN_start_time_s(i), 'YData', trk.carr_error_hz(i));

        indices2display = 1:i-1 ;
        set(scatter_allpoints , 'XData',trk.Prompt_I(indices2display),'YData',trk.Prompt_Q(indices2display));
        % set(curve1_allpoints , 'XData',trk.PRN_start_time_s(indices2display),'YData',trk.carr_error_hz(indices2display));

        addpoints(curve1, trk.PRN_start_time_s(i), trk.Prompt_I(i));
        addpoints(curve2, trk.PRN_start_time_s(i), trk.carr_error_hz(i));
        addpoints(curve3, trk.PRN_start_time_s(i),trk.carr_error_hz(i));
        addpoints(curve4, trk.PRN_start_time_s(i),trk.abs_VE(i));
        addpoints(curve5, trk.PRN_start_time_s(i),trk.abs_E(i));
        addpoints(curve6, trk.PRN_start_time_s(i),trk.abs_P(i));
        addpoints(curve7, trk.PRN_start_time_s(i),trk.abs_L(i));
        addpoints(curve8, trk.PRN_start_time_s(i),trk.abs_VL(i));
        addpoints(curve9, trk.PRN_start_time_s(i),trk.carr_error_filt_hz(i));
        addpoints(curve10, trk.PRN_start_time_s(i),trk.code_error_chips(i));
        addpoints(curve11, trk.PRN_start_time_s(i),trk.code_error_filt_chips(i));
        drawnow limitrate

        pause(0.01)
    end
end
