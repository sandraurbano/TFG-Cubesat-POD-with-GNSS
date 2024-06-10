
% POST-PROCESS GNSS-SDR DATA
% This file processes data from Spirent and GNSS-SDR, and generates the
% corresponding plots for analysis.

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

% Load the results obtained from SIMULINK - CUBESAT MODEL 
CubeSatfile = 'Data\QB50\SPIRENT_ref_data\Data_20240509\SimOutput_QB50orbit.mat';
simulinkSim = load(CubeSatfile);

% Load the results from SPIRENT
spirent_path = 'Data\QB50\SPIRENT_ref_data\Data_20240509\'; 

% Spirent - ground truth 
spirent_motion = readtable([spirent_path 'motion_V1.csv'],'VariableNamingRule','preserve');
spirent.motion = table2struct(spirent_motion,"ToScalar",true);

% Spirent - GNSS data
opts = detectImportOptions([spirent_path 'sat_data_V1A1_corrected.csv']);
opts = setvartype(opts, {'Sat_type'}, {'char'});
spirent_satData = readtable([spirent_path 'sat_data_V1A1_corrected.csv'],opts);
spirent.satData = table2struct(spirent_satData,"ToScalar",true);

% Define the constellation you want to study
ConstellationType = 'GPS';

% Define the path of the GNSS-sdr files 
data_path = 'Data\QB50\GNSS_SDR\QB50_0509\';

GnssSDR.Path.rnx_Nav = fullfile(data_path,'GSDR_24N.rnx');
GnssSDR.Path.rnx_Obs = fullfile(data_path,'GSDR_24O.rnx');
GnssSDR.Path.obs = fullfile(data_path,'observables.mat');
GnssSDR.Path.PVT = fullfile(data_path,'PVT.mat');
GnssSDR.Path.KML = fullfile(data_path,'PVT.kml');
GnssSDR.Path.trk = fullfile(data_path,'GPS_tracking\');

% Define characteristics of GNSS-sdr
channels = 7;            
samplingFreq = 5000000;  % [Hz]

% Load the GNSS-sdr data into the struct
GnssSDR.PVT = load(GnssSDR.Path.PVT);
GnssSDR.obs = load(GnssSDR.Path.obs);
for ch=1:channels
    GnssSDR.trk(ch) = load([GnssSDR.Path.trk sprintf('epl_tracking_ch_%i.mat',ch-1)]);
end 

% Define path for Results
results_path = fullfile('Results\ISS\', '03_01', '\');

% In the case of using ISS_short (15 minutes) filter data spirent because
% is longer and may cause errors 
% time_limit_ms = 15 * 60 * 1000;
% indices_time = spirent.satData.Time_ms <= time_limit_ms;
% spirent.satData = structfun(@(x) x(indices_time, :), spirent.satData, 'UniformOutput', false);
% indices_time = spirent.motion.Time_ms <= time_limit_ms;
% spirent.motion = structfun(@(x) x(indices_time, :), spirent.motion, 'UniformOutput', false);


%% CHECK GROUND TRUTH (SIMULINK VS SPIRENT)

figure
plot3(spirent.motion.Pos_X,spirent.motion.Pos_Y,spirent.motion.Pos_Z);
hold on
plot3(simulinkSim.mission.SimOutput.yout{1}.Values.Data(:,1),...
    simulinkSim.mission.SimOutput.yout{1}.Values.Data(:,2),...
    simulinkSim.mission.SimOutput.yout{1}.Values.Data(:,3),'--');
grid on 
xlabel('$x_{ECEF}$ [m]');
ylabel('$y_{ECEF}$ [m]');
zlabel('$z_{ECEF}$ [m]');
title("QB50 Orbit");
legend('Spirent','Simulink')
filename = fullfile(results_path, 'ground_truth.png');
saveas(gcf, filename);

%% SATELLITE SCENARIO
sat_scenario(CubeSatfile,GnssSDR.Path.rnx_Nav,results_path);

%% POSITION 
PVT_plot(GnssSDR.PVT,spirent,ConstellationType,simulinkSim.mission,results_path,data_path);

%% KML
KML_plot(GnssSDR.Path.KML);

%% TRACKING 
Tracking_plot(GnssSDR.trk,channels,samplingFreq,results_path);
% animatedTRK_plot(GnssSDR.trk(1),samplingFreq);

%% OBSERVABLES
observables_plot(spirent,GnssSDR.obs,ConstellationType,simulinkSim.mission,results_path)
visibillity_plots(simulinkSim.mission,GnssSDR,spirent,channels,ConstellationType,results_path)


