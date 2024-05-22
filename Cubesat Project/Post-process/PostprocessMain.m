
%% POST-PROCESS GNSS-SDR DATA

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
CubeSatfile = 'Data\QB50\SimOutput_QB50orbit.mat';
simulinkSim = load(CubeSatfile);

% Load the results from SPIRENT
spirent_path = 'Data\QB50\SPIRENT_ref_data\Data_20240509\'; 

% Spirent - ground truth 
spirent_motion = readtable([spirent_path 'motion_V1.csv'],'VariableNamingRule','preserve');
spirent.motion = table2struct(spirent_motion,"ToScalar",true);

% Spirent - GNSS data
spirent_satData = readtable([spirent_path 'sat_data_V1A1_corrected.csv']);
spirent.satData = table2struct(spirent_satData,"ToScalar",true);

% Define the constellation you want to study
ConstellationType = 'GPS';

% Define the path of the GNSS-sdr files 
GnssSDR.Path.rnx_Nav = 'Data\QB50\GNSS_SDR\2024_05_13\GSDR_24N.rnx';
GnssSDR.Path.rnx_Obs = 'Data\QB50\GNSS_SDR\2024_05_13\GSDR_24O.rnx';
GnssSDR.Path.obs = 'Data\QB50\GNSS_SDR\2024_05_13\observables.mat';
GnssSDR.Path.PVT = 'Data\QB50\GNSS_SDR\2024_05_13\PVT.mat';
GnssSDR.Path.KML = 'Data\QB50\GNSS_SDR\2024_05_13\PVT.kml';
GnssSDR.Path.trk = 'Data\QB50\GNSS_SDR\2024_05_13\GPS_tracking\';

% Define characteristics of GNSS-sdr
channels = 7;            % Number of channels
samplingFreq = 5000000;  % Sampling frequency [Hz]

% Load the GNSS-sdr data into the struct
GnssSDR.PVT = load(GnssSDR.Path.PVT);
GnssSDR.obs = load(GnssSDR.Path.obs);
for ch=1:channels
    GnssSDR.trk(ch) = load([GnssSDR.Path.trk sprintf('epl_tracking_ch_%i.mat',ch-1)]);
end 

% Define path for Results
results_path = 'Results/QB50/2024_05_13/';

%% SATELLITE SCENARIO
% satellite scenario, skyplot and visibility chart
% satellite_scenario(CubeSatfile,GnssSDR.Path.rnx_Nav);

%% POSITION 
Position_plot(GnssSDR.PVT,simulinkSim.mission,spirent);
PVTplots(GnssSDR.PVT,spirent,ConstellationType,simulinkSim.mission);

%% KML
KML_plot(GnssSDR.Path.KML);

%% PRECISE ORBIT DETERMINATION
% POD_plot(GnssSDR.PVT,spirent,ConstellationType,simulinkSim.mission);

%% TRACKING 
Tracking_plot(GnssSDR.trk,channels,samplingFreq);
% animatedTRK_plot(GnssSDR.trk(1),samplingFreq);

%% OBSERVABLES
observables_plot(spirent,GnssSDR.obs,ConstellationType,simulinkSim.mission)
visibillity_plots(simulinkSim.mission,GnssSDR,spirent,ConstellationType)

%% ADQUISITION
% adquistion_plot()

