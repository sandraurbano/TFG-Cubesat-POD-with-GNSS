function visibillity_plots(cubesat,GnssSDR,spirent,channels, Type,results_path)
% Aim: Creates visibillity plots from Spirent and GNSS-SDR data
%
% INPUT  --> cubesat: struct that constains the simulation data and simulink output 
%            GnssSDR: struct that contains position, velocity an time data from GNSS-sdr
%            spirent: struct that contains satellite data from Spirent
%            Type: string with the constellation type (e.g. 'GPS') 
%            results_path: string with the path of the results folder
% OUTPUT --> figures: satellite visibillity, number of satellites in view
%            and skyplot


% Simulation time of the orbit propagator ~ Period of the orbit
startTime = 0;
endTime = seconds(cubesat.Duration);

% Filter data to a specific constellation 
% Find the rows where Sat_Type = 'GPS'
indices_gps = strcmp(spirent.satData.Sat_type, Type);
spirent.satData = structfun(@(x) x(indices_gps, :), spirent.satData, 'UniformOutput', false);

%%%%%%%%%%%%%%%%%%%%%%%% SPIRENT %%%%%%%%%%%%%%%%%%%%%%%%

% SPIRENT SATELLITE VISIBILITY 

% Define time vector in datetime format
dt = seconds(spirent.satData.Time_ms*10^-3);
t = cubesat.StartDate + dt;


figure
set(gcf,'WindowState','maximized');
scatter(t, spirent.satData.Sat_PRN, 'b.'); 
title('Spirent - Satellite visbility chart');
ylabel('Satellite PRN Index'); 
grid on; 
idPRN = unique(spirent.satData.Sat_PRN);
ylim([min(idPRN)-1 max(idPRN)+1])
yticks(idPRN)
filename = fullfile(results_path, 'spirent_visibility.png');
saveas(gcf, filename);


% SPIRENT NUMBER OF SATELLITES IN VIEW

% Get unique times in milliseconds and convert to datetime 
unique_t_ms = unique(spirent.satData.Time_ms);
unique_t = cubesat.StartDate + seconds(unique_t_ms * 1e-3);

% Use histcounts to count occurrences of each unique time
edges = [unique_t_ms; unique_t_ms(end)+1];
numvis = histcounts(spirent.satData.Time_ms, edges);

figure
%set(gcf,'WindowState','maximized');
plot(unique_t, numvis, 'b-','LineWidth',1);
ylabel('Number of satellites');
title('Spirent - Number of GPS satellites visible');
grid on;
ylim([0 max(numvis)+1]);
filename = fullfile(results_path, 'spirent_num_visible_satellites.png');
saveas(gcf, filename);


% SPIRENT SKYPLOT
[allAz, allEl, satIDs] = skyplot_data(spirent,Type);

figure
%set(gcf,'WindowState','maximized');
skyplot(allAz, allEl, string(satIDs));
title('Spirent - Skyplot');
filename = fullfile(results_path, 'spirent_skyplot.png');
saveas(gcf, filename);


%%%%%%%%%%%%%%%%%%%%%%%% GNSS-SDR %%%%%%%%%%%%%%%%%%%%%%%%
% GNSS SATELLITE VISIBILITY 

gpsWeek = GnssSDR.PVT.week(1);

figure
set(gcf,'WindowState','maximized');
hold on
for i=1:size(GnssSDR.obs.PRN,1)
    [~,cols,PRN] = find(GnssSDR.obs.PRN(i,:));
    rx_time = GnssSDR.obs.RX_time(i,cols);
    utcDatetime = gps2utc(gpsWeek, rx_time);
    scatter(utcDatetime, PRN,50,'.');
end 
title('GNSS-SDR - Satellite visbility chart');
ylabel('Satellite PRN Index'); 
grid on;
legend_labels = arrayfun(@(x) ['channel ', num2str(x)], 1:channels, 'UniformOutput', false);
legend(legend_labels,'Location','eastoutside')
idPRN = unique(GnssSDR.obs.PRN);
yticks(idPRN)
filename = fullfile(results_path, 'gnsssdr_visibility.png');
saveas(gcf, filename);

end