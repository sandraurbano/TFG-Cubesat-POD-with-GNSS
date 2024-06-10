
%% PRECISE ORBIT DETERMINATION ERROR
% This file computes the error between spirent and gnss-sdr data to asses 
% the precsion of the positioning.  

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

% Load data
spirent_pos = table2array(readtable('Data\ISS\GNSS_SDR\2024_03_01_v2\pos_spirent.csv'));
gnss_pos = table2array(readtable('Data\ISS\GNSS_SDR\2024_03_01_v2\pos_gnsssdr.csv'));

% Definine the interval on x
x_min = 3.345e6; 
x_max = 3.905e6; 

% Keep the data for the defined interval
idxS_x = spirent_pos(:, 1) >= x_min & spirent_pos(:, 1) <= x_max;
idxG_x = gnss_pos(:, 1) >= x_min & gnss_pos(:, 1) <= x_max;
spirent_pos_range = spirent_pos(idxS_x, :);
gnsssdr_pos_range = gnss_pos(idxG_x, :);

%% POSITION XY 
% Define the y interval
y_min = -5.5e6; 
y_max = -4.5e6; 

% Keep the data for the xy interval
idxS_y = spirent_pos_range(:, 2) >= y_min & spirent_pos_range(:, 2) <= y_max;
idxG_y = gnsssdr_pos_range(:, 2) >= y_min & gnsssdr_pos_range(:, 2) <= y_max;
spirent_pos_range_xy = spirent_pos_range(idxS_y, :);
gnsssdr_pos_range_xy = gnsssdr_pos_range(idxG_y, :);

%% POSITION XZ 
% Define the z interval
z_min = -4e6; 
z_max = -2e6; 

% Keep the data for the xz interval
idxS_z = spirent_pos_range(:, 3) >= z_min & spirent_pos_range(:, 3) <= z_max;
idxG_z = gnsssdr_pos_range(:, 3) >= z_min & gnsssdr_pos_range(:, 3) <= z_max;
spirent_pos_range_xz = spirent_pos_range(idxS_z, :);
gnsssdr_pos_range_xz = gnsssdr_pos_range(idxG_z, :);


%% PLOT: POSITION IN ECEF
figure
subplot(1,2,1)
hold on
scatter(spirent_pos_range_xy(:,1),spirent_pos_range_xy(:,2),50,'o');
scatter(gnsssdr_pos_range_xy(:,1),gnsssdr_pos_range_xy(:,2),8,'filled');
title('$\textbf{2D Trajectory in XY plane}$')
ylabel('$y_{ECEF}$ [m]')
xlabel('$x_{ECEF}$ [m]')
grid on
legend('Spirent', 'Gnss-sdr','Location','northwest');

subplot(1,2,2)
hold on
scatter(spirent_pos_range_xz(:,1),spirent_pos_range_xz(:,3),50,'o');
scatter(gnsssdr_pos_range_xz(:,1),gnsssdr_pos_range_xz(:,3),8,'filled');
title('$\textbf{2D Trajectory in XZ plane}$')
ylabel('$z_{ECEF}$ [m]')
xlabel('$x_{ECEF}$ [m]')
grid on
legend('Spirent', 'Gnss-sdr','Location','northwest');

% Obtain a polynomial that fits the data 
% you can adjust the order to get the smaller posible error 
spirent_pol_xy = polyfit(spirent_pos_range_xy(:,1),spirent_pos_range_xy(:,2),3);
gnsssdr_pol_xy = polyfit(gnsssdr_pos_range_xy(:,1),gnsssdr_pos_range_xy(:,2),3);

spirent_pol_xz = polyfit(spirent_pos_range_xz(:,1),spirent_pos_range_xz(:,3),3);
gnsssdr_pol_xz = polyfit(gnsssdr_pos_range_xz(:,1),gnsssdr_pos_range_xz(:,3),3);

x_points = linspace(x_min, x_max, 1000);

% Evaluate the ploynomials in the desired interval
spirent_values_xy = polyval(spirent_pol_xy, x_points);
gnsssdr_values_xy = polyval(gnsssdr_pol_xy, x_points);

spirent_values_xz = polyval(spirent_pol_xz, x_points);
gnsssdr_values_xz = polyval(gnsssdr_pol_xz, x_points);

% Compute the mean quadratic error
ecm_xy = sqrt(mean((spirent_values_xy - gnsssdr_values_xy).^2));
ecm_xz = sqrt(mean((spirent_values_xz - gnsssdr_values_xz).^2));