
% ORBIT MODEL COMPARISON
% This file compares the unperturbed and perturbed orbits and obtains the
% absolute and mean errors between them. 

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
QB50.Pert = load('Data\ModelComparison\SimOutput_QB50_pert_final.mat');
QB50.NoPert = load('Data\ModelComparison\SimOutput_QB50_nopert_final.mat');

% Define path for Results
results_path = fullfile('Results\ModelComparison\');

% Central body parameters
Earth.mu = 3.986*10^5;       % [km^3/s^2]
Earth.radius = 6378;         % [Km]

% Simulation time
Sim_duration = hours(QB50.Pert.mission.Duration);
t = linspace(0,Sim_duration,length(QB50.Pert.mission.SimOutput.tout));
tspan = [0 t(end)];

% Position
Pert_Pos = QB50.Pert.mission.SimOutput.yout{1}.Values.Data*10^-3; %[km]
NoPert_Pos = QB50.NoPert.mission.SimOutput.yout{1}.Values.Data*10^-3; %[km]

% Velocity
Pert_Vel = QB50.Pert.mission.SimOutput.yout{2}.Values.Data*10^-3;         %[km/s]
NoPert_Vel = QB50.NoPert.mission.SimOutput.yout{2}.Values.Data*10^-3;     %[km/s]

% Geodetic alt
Pert_alt = QB50.Pert.mission.SimOutput.yout{7}.Values.Data*10^-3; %[km]
NoPert_alt = QB50.NoPert.mission.SimOutput.yout{7}.Values.Data*10^-3; %[km]

% Period 1 Orbit
P = 2*pi*sqrt((QB50.Pert.mission.CubeSat.SemiMajorAxis*10^-3)^3/Earth.mu)/3600; %[h]
idx_P = find(abs(P-t) < 0.00005);
t_period = t(1:idx_P);
tspan_period = [0 t_period(end)];


%% 3D TRAJECTORY 1 ORBIT

% Creating/Plotting Spherical Earth
% [xEarth, yEarth, zEarth] = sphere(50);
% surf(Earth.radius*xEarth,Earth.radius*yEarth,Earth.radius*zEarth);
% colormap sky

% Plotting Trajectory
figure
plot3(NoPert_Pos(1:idx_P,1), NoPert_Pos(1:idx_P,2), NoPert_Pos(1:idx_P,3),'LineWidth',1);
hold on;
plot3(Pert_Pos(1:idx_P,1), Pert_Pos(1:idx_P,2), Pert_Pos(1:idx_P,3), '--','LineWidth',1);
title ('3D Trayectory for one period');
xlabel('$x_{ECEF}$ [km]'); 
ylabel('$y_{ECEF}$ [km]');
zlabel('$z_{ECEF}$ [km]');
legend('No Pert','Pert','Location','eastoutside');
grid minor;
axis equal;
hold off;


% 3D orbit plot 1 day
figure
plot3(NoPert_Pos(:,1), NoPert_Pos(:,2), NoPert_Pos(:,3),'LineWidth',1);
hold on
plot3(Pert_Pos(:,1), Pert_Pos(:,2), Pert_Pos(:,3), '--','LineWidth',1);
title("3D Trayectory for one day");
xlabel('$x_{ECEF}$ [km]'); 
ylabel('$y_{ECEF}$ [km]');
zlabel('$z_{ECEF}$ [km]');
legend('No Pert','Pert','Location','eastoutside');
grid minor;
axis equal;
hold off;



%% 2D TRAJECTORIES

figure
sgtitle("2D orbital trajectories");
subplot(1,3,1)
plot(NoPert_Pos(:,1), NoPert_Pos(:,2), 'LineWidth',1);
hold on
plot(Pert_Pos(:,1), Pert_Pos(:,2), '--','LineWidth',1);
xlabel('$x_{ECEF}$ [km]'); 
ylabel('$y_{ECEF}$ [km]');
legend('No Pert','Pert','Location','northeast');
grid on

subplot(1,3,2)
plot(NoPert_Pos(:,1), NoPert_Pos(:,3),'LineWidth',1);
hold on
plot(Pert_Pos(:,1), Pert_Pos(:,3), '--','LineWidth',1);
xlabel('$x_{ECEF}$ [km]'); 
ylabel('$z_{ECEF}$ [km]');
legend('No Pert','Pert','Location','northeast');
grid on

subplot(1,3,3)
plot(NoPert_Pos(:,2), NoPert_Pos(:,3),'LineWidth',1);
hold on
plot(Pert_Pos(:,2), Pert_Pos(:,3), '--','LineWidth',1);
xlabel('$y_{ECEF}$ [km]'); 
ylabel('$z_{ECEF}$ [km]');
legend('No Pert','Pert','Location','northeast');
grid on


%% LAT, LON, ALT VS TIME
figure
hold on
plot(t,NoPert_alt)
plot(t,Pert_alt,'--')
xlabel('t [h]')
xlim(tspan) 
xticks(0:4:24)
ylabel('$\xi$ [KJ/kg]')
grid on
title("Altitude variation")
legend('No Pert','Pert','Location','northwest')


figure
hold on
plot(t,Pert_alt-NoPert_alt)
xlabel('t [h]')
xlim(tspan)
xticks(0:4:24)
ylabel('$\Delta h$ [km]')
grid on
title('Altitude error')


%% POSITION ERROR VS TIME

% 1 period
error.pos.period.absX = Pert_Pos(1:idx_P,1) - NoPert_Pos(1:idx_P,1);
error.pos.period.absY = Pert_Pos(1:idx_P,2) - NoPert_Pos(1:idx_P,2);
error.pos.period.absZ = Pert_Pos(1:idx_P,3) - NoPert_Pos(1:idx_P,3);

error.pos.period.relX = mean(abs(error.pos.period.absX./NoPert_Pos(1:idx_P,1)))*100; % [%error]
error.pos.period.relY = mean(abs(error.pos.period.absY./NoPert_Pos(1:idx_P,2)))*100; % [%error]
error.pos.period.relZ = mean(abs(error.pos.period.absZ./NoPert_Pos(1:idx_P,3)))*100; % [%error]

% 24 hours
error.pos.day.absX = Pert_Pos(:,1) - NoPert_Pos(:,1);
error.pos.day.absY = Pert_Pos(:,2) - NoPert_Pos(:,2);
error.pos.day.absZ = Pert_Pos(:,3) - NoPert_Pos(:,3);

error.pos.day.relX = mean(abs(error.pos.day.absX./NoPert_Pos(:,1)))*100; % [%error]
error.pos.day.relY = mean(abs(error.pos.day.absY./NoPert_Pos(:,2)))*100; % [%error]
error.pos.day.relZ = mean(abs(error.pos.day.absZ./NoPert_Pos(:,3)))*100; % [%error]

Pos_err = table([error.pos.period.relX; error.pos.day.relX],...
                    [error.pos.period.relY; error.pos.day.relY],...
                    [error.pos.period.relZ; error.pos.day.relZ],...
                    'VariableNames',{'X error (%)','Y error (%)','Z error (%)'},...
                    'RowNames',{'One orbit','One day'});

disp('Position error')
disp(Pos_err)

figure
hold on
plot(t,error.pos.day.absX)
plot(t,error.pos.day.absY)
plot(t,error.pos.day.absZ)
xlabel('t [h]')
xlim(tspan)
xticks(0:4:24)
ylabel('$\Delta r$ [km]')
grid on
title("Position Error")
legend('$\Delta x$','$\Delta y$','$\Delta z$','Location','northwest')
filename = fullfile(results_path, 'OrbitPositionError.png');
%saveas(gcf, filename);



%% VELOCITY ERROR VS TIME

% 1 period
error.vel.period.absX = Pert_Vel(1:idx_P,1) - NoPert_Vel(1:idx_P,1);
error.vel.period.absY = Pert_Vel(1:idx_P,2) - NoPert_Vel(1:idx_P,2);
error.vel.period.absZ = Pert_Vel(1:idx_P,3) - NoPert_Vel(1:idx_P,3);

error.vel.period.relX = mean(abs(error.vel.period.absX./NoPert_Vel(1:idx_P,1)))*100; % [%error]
error.vel.period.relY = mean(abs(error.vel.period.absY./NoPert_Vel(1:idx_P,2)))*100; % [%error]
error.vel.period.relZ = mean(abs(error.vel.period.absZ./NoPert_Vel(1:idx_P,3)))*100; % [%error]

% 24 hours
error.vel.day.absX = Pert_Vel(:,1) - NoPert_Vel(:,1);
error.vel.day.absY = Pert_Vel(:,2) - NoPert_Vel(:,2);
error.vel.day.absZ = Pert_Vel(:,3) - NoPert_Vel(:,3);

error.vel.day.relX = mean(abs(error.vel.day.absX./NoPert_Vel(:,1)))*100; % [%error]
error.vel.day.relY = mean(abs(error.vel.day.absY./NoPert_Vel(:,2)))*100; % [%error]
error.vel.day.relZ = mean(abs(error.vel.day.absZ./NoPert_Vel(:,3)))*100; % [%error]

Vel_err = table([error.vel.period.relX; error.vel.day.relX],...
                    [error.vel.period.relY; error.vel.day.relY],...
                    [error.vel.period.relZ; error.vel.day.relZ],...
                    'VariableNames',{'X error (%)','Y error (%)','Z error (%)'},...
                    'RowNames',{'One orbit','One day'});

disp('Velocity error')
disp(Vel_err)

figure
hold on
plot(t,error.vel.day.absX)
plot(t,error.vel.day.absY)
plot(t,error.vel.day.absZ)
xlabel('t [h]')
xlim(tspan)
xticks(0:4:24)
ylabel('$\Delta\dot{r}$ [km/s]')
yticks(-5*10^-2:10^-2:5*10^-2)
grid on
title("Velocity Error")
legend('$\Delta x$','$\Delta y$','$\Delta z$','Location','northwest')
filename = fullfile(results_path, 'OrbitVelocityError.png');
%saveas(gcf, filename);

%% SPECIFIC ENERGY VS TIME

r_norm_pert = zeros(length(t),1);
r_norm_nopert = zeros(length(t),1);
v_norm_pert = zeros(length(t),1);
v_norm_nopert = zeros(length(t),1);


for i=1:length(t)
    r_norm_pert(i) = norm(Pert_Pos(i,1:3));
    r_norm_nopert(i) = norm(NoPert_Pos(i,1:3));
    v_norm_pert(i) = norm(Pert_Vel(i,1:3));
    v_norm_nopert(i) = norm(NoPert_Vel(i,1:3));
end 

Especific_pert = v_norm_pert.^2/2 - Earth.mu./r_norm_pert;
Especific_nopert = v_norm_nopert.^2/2 - Earth.mu./r_norm_nopert;

figure
hold on
plot(t,Especific_nopert)
plot(t,Especific_pert,'--')
xlabel('t [h]')
xlim(tspan) 
xticks(0:4:24)
ylabel('$\xi$ [KJ/kg]')
grid on
title("Specific Energy error")
legend('No Pert','Pert','Location','northwest')
% filename = fullfile(results_path, 'OrbitPositionError.png');
%saveas(gcf, filename);

figure
hold on
plot(t,Especific_nopert-Especific_pert)
xlabel('t [h]')
xlim(tspan)
xticks(0:4:24)
ylabel('$\Delta\xi$ [kJ/kg]')
grid on
title("Specific Energy error")


%% ORBITAL ELEMENTS VS TIME

% Compute osculating orbital elements

% Define orbital elements
% [No pert, Pert]
a_osc = zeros(length(t),2);
e_osc = zeros(length(t),2);
i_osc = zeros(length(t),2);
omega_osc = zeros(length(t),2);
w_osc = zeros(length(t),2);
nu_osc = zeros(length(t),2);

% Convert cartesian coordinates to osculating orbital elements
for k = 1:length(t)
    [a_osc(k,1),e_osc(k,1),i_osc(k,1),omega_osc(k,1),w_osc(k,1),nu_osc(k,1)] = cart2orbital(NoPert_Pos(k,:),NoPert_Vel(k,:),Earth.mu);
    [a_osc(k,2),e_osc(k,2),i_osc(k,2),omega_osc(k,2),w_osc(k,2),nu_osc(k,2)] = cart2orbital(Pert_Pos(k,:),Pert_Vel(k,:),Earth.mu);
end 

% Plot osculating orbital elements in 1 orbit 
% figure
% set(gcf, 'WindowState', 'maximized');
% 
% subplot(3,2,1); plot(t_period, a_osc(1:idx_P,1),t_period, a_osc(1:idx_P,2),'--'); ...
%     ylabel('a [km]');
%     xlabel('t [h]'); 
%     title('Semi-mayor axis'); 
%     xlim(tspan_period);
% 
% subplot(3,2,2); plot(t_period, e_osc(1:idx_P,1),t_period, e_osc(1:idx_P,2),'--'); ...
%     ylabel('e [-]');
%     xlabel('t [h]'); 
%     title('Eccentricity'); 
%     xlim(tspan_period);
% 
% subplot(3,2,3); plot(t_period, i_osc(1:idx_P,1),t_period, i_osc(1:idx_P,2),'--'); ...
%     ylabel('i [deg]');
%     xlabel('t [h]'); 
%     title('Inclination'); 
%     xlim(tspan_period);
% 
% subplot(3,2,4); plot(t_period, omega_osc(1:idx_P,1),t_period, omega_osc(1:idx_P,2),'--');...
%     ylabel('$\Omega$ [deg]');
%     xlabel('t [h]'); 
%     title('Longitude of ascending node'); 
%     xlim(tspan_period);
% 
% subplot(3,2,5); plot(t_period, w_osc(1:idx_P,1),t_period, w_osc(1:idx_P,2),'--');...
%     ylabel('$\omega$ [deg]');
%     xlabel('t [h]'); 
%     title('Argument of periapsis');
%     xlim(tspan_period);
% 
% subplot(3,2,6); plot(t_period, nu_osc(1:idx_P,1),t_period, nu_osc(1:idx_P,2),'--'); ...
%     ylabel('$\nu$ [deg]');
%     xlabel('t [h]'); 
%     title('True anomaly');
%     xlim(tspan_period);









