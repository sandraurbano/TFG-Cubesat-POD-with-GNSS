
% CUBESAT MODEL WITHOUT PERTURBATIONS CONFIGURATION FILE
% This file aims to define the parameters needed for the simulink 
% CubeSatModel_nopert.slx. This model simulate a 1U cubesat of 1.33kg.

% Thesis Title: GNSS-Based Navigation Method for POD in CubeSats
% AUTHOR: Sandra Urbano Rodriguez
% DATE: June, 2024

clc; clear; close all; 

% Simulink model name
mission.mdl = "CubeSatModel_nopert";

%% CENTRAL BODY: EARTH
% Define global parameters  
Earth.mu = 3.986*10^14;      % [m^3/s^2]
Earth.radius = 6378*10^3;    % [m]

%% CUBESAT: QBITO 

% Define Keplerian orbital elements
% QB50 orbit
mission.CubeSat.EpochDate   =   datetime(2014, 6, 15, 01, 05, 35); 
mission.CubeSat.Altitude         = 330*10^3;
mission.CubeSat.SemiMajorAxis    = Earth.radius + mission.CubeSat.Altitude; % [m]
mission.CubeSat.Eccentricity     = 0; % [-]
mission.CubeSat.Inclination      = 79; % [deg]
mission.CubeSat.RAAN             = 250;  % [deg]
mission.CubeSat.ArgOfPeriapsis   = 0; % [deg]
mission.CubeSat.TrueAnomaly      = 35; % [deg]

% Define cubeSat attitude
mission.CubeSat.Euler = [0 0 0];         % [deg]
mission.CubeSat.AngularRate = [0 0 0];   % [deg/s]

%% SIMULATION
% Define StartDate and time of duration for the simulation: 1 orbit
mission.StartDate = datetime(2014, 6, 15, 12, 0, 0);
mission.Period    = 2*pi*sqrt(mission.CubeSat.SemiMajorAxis^3/Earth.mu); 
mission.Duration  = hours(mission.Period/3600);
mission.EndDate   = mission.StartDate + mission.Duration;
mission.Timestep  = 0.5;

% Open simulaiton
open_system(mission.mdl);

%% CUBESAT VEHICLE BLOCK
% Define the path to the CubeSat Vehicle block in the model.
mission.CubeSat.blk = mission.mdl + "/CubeSat Vehicle";

% Set Cubesat Orbit initial conditions 
set_param(mission.CubeSat.blk, ...
    "sim_t0", num2str(juliandate(mission.StartDate)), ...
    "method", "Keplerian Orbital Elements", ...
    "epoch",      num2str(juliandate(mission.CubeSat.EpochDate)), ...
    "a",  "mission.CubeSat.SemiMajorAxis", ...
    "ecc",   "mission.CubeSat.Eccentricity", ...
    "incl", "mission.CubeSat.Inclination", ...
    "omega", "mission.CubeSat.RAAN", ...
    "argp",   "mission.CubeSat.ArgOfPeriapsis", ...
    "nu",    "mission.CubeSat.TrueAnomaly");

% Set CubeSat attitude initial conditions
set_param(mission.CubeSat.blk, ...
    euler           = "mission.CubeSat.Euler", ...
    pqr             = "mission.CubeSat.AngularRate", ...
    pointingMode    = "Earth (Nadir) Pointing", ...
    firstAlignExt   = "Dialog", ...
    firstAlign      = "[0 0 1]", ...
    secondAlignExt  = "Dialog", ...
    secondAlign     = "[0 1 0]", ...
    constraintCoord = "ECI Axes", ...
    secondRefExt    = "Dialog",...
    secondRef       = "[0 0 1]");

%% PROPAGATOR
% Define propagator properties
set_param(mission.mdl, ...
    "SolverType", "Fixed-step", ...
    "FixedStep",  string(mission.Timestep),...
    "RelTol",     "1e-6", ...
    "AbsTol",     "1e-7", ...
    "StopTime",  string(seconds(mission.Duration)));

%% SIMULATION OUTPUT
% Define otuput properties
set_param(mission.mdl, ...
    "SaveOutput", "on", ...
    "OutputSaveName", "yout", ...
    "SaveFormat", "Dataset",...
    "DatasetSignalFormat", "timeseries");

% Define output paths
Resultspath = "Data/ModelComparison/";
filename    = "SimOutput_QB50_nopert_final.mat";
filepath = fullfile(Resultspath,filename);


%% RUN SIMULATION AND SAVE DATA
% Run the Model and Collect Satellite Ephemerides
mission.SimOutput = sim(mission.mdl);
save(filepath,'mission');

% Create a txt with simulator output data
spirent(mission,orbitType,Resultspath); 
disp('Spirent data saved')



