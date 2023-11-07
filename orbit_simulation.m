
clc; clear; close all; 

% Define global parameters  
% mu = 3.986*10^5;      % Gravitational parameter [km^3/s^2]
% r_earth = 6378;       % Radius of Earth [km]

% Define simulation parameters
mission.StartDate = datetime(2019, 1, 1, 12, 0, 0);
mission.Duration  = hours(6);

% Keplerian orbital elements for the CubeSat at the mission.StartDate.
mission.CubeSat.EpochDate = datetime(2020, 1, 1, 12, 0, 0);
mission.CubeSat.SemiMajorAxis  = 6786233.13; % [m]
mission.CubeSat.Eccentricity   = 0.0010537;
mission.CubeSat.Inclination    = 51.7519;    % [deg]
mission.CubeSat.RAAN           = 95.2562;    % [deg]
mission.CubeSat.ArgOfPeriapsis = 93.4872;    % [deg]
mission.CubeSat.TrueAnomaly    = 202.9234;   % [deg]

% CubeSat attitude at the mission.StartDate.
mission.CubeSat.Euler = [0 0 0];             % [deg]
mission.CubeSat.AngularRate = [0 0 0];       % [deg/s]


% Open simulaiton
mission.mdl = "CubeSat_model";
open_system(mission.mdl);

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
    "euler",  "mission.CubeSat.Euler", ...
    "pqr", "mission.CubeSat.AngularRate", ...
    "pointingMode", "Earth (Nadir) Pointing", ...
    "firstAlignExt",  "Dialog", ...
    "secondAlignExt",   "Dialog", ...
    "constraintCoord", "ECI Axes", ...
    "secondRefExt", "Dialog");

% For best performance and accuracy when using a numerical propagator, use a variable-step solver.
set_param(mission.mdl, ...
    "SolverType", "Variable-step", ...
    "SolverName", "VariableStepAuto", ...
    "RelTol",     "1e-6", ...
    "AbsTol",     "1e-7", ...
    "StopTime",  string(seconds(mission.Duration)));

% Save model output port data as a dataset of time series objects.
set_param(mission.mdl, ...
    "SaveOutput", "on", ...
    "OutputSaveName", "yout", ...
    "SaveFormat", "Dataset");

% Run the Model and Collect Satellite Ephemerides
mission.SimOutput = sim(mission.mdl);

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



