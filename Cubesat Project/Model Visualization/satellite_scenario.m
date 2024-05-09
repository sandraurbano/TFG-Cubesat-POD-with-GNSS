
% MISSION ANALYSIS - SATELLITE SCENARIO REPRESENTATION 

clc; clear; close all;

% Load the results obtained from CubeSat model
load('Data\QB50\SimOutput_QB50orbit.mat');
% file = 'Data/GNSSfiles/GODS00USA_R_20210260000_01D_GN.rnx';

% SATELLITE SCENARIO DEFINITION
% Define the time period of the simulation for the satellite scenario
startTime = mission.StartDate;                      
stopTime = mission.EndDate;                
sampleTime = mission.Timestep;                                      

scenario = satelliteScenario(startTime,stopTime,sampleTime);

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

% RINEXdata = rinexread(file); 
% GPSsat = satellite(scenario,RINEXdata);




