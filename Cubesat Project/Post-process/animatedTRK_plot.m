function animatedTRK_plot(trk,samplingFreq)
    % Aim: Creates an animated tracking plot
    % INPUT  --> trk: structure that contains the data of tracking
    %           samplingFreq: sampling frequency
    % OUTPUT --> figure

    trk.PRN_start_time_s = trk.PRN_start_sample_count/samplingFreq;
    iterations = length(trk.PRN_start_sample_count);
    M(iterations) = struct('cdata',[],'colormap',[]); 

    fig = figure;
    set(fig, 'defaultAxesFontSize', 10);  
    set(fig, 'WindowState', 'maximized');
    axis tight manual
    ax = gca;
    ax.NextPlot = 'replaceChildren';

    % SUBPLOT1: Discrete Time Scatter plot
    subplot(3,3,1)
    hold on
    subplot1_newpts = plot(NaN, NaN, '.', 'MarkerSize', 10, 'Color', [0.6350 0.0780 0.1840]);
    subplot1_allpts = plot(NaN, NaN, '.', 'MarkerSize', 10, 'Color', [0 0.4470 0.7410 1]);
    hold off
    title('$\textbf{Discrete Time Scatter plot}$','FontSize',10)
    xlabel('I Prompt'); xlim([-2e4 2e4]);
    ylabel('Q Prompt'); ylim([-2e4 2e4]);
    grid on

    % SUBPLOT2: Bits of the navigation message
    subplot(3,3,[2 3])
    hold on
    subplot2_allpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0 0.4470 0.7410]);
    subplot2_newpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0 0.4470 0.7410]);
    hold off
    title('$\textbf{Bits of the navigation message}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    
    % SUBPLOT3: Raw PLL discriminator
    subplot(3,3,4)
    hold on
    subplot3_allpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0.8500 0.3250 0.0980]);
    subplot3_newpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0.8500 0.3250 0.0980]);
    hold off
    title('$\textbf{Raw PLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    
    % SUBPLOT4: Correlation results
    subplot(3,3,[5 6])
    hold on
    subplot4_data1_allpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0 0.4470 0.7410]);
    subplot4_data1_newpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0 0.4470 0.7410]);
    subplot4_data2_allpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0.8500 0.3250 0.0980]);
    subplot4_data2_newpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0.8500 0.3250 0.0980]);
    subplot4_data3_allpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0.9290 0.6940 0.1250]);
    subplot4_data3_newpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0.9290 0.6940 0.1250]);
    subplot4_data4_allpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0.4940 0.1840 0.5560]);
    subplot4_data4_newpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0.4940 0.1840 0.5560]);
    subplot4_data5_allpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0.4660 0.6740 0.1880]);
    subplot4_data5_newpts = plot(NaN, NaN, 'LineWidth',1,'Marker','*','Color',[0.4660 0.6740 0.1880]);
    hold off
    title('$\textbf{Correlation results}$','FontSize',10)
    xlabel('RX Time [s]')
    legend('$\sqrt(I_{VE}^2 + Q_{VE}^2)$','$\sqrt(I_E^2 + Q_E^2)$', ...
         '$\sqrt(I_P^2 + Q_P^2)$','$\sqrt(I_L^2 + Q_L^2)$',...
         '$\sqrt(I_{VL}^2 + Q_{VL}^2)$','Location','southeast')
    grid on

    % SUBPLOT5: Filtered PLL discriminator
    subplot(3,3,7)
    hold on
    subplot5_allpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0.3010 0.7450 0.9330]);
    subplot5_newpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0.3010 0.7450 0.9330]);
    hold off
    title('$\textbf{Filtered PLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on
    
    % SUBPLOT6: Raw DLL discriminator
    subplot(3,3,8)
    hold on
    subplot6_allpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0.8500 0.3250 0.0980]);
    subplot6_newpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0.8500 0.3250 0.0980]);
    hold off
    title('$\textbf{Raw DLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on

    % SUBPLOT7: Filtered DLL discriminator
    subplot(3,3,9)
    hold on
    subplot7_allpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0.3010 0.7450 0.9330]);
    subplot7_newpts = plot(NaN, NaN, 'Linewidth',1,'Color',[0.3010 0.7450 0.9330]);
    hold off
    title('$\textbf{Filtered DLL discriminator}$','FontSize',10)
    xlabel('RX Time [s]')
    grid on

    %fig.Visible = 'off';

    % Animate
    tic
    for i = 1:10:iterations
        tic
        main_title = sprintf('Tracking plot: SAT %d, Elevation %d, Doppler %d', trk.PRN(i),i,i);
        
        set(subplot1_newpts, 'XData', trk.Prompt_I(i), 'YData', trk.Prompt_Q(i));
        set(subplot2_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.Prompt_I(i));
        set(subplot3_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.carr_error_hz(i));
        set(subplot4_data1_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.abs_VE(i));
        set(subplot4_data2_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.abs_E(i));
        set(subplot4_data3_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.abs_P(i));
        set(subplot4_data4_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.abs_L(i));
        set(subplot4_data5_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.abs_VL(i));
        set(subplot5_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.carr_error_filt_hz(i));
        set(subplot6_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.code_error_chips(i));
        set(subplot7_newpts, 'XData', trk.PRN_start_time_s(i), 'YData', trk.code_error_filt_chips(i));

        j = 1:i-1 ;
        set(subplot1_allpts , 'XData',trk.Prompt_I(j),'YData',trk.Prompt_Q(j));
        set(subplot2_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.Prompt_I(j));
        set(subplot3_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.carr_error_hz(j));
        set(subplot4_data1_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.abs_VE(j));
        set(subplot4_data2_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.abs_E(j));
        set(subplot4_data3_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.abs_P(j));
        set(subplot4_data4_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.abs_L(j));
        set(subplot4_data5_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.abs_VL(j));
        set(subplot5_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.carr_error_filt_hz(j));
        set(subplot6_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.code_error_chips(j));
        set(subplot7_allpts, 'XData', trk.PRN_start_time_s(j), 'YData', trk.code_error_filt_chips(j));
    
        sgtitle(main_title);
        drawnow limitrate
        %M(i) = getframe(gcf);
        toc
    end
    toc
    fig.Visible = 'on';
    movie(M);
end
