function sat_scenario(CubeSatfile,RINEXfile,results_path)
% Aim: Create a satellite scenario
% INPUT  --> CubeSatfile: .mat with the results of the simulation
%            RINEXfile: .rnx with the reuslts of GNSS-SDR
%            fig: number of the figure
% OUTPUT --> satellite viewer, skyplot, num of visible satellites plot, 
%            visibility chart and updated fig 

%% LOAD CUBESAT EPHEMIREDES INTO SATELITE SCENARIO OBJECT
load(CubeSatfile);

%% SATELLITE SCENARIO
% Define the time period of the simulation for the satellite scenario
startTime = mission.StartDate;                      
%stopTime = mission.EndDate;
stopTime = startTime + mission.Duration;
sampleTime = mission.Timestep;                                      

scenario = satelliteScenario(startTime,stopTime,sampleTime);

%% CUBESAT SATELLITE OBJECT
%  Extract position and velocity data from the model output data structure.
mission.CubeSat.TimeseriesPosECEF = mission.SimOutput.yout{1}.Values;
mission.CubeSat.TimeseriesVelECEF = mission.SimOutput.yout{2}.Values;
mission.CubeSat.TimeseriesLatLon = mission.SimOutput.yout{6}.Values;
mission.CubeSat.TimeseriesAlt = mission.SimOutput.yout{7}.Values;

cubesat = satellite(scenario, mission.CubeSat.TimeseriesPosECEF, mission.CubeSat.TimeseriesVelECEF, ...
    "CoordinateFrame", "ecef",'Name','CubeSat');
set(cubesat.Orbit, LineColor="m");

% Play animation
disp(scenario)
v = satelliteScenarioViewer(scenario);
play(scenario,"Viewer",v);

%% GROUND TRACK
figure
geoplot(mission.CubeSat.TimeseriesLatLon.Data(:,1),mission.CubeSat.TimeseriesLatLon.Data(:,2))
geobasemap("topographic")
title("CubeSat Ground Track")
filename = fullfile(results_path, 'ground_track.png');
saveas(gcf, filename);


%% LOAD GPS CONSTELLATION EPHEMIREDES INTO SATELITE SCENARIO OBJECT

% Obtain GPS data from navigation rinex file 
navmsg = rinexread(RINEXfile); 
GPSsat = satellite(scenario,navmsg);

% Find the access between the cubesta and the GPS satellites
access_Cubesast = access(GPSsat,cubesat);
[status_Cubesat, timeSteps] = accessStatus(access_Cubesast);

%% NUMBER OF VISIBLE SATELLITES PLOT
% Sum cumulative access at each timestep
gps_num = sum(status_Cubesat, 1);

figure
stairs(timeSteps, gps_num,'b','LineWidth',1);
title("Matlab - Number of GPS satellites visble")
ylabel("Number of satellites");
ylim([0 max(gps_num)+1])
grid on
filename = fullfile(results_path, 'matlab_numsats.png');
saveas(gcf, filename);


%% VSIBILITY CHART

% Find the PRN index of each satellite
satNames = char(GPSsat(:).Name');
prnIndex = double(string(satNames(:,5:end)));

status_Cubesat = double(status_Cubesat);
status_Cubesat(status_Cubesat == 0) = NaN;

% Plot the satellite visibility chart
figure
set(gcf,'WindowState','maximized');
plot(timeSteps,prnIndex.*status_Cubesat,'b','LineWidth',2)
xlim([timeSteps(1) timeSteps(end)])
ylim([min(prnIndex)-1 max(prnIndex)+1])
ylabel("Satellite PRN Index")
title("Matlab - Satellite visbility chart")
yticks(prnIndex)
grid on
filename = fullfile(results_path, 'matlab_visibility.png');
saveas(gcf, filename);

end

