function visibillity_plots(cubesat,GnssSDR,spirent,Type)
% Aim: Creates visibillity plots from Spirent and GNSS-SDR data
%
% INPUT  --> cubesat: struct that constains the simulation data and simulink output 
%            GnssSDR: struct that contains position, velocity an time data from GNSS-sdr
%            spirent: struct that contains satellite data from Spirent
%            Type: string with the constellation type (e.g. 'GPS')            
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

figure
scatter(spirent.satData.Time_ms, spirent.satData.Sat_PRN, 'b.'); 
title('Spirent - Satellite visibility');
xlabel('Time (s)'); 
ylabel('Sat PRN'); 
grid on;

% Plot tick labels 
idPRN = unique(spirent.satData.Sat_PRN);
numTicks = 10; 
tickPositions = linspace(startTime, endTime, numTicks);

yticks(idPRN)
xtickPositions = get(gca, 'XTick');
xtickLabels = arrayfun(@(x) sprintf('%i', x), tickPositions, 'UniformOutput', false);
set(gca, 'XTickLabel', xtickLabels);
xlim([0 spirent.satData.Time_ms(end)])



% SPIRENT NUMBER OF SATELLITES IN VIEW

unique_t = unique(spirent.satData.Time_ms);
numvis = zeros(size(unique_t));

for i = 1:length(unique_t)
    numvis(i) = sum(spirent.satData.Time_ms == unique_t(i));
end

figure
plot(unique_t, numvis, 'b-');
%area(unique_t,numvis)
xlabel('Time (s)');
ylabel('Number of satellites');
title('Spirent - Number of GPS satellites visible');
grid on;
yticks(0:1:max(numvis)); 
ylim([0 max(numvis)])
xtickPositions = get(gca, 'XTick');
xtickLabels = arrayfun(@(x) sprintf('%i', x), tickPositions, 'UniformOutput', false);
set(gca, 'XTickLabel', xtickLabels);
xlim([0 unique_t(end)])

% SPIRENT SKYPLOT
[allAz, allEl, satIDs] = skyplot_data(spirent,Type);

figure
sp = skyplot(allAz, allEl, string(satIDs));
title('Spirent - Skyplot');

%%%%%%%%%%%%%%%%%%%%%%%% GNSS-SDR %%%%%%%%%%%%%%%%%%%%%%%%
% GNSS SATELLITE VISIBILITY 

figure
hold on

for i=1:size(GnssSDR.obs.PRN,1)
    [~,cols,PRN] = find(GnssSDR.obs.PRN(i,:));
    TOW = GnssSDR.obs.TOW_at_current_symbol_s(i,cols);
    scatter(TOW, PRN,50,'.');
end 
title('GNSS-SDR - Satellite visibility');
xlabel('TOW (s)'); 
ylabel('Sat PRN'); 
grid on;
legend('ch1','ch2','ch3','ch4','ch5','ch6','ch7','Location','eastoutside')

% Plot tick labels - yaxis 
idPRN = unique(GnssSDR.obs.PRN);
yticks(idPRN)

% GNSS NUMBER OF SATELLITES IN VIEW

% GnssSDR.obs = load(GnssSDR.Path.obs);
% 
% TOW = unique(GnssSDR.obs.TOW_at_current_symbol_s);
% TOW = nonzeros(TOW);
% num_satellites_in_view = zeros(size(TOW));
% 
% for i=1:size(GnssSDR.obs.TOW_at_current_symbol_s,1)
%     for j=1:length(TOW)
%         [~,idx_c] = find(GnssSDR.obs.TOW_at_current_symbol_s(i,:)==TOW(j));
%         if GnssSDR.obs.PRN(i,idx_c) ~= 0
%             num_satellites_in_view(j) = num_satellites_in_view(j) + 1;
%         end 
%     end 
% end 
% 
% figure;
% plot(GnssSDR.obs.TOW_at_current_symbol_s(1, :), num_satellites_in_view);
% title('Number of Satellites in View vs. Time');
% xlabel('Time (s)');
% ylabel('Number of Satellites in View');
% grid on;


end