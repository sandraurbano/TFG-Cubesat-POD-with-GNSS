
%% ANALYZE GPS SATELLITE VSIBILLITY 

clc; clear; close all;

%% Specify Simulation Parameters

% Navigation files
file = 'Data/GNSSfiles/GODS00USA_R_20210260000_01D_GN.rnx';
gnssFileType = 'RINEX'; % message file type (RINEX,SEM,YUCA)

% Orbit simulation output data
load('Data/orbitSimOutput.mat')

% GPS simulation parameters
startTime = mission.StartDate;                  % Start time
numHours = mission.Duration;                    % Simulation duration [h]
dt = 5;                                         % Time between samples [s]

timeElapsed = 0:dt:seconds(numHours);
t = startTime + seconds(timeElapsed);
stopTime = t(end);

% CubeSat location
mission.CubeSat.TimeseriesLatLon = mission.SimOutput.yout{5}.Values;
mission.CubeSat.TimeseriesAlt = mission.SimOutput.yout{6}.Values;

mission.CubeSat.TimeseriesLatLon = setuniformtime(mission.CubeSat.TimeseriesLatLon,...
    'StartTime',0,'EndTime',seconds(mission.Duration));
mission.CubeSat.TimeseriesAlt = setuniformtime(mission.CubeSat.TimeseriesAlt,...
    'StartTime',0,'EndTime',seconds(mission.Duration));

idx_time = 10;
queryTime = t(idx_time);
lat = mission.SimOutput.yout{5}.Values.Data(idx_time,1);    % Geodetic latittude [deg]
lon = mission.SimOutput.yout{5}.Values.Data(idx_time,2);    % Geodetic longitude [deg]
alt = mission.SimOutput.yout{6}.Values.Data(idx_time);                % Geodetic altittude [m]
recPos = [lat lon alt];                         % Receiver position vector
MaskAngle = 0;                                  % Mask angle of the receiver


%% Get Satellite Orbital Parameters
[navmsg,satIDs] = parseGNSSfile(gnssFileType,file);

%% Generate Satellite Visibilities
% Aim: generate the satellite visibilities as a matrix of logical values. 
% Each row in the matrix corresponds to a time step, and each column 
% corresponds to a satellite. 

numSats = numel(satIDs);
numSamples = numel(t);

az = zeros(numSamples,numSats);         % azimuth data [deg] 
                                        % clockwise-positive from the North direction

el = zeros(numSamples,numSats);         % elevation data [deg] 
                                        % measured from the horizon line with 90 degrees being directly up
                                        
vis = false(numSamples,numSats);        % Visibillity of satellites matrix

figure
sp = skyplot([],[],MaskElevation=MaskAngle);


% To plot visibilities, iterate through the time vector while calculating 
% the satellite positions and look angles based on the GNSS constellation simulation.

for k = 1:numel(t)

    satPos = gnssconstellation(t(k),navmsg,GNSSFileType=gnssFileType);
    % gnssconstellation function
    % Input:  --> t: datetime [s]
    %         --> navmsg: specified navigation message data
    %         --> GNSSFileType: GNSS file type from which you obtained the 
    %             navigation message data (Rinex, Sem, Yuca)
    % Output: --> satPos: position in ECEF coordinates [m]


    [az(k,:),el(k,:),vis(k,:)] = lookangles(recPos,satPos,MaskAngle);
    % lookangles function
    % Input:  --> recPos: receiver position 
    %         --> satPos: satellite position
    %         --> mask angle
    % Output: --> az: azimuth angle [deg] in the ECEF Reference Frame
    %         --> el: elevation angle [deg] in the ECEF Reference Frame
    %         --> vis: visibilllity satellite array

    % Define the input of the skyplot
    set(sp,AzimuthData=az(k,vis(k,:)), ...
        ElevationData=el(k,vis(k,:)), ...
        LabelData=satIDs(vis(k,:)))
    drawnow limitrate
end

figure
el(el < 0) = missing;
sp_contour = skyplot(az(1,:),el(1,:),satIDs,MaskElevation=MaskAngle);
for idx = 1:size(az, 1)
    set(sp_contour,AzimuthData=az(1:idx,:),ElevationData=el(1:idx,:));
end
drawnow limitrate


%% Generate Satellite Visibilities 

% Satellite visibility chart
visPlotData = double(vis);
visPlotData(visPlotData == false) = NaN; % Hide invisible satellites.
visPlotData = visPlotData + (0:numSats-1); % Add space to satellites to be stacked.
colors = colororder;

figure
plot(t,visPlotData,".",Color=colors(1,:))
yticks(1:numSats)
yticklabels(string(satIDs))
grid on
ylabel("Satellite ID")
xlabel("Time")
title("Satellite Visibility Chart")
axis tight

% Total number of visible satellites at each time step
numVis = sum(vis,2);

figure
area(t,numVis)
grid on
xlabel("Time")
ylabel("Number of satellites visible")
title("Number of GPS satellites visible")
axis tight

%% Satellite scenario 

scenario = satelliteScenario(startTime,stopTime,dt);

RINEXdata = rinexread(file); 
GPSsat = satellite(scenario,RINEXdata);
CubeSat = groundStation(scenario,lat,lon,MinElevationAngle=MaskAngle);

ac = access(GPSsat,CubeSat);
v = satelliteScenarioViewer(scenario,CurrentTime=queryTime,ShowDetails=false);
campos(v,CubeSat.Latitude,CubeSat.Longitude,CubeSat.Altitude+6e7);





