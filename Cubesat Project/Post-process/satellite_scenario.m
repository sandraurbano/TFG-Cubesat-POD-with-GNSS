function satellite_scenario(CubeSatfile,RINEXfile)
% Aim: Create a satellite scenario
% INPUT  --> CubeSatfile: .mat with the results of the simulation
%            RINEXfile: .rnx with the reuslts of GNSS-SDR
%            fig: number of the figure
% OUTPUT --> satellite viewer, skyplot, num of visible satellites plot, 
%            visibility chart and updated fig 

%% LOAD CUBESAT EPHEMIREDES INTO SATELITE SCENARIO OBJECT
load(CubeSatfile);

% SATELLITE SCENARIO DEFINITION
% Define the time period of the simulation for the satellite scenario
startTime = mission.StartDate;                      
stopTime = mission.EndDate;                
sampleTime = mission.Timestep;                                      

scenario = satelliteScenario(startTime,stopTime,sampleTime);

% CUBESAT SATELLITE OBJECT
%  Extract position and velocity data from the model output data structure.
mission.CubeSat.TimeseriesPosECEF = mission.SimOutput.yout{1}.Values;
mission.CubeSat.TimeseriesVelECEF = mission.SimOutput.yout{2}.Values;
mission.CubeSat.TimeseriesLatLon = mission.SimOutput.yout{6}.Values;
mission.CubeSat.TimeseriesAlt = mission.SimOutput.yout{7}.Values;

cubesat = satellite(scenario, mission.CubeSat.TimeseriesPosECEF, mission.CubeSat.TimeseriesVelECEF, ...
    "CoordinateFrame", "ecef",'Name','CubeSat');
set(cubesat.Orbit, LineColor="m");

% SATELLITE VIEWER  
disp(scenario)
v = satelliteScenarioViewer(scenario);
play(scenario,"Viewer",v);

figure
geoplot(mission.CubeSat.TimeseriesLatLon.Data(:,1),mission.CubeSat.TimeseriesLatLon.Data(:,2))
geobasemap("topographic")
title("CubeSat Ground Track")



%% LOAD GPS CONSTELLATION EPHEMIREDES INTO SATELITE SCENARIO OBJECT

navmsg = rinexread(RINEXfile); 
GPSsat = satellite(scenario,navmsg);
% satID = scenario.GPSsat.Name;
access_Cubesast = access(GPSsat,cubesat);

% SATELLITE VIEWER CUBESAT+GPS CONSTELLATION WITH ACCESS
play(scenario,"Viewer",v);

% NUMBER OF VISIBLE SATELLITES PLOT
[status_Cubesat, timeSteps] = accessStatus(access_Cubesast);

% Sum cumulative access at each timestep
status_Cubesat = sum(status_Cubesat, 1);

figure
stairs(timeSteps, status_Cubesat,'LineWidth',1);
title("Cubesat to GPS")
ylabel("Number of satellites")

%% SKYPLOT

% Get the status of access across the time history of the scenario
[status_Cubesat,timeSteps] = accessStatus(access_Cubesast);
[azHistory,elHistory] = aer(cubesat,GPSsat);

% Number of timestamps run by the scenario
numTimeStamps = numel(timeSteps);

% When you have no access, set the elevation angle history to NaN
elHistory(status_Cubesat == 0) = NaN;

% Transpose the histories of the azimuth angles and elevation angles to
% have timestamps as rows, which helps plot skyplot
% azHistoryTranspose = azHistory';
% elHistoryTranspose = elHistory';

% Visualize the visible satellites over time
% sp = skyplot([],[]);
% for tIdx = 1:numTimeStamps
%     set(sp, ...
%         AzimuthData=azHistoryTranspose(tIdx,:), ...
%         ElevationData=elHistoryTranspose(tIdx,:), ...
%         LabelData=GPSsat.Name);
%     % For slower animation, use 'drawnow' instead of 'drawnow limitrate'
%     drawnow limitrate
% end


%% VSIBILITY CHART

% Find the PRN index of each satellite
satNames = char(GPSsat(:).Name');
prnIndex = double(string(satNames(:,5:end)));

% To better visualize each GPS satellite, scale the status with the PRN
% index
status_Cubesat = double(status_Cubesat);
status_Cubesat(status_Cubesat == 0) = NaN;

% Plot the satellite visibility chart
colors = colororder;
firstLineColor = colors(1,:);

figure
plot(timeSteps,prnIndex.*status_Cubesat, ...
    Color=firstLineColor,LineWidth=1)
xlim([timeSteps(1) timeSteps(end)])
ylim([min(prnIndex)-1 max(prnIndex)+1])
xlabel("Time")
ylabel("Satellite PRN Index")
title("Satellite Visibility Chart")
yticks(prnIndex)
grid on

end

