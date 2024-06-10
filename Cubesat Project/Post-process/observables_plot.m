function observables_plot(spirent,gnssSDR,Type,cubesat,results_path)
% Aim: Create a dopplers plot that compares GNSS-SDR and Spirent data
%
% INPUT  --> spirent: struct that contains satellite data from Spirent
%            gnssSDR: struct that contains obervables data from GNSS-sdr
%            Type: string with the constellation type (e.g. 'GPS')  
%            cubesat: struct that constains the simulation data and simulink output 
%            results_path: string with the path of the results folder
% OUTPUT --> figure: dopplers plot

startTime = 0;
endTime = seconds(cubesat.Duration);

% Filter data to a specific constellation 
% Find the rows where Sat_Type = 'GPS'
indices_gps = strcmp(spirent.satData.Sat_type, Type);

% Identify the max number of GPS satellites
spirent.satData = structfun(@(x) x(indices_gps, :), spirent.satData, 'UniformOutput', false);

% Find the GPS satellites common to Spirent and GNSS-SDR
PRN_spirent = unique(spirent.satData.Sat_PRN);
PRN_gnssSDR = unique(gnssSDR.PRN);
PRN_common = intersect(PRN_gnssSDR, PRN_spirent);
maxSats = length(PRN_common);

%% PLOT the DOPPLER FOR EACH SATellite

num_rows = ceil(sqrt(maxSats));
num_cols = ceil(maxSats / num_rows);

figure
set(gcf,'WindowState','maximized');
sgtitle('Doppler frequency');

for i = 1:length(PRN_common)
    
    % Filter spirent data 
    PRNidx_spirent = find(spirent.satData.Sat_PRN == PRN_common(i));
    time_spirent = zeros(length(PRNidx_spirent),1);
    doppler_spirent = zeros(size(time_spirent));

    for j=1:length(PRNidx_spirent)
        doppler_spirent(j) = spirent.satData.Doppler_shiftGroupA(PRNidx_spirent(j));
    end 
    
    % Filter GNSS-SDR dat
    PRNidx_gnssSDR = gnssSDR.PRN == PRN_common(i);
    doppler_gnssSDR = gnssSDR.Carrier_Doppler_hz(PRNidx_gnssSDR);

    % Adjust both time vectors to the length of each data set
    t_spirent = linspace(startTime,endTime,length(doppler_spirent));
    t_gnssSDR = linspace(startTime,endTime,length(doppler_gnssSDR));

    subplot(num_rows, num_cols, i);
    hold on
    plot(t_gnssSDR,doppler_gnssSDR,'-');
    plot(t_spirent,doppler_spirent,'-');
    title(['$\textbf{Satellite PRN' num2str(PRN_common(i)) '}$']);
    xlabel('Time [s]'); 
    ylabel('Doppler [Hz]');
    ax = gca; 
    ax.YAxis.Exponent = 0;
    grid on

end
legend('Gnss-sdr','Spirent')
filename = fullfile(results_path, 'doppler.png');
saveas(gcf, filename);

end 