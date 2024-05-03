
%% POST-PROCESS GNSS-SDR DATA

clc; clear; close all;

% Define plot characteristics
set(groot, 'defaultAxesFontSize', 12, ...  
           'defaultLineLineWidth', 1, ...  
           'defaultLegendlocation', 'best',...
           'defaultTextInterpreter', 'latex',...
           'defaultLegendInterpreter', 'latex',...
           'defaultAxesTickLabelInterpreter', 'latex');  

%% OBSERVABLES
obs = load('Data\GNSSfiles\observables.mat');

%% POSITION 
PVT = load('Data\GNSSfiles\PVT.mat');
Position_plot(PVT);
KML_file = 'Data\GNSSfiles\PVT_231128_103035.kml';
KML_plot(KML_file);

%% TRACKING
tracking_path = 'Data\GNSSfiles\tracking\';

% define the number of channels and sampling frequency 
channels = 5;
samplingFreq = 2000000;

for ch=1:channels
    filenm = sprintf('trk_dump_ch%i.mat',ch);
    TRK = load([tracking_path filenm]);
    Tracking_plot(TRK,samplingFreq)
end 


