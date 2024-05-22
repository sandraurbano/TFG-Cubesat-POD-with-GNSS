function observables_plot(spirent,gnssSDR,Type,cubesat)
% Aim: Create a dopplers plot that compares GNSS-SDR and Spirent data
%
% INPUT  --> spirent: struct that contains satellite data from Spirent
%            gnssSDR: struct that contains obervables data from GNSS-sdr
%            Type: string with the constellation type (e.g. 'GPS')  
%            cubesat: struct that constains the simulation data and simulink output   
% OUTPUT --> figure: dopplers plot

startTime = 0;
endTime = seconds(cubesat.Duration);

% Filter data to a specific constellation 
% Find the rows where Sat_Type = 'GPS'
indices_gps = strcmp(spirent.satData.Sat_type, Type);

% Identify the max number of GPS satellites
spirent.satData = structfun(@(x) x(indices_gps, :), spirent.satData, 'UniformOutput', false);

PRN_spirent = unique(spirent.satData.Sat_PRN);
PRN_gnssSDR = unique(gnssSDR.PRN);
PRN_common = intersect(PRN_gnssSDR, PRN_spirent);

maxSats = length(PRN_common);

% PLOT DOPPLER FOR EACH SAT
num_rows = ceil(sqrt(maxSats));
num_cols = ceil(maxSats / num_rows);

figure
set(gcf, 'Position', get(0, 'Screensize'));
sgtitle('Doppler frequency Group A');

for i = 1:length(PRN_common)
    
    % FILTER SPIRENT DATA 
    PRNidx_spirent = find(spirent.satData.Sat_PRN == PRN_common(i));
    time_spirent = zeros(length(PRNidx_spirent),1);
    doppler_spirent = zeros(size(time_spirent));

    for j=1:length(PRNidx_spirent)
        %time_spirent(j) = spirent.satData.Time_ms(PRNidx_spirent(j));
        doppler_spirent(j) = spirent.satData.Doppler_shiftGroupA(PRNidx_spirent(j));
    end 
    

    % FILTER GNSS-SDR DATA 
    PRNidx_gnssSDR = gnssSDR.PRN == PRN_common(i);
    %time_gnssSDR = gnssSDR.TOW_at_current_symbol_s(PRNidx_gnssSDR);
    doppler_gnssSDR = gnssSDR.Carrier_Doppler_hz(PRNidx_gnssSDR);


    t_spirent = linspace(startTime,endTime,length(doppler_spirent));
    t_gnssSDR = linspace(startTime,endTime,length(doppler_gnssSDR));


    subplot(num_rows, num_cols, i);
    hold on
    plot(t_gnssSDR,doppler_gnssSDR,'-');
    plot(t_spirent,doppler_spirent,'-');
    title(['$\textbf{Doppler satellite PRN' num2str(PRN_common(i)) '}$']);
    xlabel('Time (s)'); 
    ylabel('Doppler (Hz)');
    ax = gca; % axes handle
    ax.YAxis.Exponent = 0;
    grid on



end



end 