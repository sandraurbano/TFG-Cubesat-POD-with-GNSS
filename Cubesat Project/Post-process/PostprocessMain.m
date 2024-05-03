
%% POST-PROCESS GNSS-SDR DATA

clc; clear; close all;

% Define plot characteristics
set(groot, 'defaultAxesFontSize', 12, ...  
           'defaultLineLineWidth', 1, ...  
           'defaultLegendlocation', 'best',...
           'defaultTextInterpreter', 'latex',...
           'defaultLegendInterpreter', 'latex',...
           'defaultAxesTickLabelInterpreter', 'latex');  
fig = 1;
warning('off', 'all');

% define the number of channels and sampling frequency 
channels = 7;
samplingFreq = 5000000;  % [Hz]
ConstellationType = 'GPS';


%% LOAD THE FILES NEEDED

% Load the results obtained from SIMULINK - CUBESAT MODEL 
CubeSatfile = 'Data\ISS_short\orbitSimOutput_ISS_short.mat';
simulinkSim = load(CubeSatfile);

% Load the results from SPIRENT
spirent_path = 'Data\ISS_short\SPIRENT_ref_data\2024_03_01_16_51_29\'; 

% Spirent - ground truth 
spirent_motion = readtable([spirent_path 'motion_V1.csv'],'VariableNamingRule','preserve');
spirent.motion = table2struct(spirent_motion,"ToScalar",true);

% Spirent - GNSS data
spirent_satData = readtable([spirent_path 'sat_data_V1A1_corrected.csv']);
spirent.satData = table2struct(spirent_satData,"ToScalar",true);

% Define the path of the GNSS SDR files 
GnssSDR.Path.rnx_Nav = 'Data\ISS_short\GNSS_SDR\2024_04_25\GSDR117m09_24N.rnx';
GnssSDR.Path.rnx_Obs = 'Data\ISS_short\GNSS_SDR\2024_04_25\GSDR108l49_24O.rnx';
GnssSDR.Path.obs = 'Data\ISS_short\GNSS_SDR\2024_04_25\observables.mat';
GnssSDR.Path.PVT = 'Data\ISS_short\GNSS_SDR\2024_04_25\PVT.mat';
GnssSDR.Path.KML = 'Data\ISS_short\GNSS_SDR\2024_04_25\PVT_240426_120905.kml';
GnssSDR.Path.trk = 'Data\ISS_short\GNSS_SDR\2024_04_25\GPS_tracking\';

%% SKYPLOT + VISIBILITY
% skyplot(spirent,ConstellationType)

%% SATELLITE SCENARIO
% satellite scenario, skyplot and visibility chart
% satellite_scenario(CubeSatfile,GnssSDR.Path.rnx_Nav);

%% POSITION 
GnssSDR.PVT = load(GnssSDR.Path.PVT);
%Position_plot(GnssSDR.PVT,simulinkSim.mission,spirent);
%PVTplots(GnssSDR.PVT,spirent,ConstellationType,simulinkSim.mission);

%% KML
% HAY VARIOS!! REVISAR
% KML_plot(GnssSDR.Path.KML);

%% PRECISE ORBIT DETERMINATION
%POD_plot(GnssSDR.PVT,spirent,ConstellationType,simulinkSim.mission);

%% TRACKING 
for ch=1:channels
    GnssSDR.trk(ch) = load([GnssSDR.Path.trk sprintf('epl_tracking_ch_%i.mat',ch-1)]);
end 
%Tracking_plot(GnssSDR.trk,channels,samplingFreq);
Trk_plot(GnssSDR.trk(1),samplingFreq);
%% OBSERVABLES
GnssSDR.obs = load(GnssSDR.Path.obs);
observables_plot(spirent,GnssSDR.obs,ConstellationType,simulinkSim.mission)
visibillity_plots(simulinkSim.mission,GnssSDR,spirent,ConstellationType)

%% ADQUISITION
% adquistion_plot()

