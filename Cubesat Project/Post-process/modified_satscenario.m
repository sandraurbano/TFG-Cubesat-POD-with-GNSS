
% MISSION ANALYSIS - SATELLITE SCENARIO REPRESENTATION 


% Define plot characteristics
set(groot, 'defaultAxesFontSize', 12, ...  
           'defaultLineLineWidth', 3, ...  
           'defaultLegendlocation', 'best',...
           'defaultTextInterpreter', 'latex',...
           'defaultLegendInterpreter', 'latex',...
           'defaultAxesTickLabelInterpreter', 'latex');  

%% LOAD CUBESAT EPHEMIREDES INTO SATELITE SCENARIO OBJECT

% Load the results obtained from CubeSat model
load('Data/orbitSimOutput.mat');

% SATELLITE SCENARIO DEFINITION
% Define the time period of the simulation for the satellite scenario
startTime = mission.StartDate;                      
stopTime = mission.StartDate + mission.Duration;                        
sampleTime = mission.Timestep;                                      

scenario = satelliteScenario(startTime,stopTime,sampleTime);

% Specify mask angle.
maskAngle = 5; % degrees

% CUBESAT SATELLITE OBJECT
%  Extract position and velocity data from the model output data structure.
mission.CubeSat.TimeseriesPosECEF = mission.SimOutput.yout{1}.Values;
mission.CubeSat.TimeseriesVelECEF = mission.SimOutput.yout{2}.Values;
mission.CubeSat.TimeseriesLatLon = mission.SimOutput.yout{6}.Values;
mission.CubeSat.TimeseriesAlt = mission.SimOutput.yout{7}.Values;


recPos = mission.CubeSat.TimeseriesPosECEF.Data;
recVel = mission.CubeSat.TimeseriesVelECEF.Data;

cubesat = satellite(scenario, mission.CubeSat.TimeseriesPosECEF, mission.CubeSat.TimeseriesVelECEF, ...
    "CoordinateFrame", "ecef",'Name','CubeSat');
set(cubesat.Orbit, LineColor="m");


% receiver position in geodetic coordinates.
receiverLLA = [mission.CubeSat.TimeseriesLatLon.Data(:,1), mission.CubeSat.TimeseriesLatLon.Data(:,2), mission.CubeSat.TimeseriesAlt.Data];

% SATELLITE VIEWER  
disp(scenario)
v = satelliteScenarioViewer(scenario);
play(scenario,"Viewer",v);


figure
geoplot(mission.CubeSat.TimeseriesLatLon.Data(:,1),mission.CubeSat.TimeseriesLatLon.Data(:,2))
geobasemap("topographic")
title("CubeSat Ground Track")

%% LOAD GPS CONSTELLATION EPHEMIREDES INTO SATELITE SCENARIO OBJECT

% Access results from GNSS-SDR (RINEX file)
file = 'Data\GNSSfiles\Data_20240320_ISSprueba\GSDR080u18_24N.rnx';

% Initialize satellites. 
navmsg = rinexread(file);
satellite(scenario,navmsg);
satID = scenario.Satellites.Name;

% Preallocate results.
numSats = numel(scenario.Satellites);
simulationSteps = size(mission.CubeSat.TimeseriesPosECEF.Data,1);
allSatPos = zeros(numSats,3,simulationSteps);
allSatVel = zeros(numSats,3,simulationSteps);

% Save satellite states over entire simulation.
for i = 1:numel(scenario.Satellites)
    [oneSatPos, oneSatVel] = states(scenario.Satellites(i),"CoordinateFrame","ecef");
    allSatPos(i,:,:) = permute(oneSatPos,[3 1 2]);
    allSatVel(i,:,:) = permute(oneSatVel,[3 1 2]);
end


% Preallocate results.
allP = zeros(numSats,simulationSteps);
allPDot = zeros(numSats,simulationSteps);
allIsSatVisible = false(numSats,simulationSteps);

% Use the skyplot to visualize satellites in view.
sp = skyplot([],[],MaskElevation=maskAngle);

for idx = 1:simulationSteps
    satPos = allSatPos(:,:,idx);
    satVel = allSatVel(:,:,idx);
    
    % Calculate satellite visibilities from receiver position.
    [satAz,satEl,allIsSatVisible(:,idx)] = lookangles(receiverLLA(idx,:),satPos,maskAngle);
    
    % Calculate pseudoranges and pseudorange rates using satellite and
    % receiver positions and velocities.
    [allP(:,idx),allPDot(:,idx)] = pseudoranges(receiverLLA(idx,:),satPos,recVel(idx,:),satVel);
    
    set(sp,"AzimuthData",satAz(allIsSatVisible(:,idx)), ...
        "ElevationData",satEl(allIsSatVisible(:,idx)), ...
        "LabelData",satID(allIsSatVisible(:,idx)))
    drawnow limitrate
end












