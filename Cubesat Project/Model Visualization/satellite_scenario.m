
% MISSION ANALYSIS - SATELLITE SCENARIO REPRESENTATION 

% Load the results obtained from CubeSat model
load('orbitSimOutput.mat');

%  Extract position and velocity data from the model output data structure.
mission.CubeSat.TimeseriesPosECEF = mission.SimOutput.yout{1}.Values;
mission.CubeSat.TimeseriesVelECEF = mission.SimOutput.yout{2}.Values;

% Set the start data from the mission in the timeseries object.
mission.CubeSat.TimeseriesPosECEF = setuniformtime(mission.CubeSat.TimeseriesPosECEF,...
    'StartTime',0,'EndTime',seconds(mission.Duration));
mission.CubeSat.TimeseriesVelECEF = setuniformtime(mission.CubeSat.TimeseriesPosECEF,...
    'StartTime',0,'EndTime',seconds(mission.Duration));
mission.CubeSat.TimeseriesPosECEF.TimeInfo.StartDate = mission.StartDate;
mission.CubeSat.TimeseriesVelECEF.TimeInfo.StartDate = mission.StartDate;

% Load the Satellite Ephemerides into a satelliteScenario Object
% Create a satellite scenario object to use during the analysis

scenario = satelliteScenario;
sat = satellite(scenario, mission.CubeSat.TimeseriesPosECEF, mission.CubeSat.TimeseriesVelECEF, ...
    "CoordinateFrame", "ecef");
% disp(scenario)

% ts = [mission.SimOutput.yout{5}.Values(:,1),mission.SimOutput.yout{5}.Values(:,2), mission.SimOutput.yout{6}.Values];
% mission.CubeSat.GeodeticCoord = timeseries2timetable(ts);
% mission.CubeSat.GeodeticCoord.Properties.VariableNames = {'Lat','Lon','alt'};



