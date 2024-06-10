
% MISSION ANALYSIS - SATELLITE SCENARIO REPRESENTATION 
% This file process the output of the Simulink simulation and gives a 3D
% representation of the orbit

% Thesis Title: GNSS-Based Navigation Method for POD in CubeSats
% AUTHOR: Sandra Urbano Rodriguez
% DATE: June, 2024

clc; clear; close all;

% Define plot characteristics
set(groot, 'defaultAxesFontSize', 12, ...  
           'defaultLineLineWidth', 1, ...  
           'defaultLegendlocation', 'best',...
           'defaultTextInterpreter', 'latex',...
           'defaultLegendInterpreter', 'latex',...
           'defaultAxesTickLabelInterpreter', 'latex');  

warning('off', 'all');

%% LOAD THE FILES NEEDED

CubeSatfile_QB50 = 'Data\QB50\SimOutput_QB50_final.mat';
simulinkSim.QB50 = load(CubeSatfile_QB50);

CubeSatfile_ISS = 'Data\ISS\Data_20240603\SimOutput_ISS_final.mat';
simulinkSim.ISS = load(CubeSatfile_ISS);

% QB50 = satellite(scenario,Re + 330*10^3,0,79,250,0,35,'Name','QB50');
% ISS = satellite(scenario,Re + 417*10^3, 0.0004413, 51.6479, 109.5258, 103.0788, 31.6858,'Name','ISS');

%% SATELLITE SCENARIO DEFINITION
% Define the time period of the simulation for the satellite scenario
startTime = simulinkSim.QB50.mission.StartDate;                      
stopTime = simulinkSim.QB50.mission.EndDate;                
sampleTime = simulinkSim.QB50.mission.Timestep;                                      

scenario = satelliteScenario(startTime,stopTime,sampleTime);

% videoFile = 'Results\scenario_video.mp4'; 
% videoWriter = VideoWriter(videoFile, 'MPEG-4'); 
% videoWriter.FrameRate = 30; 
% open(videoWriter); 

%  Extract position and velocity data from the model output data structure.
QB50_TimeseriesPosECEF = simulinkSim.QB50.mission.SimOutput.yout{1}.Values;
QB50_TimeseriesVelECEF = simulinkSim.QB50.mission.SimOutput.yout{2}.Values;

ISS_TimeseriesPosECEF = simulinkSim.ISS.mission.SimOutput.yout{1}.Values;
ISS_TimeseriesVelECEF = simulinkSim.ISS.mission.SimOutput.yout{2}.Values;

cubesatQB50 = satellite(scenario, QB50_TimeseriesPosECEF, QB50_TimeseriesVelECEF, ...
    "CoordinateFrame", "ecef",'Name','QB50');
cubesatQB50.MarkerColor = 'm';
cubesatQB50.Orbit.LineColor = 'm';

cubesatISS = satellite(scenario, ISS_TimeseriesPosECEF, ISS_TimeseriesVelECEF, ...
    "CoordinateFrame", "ecef",'Name','ISS');
cubesatISS.MarkerColor = 'c';
cubesatISS.Orbit.LineColor = 'c';

Earth.mu = 3.986*10^5;       % [km^3/s^2]

Sim_duration = hours(simulinkSim.QB50.mission.Duration);
t = linspace(0,Sim_duration,length(simulinkSim.QB50.mission.SimOutput.tout));

Period_QB50 = 2*pi*sqrt((simulinkSim.QB50.mission.CubeSat.SemiMajorAxis*10^-3)^3/Earth.mu)/3600; %[h]
idx_P_QB50 = find(abs(Period_QB50-t) < 0.00005);

Period_ISS = 2*pi*sqrt((simulinkSim.ISS.mission.CubeSat.SemiMajorAxis*10^-3)^3/Earth.mu)/3600; %[h]
idx_P_ISS= find(abs(Period_ISS-t) < 0.00005);


%% Visualize the Scenario
% Show the satellite scenario
disp(scenario)
v = satelliteScenarioViewer(scenario);
play(scenario,"Viewer",v);


%% GROUND TRACK PLOT
figure
h1 = geoplot(simulinkSim.QB50.mission.SimOutput.yout{6}.Values.Data(1:idx_P_QB50,1),...
    simulinkSim.QB50.mission.SimOutput.yout{6}.Values.Data(1:idx_P_QB50,2),'m-');
hold on
h2 = geoplot(simulinkSim.ISS.mission.SimOutput.yout{6}.Values.Data(1:idx_P_ISS,1),...
    simulinkSim.ISS.mission.SimOutput.yout{6}.Values.Data(1:idx_P_ISS,2),'b');

% Start-End point QB50
geoplot(simulinkSim.QB50.mission.SimOutput.yout{6}.Values.Data(1,1),...
    simulinkSim.QB50.mission.SimOutput.yout{6}.Values.Data(1,2),'k','Marker','x');
geoplot(simulinkSim.QB50.mission.SimOutput.yout{6}.Values.Data(idx_P_QB50,1),...
    simulinkSim.QB50.mission.SimOutput.yout{6}.Values.Data(idx_P_QB50,2),'r','Marker','x');

% Start-End point ISS
geoplot(simulinkSim.ISS.mission.SimOutput.yout{6}.Values.Data(1,1),...
    simulinkSim.ISS.mission.SimOutput.yout{6}.Values.Data(1,2),'k','Marker','x');
geoplot(simulinkSim.ISS.mission.SimOutput.yout{6}.Values.Data(idx_P_ISS,1),...
    simulinkSim.ISS.mission.SimOutput.yout{6}.Values.Data(idx_P_ISS,2),'r','Marker','x');
geobasemap("topographic")
title("CubeSat Ground Track")

% Create dummy plots for the legend with markers only
h1_marker = geoplot(nan, nan, 'm-');
h2_marker = geoplot(nan, nan, 'b-');
start_marker = geoplot(nan, nan, 'kx', 'MarkerFaceColor', 'k');
end_marker = geoplot(nan, nan, 'rx', 'MarkerFaceColor', 'r');

% Create the legend using the dummy plots
legend([h1_marker, h2_marker, start_marker, end_marker], {'QB50', 'ISS', 'Start Point', 'End Point'});

hold off;


