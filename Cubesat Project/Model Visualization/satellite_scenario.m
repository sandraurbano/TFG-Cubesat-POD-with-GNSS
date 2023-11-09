
% MISSION ANALYSIS - SATELLITE SCENARIO REPRESENTATION 

clc; clear; close all;

% Load the results obtained from CubeSat model
load('Data/orbitSimOutput.mat');

%  Extract position and velocity data from the model output data structure.
mission.CubeSat.TimeseriesPosECEF = mission.SimOutput.yout{1}.Values;
mission.CubeSat.TimeseriesVelECEF = mission.SimOutput.yout{2}.Values;
mission.CubeSat.TimeseriesLatLon = mission.SimOutput.yout{5}.Values;
mission.CubeSat.TimeseriesAlt = mission.SimOutput.yout{6}.Values;

% Set the start data from the mission in the timeseries object.
mission.CubeSat.TimeseriesPosECEF = setuniformtime(mission.CubeSat.TimeseriesPosECEF,...
    'StartTime',0,'EndTime',seconds(mission.Duration));
mission.CubeSat.TimeseriesVelECEF = setuniformtime(mission.CubeSat.TimeseriesVelECEF,...
    'StartTime',0,'EndTime',seconds(mission.Duration));
mission.CubeSat.TimeseriesLatLon = setuniformtime(mission.CubeSat.TimeseriesLatLon,...
    'StartTime',0,'EndTime',seconds(mission.Duration));
mission.CubeSat.TimeseriesAlt = setuniformtime(mission.CubeSat.TimeseriesAlt,...
    'StartTime',0,'EndTime',seconds(mission.Duration));

mission.CubeSat.TimeseriesPosECEF.TimeInfo.StartDate = mission.StartDate;
mission.CubeSat.TimeseriesVelECEF.TimeInfo.StartDate = mission.StartDate;
mission.CubeSat.TimeseriesLatLon.TimeInfo.StartDate = mission.StartDate;
mission.CubeSat.TimeseriesAlt.TimeInfo.StartDate = mission.StartDate;

mission.CubeSat.GeodeticCoord = timeseries2timetable(mission.CubeSat.TimeseriesLatLon, mission.CubeSat.TimeseriesAlt);

% Load the Satellite Ephemerides into a satelliteScenario Object
% Create a satellite scenario object to use during the analysis

scenario = satelliteScenario;
sat = satellite(scenario, mission.CubeSat.TimeseriesPosECEF, mission.CubeSat.TimeseriesVelECEF, ...
    "CoordinateFrame", "ecef");
disp(scenario)
play(scenario);
disp(scenario.Viewers(1))
groundTrack(sat);



