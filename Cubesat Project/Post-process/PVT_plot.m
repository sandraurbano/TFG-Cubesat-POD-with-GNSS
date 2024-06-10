function PVT_plot(PVT,spirent,Type,cubesat,results_path,data_path)
% Aim: Creates a position and velocity plot to compare Spirent and GNSS-SDR data
%
% INPUT  --> PVT: struct that contains position, velocity and time data from GNSS-sdr
%            spirent: struct that contains satellite data from Spirent
%            Type: string with the constellation type (e.g. 'GPS')
%            cubesat: struct that constains the simulation data and simulink output
%            results_path: string with the path of the results folder
% OUTPUT --> figures: LonLat - HeightLat, PosXy-PosXZ and VelXY-VelXZ 

startTime = 0;
endTime = seconds(cubesat.Duration);

% Filter data to a specific constellation 
% Find the rows where Sat_Type = 'GPS'
indices_gps = strcmp(spirent.satData.Sat_type, Type);

% Identify the max number of GPS satellites
spirent.satData = structfun(@(x) x(indices_gps, :), spirent.satData, 'UniformOutput', false);

% Export position data
pos_spirent = table(spirent.motion.Pos_X,spirent.motion.Pos_Y,spirent.motion.Pos_Z,'VariableNames',{'x_ecef', 'y_ecef', 'z_ecef'});
pos_gnsssdr = table(PVT.pos_x', PVT.pos_y', PVT.pos_z','VariableNames',{'x_ecef', 'y_ecef', 'z_ecef'});
writetable(pos_spirent, fullfile(data_path,'pos_spirent.csv'));
writetable(pos_gnsssdr,fullfile(data_path,'pos_gnsssdr.csv'));

%% PLOT: GEODETIC COORD
figure
set(gcf,'WindowState','maximized');
sgtitle('Geodetic position');

subplot(1,2,1)
hold on
scatter(rad2deg(spirent.motion.Lat),rad2deg(spirent.motion.Long),10,'*');
scatter(PVT.latitude,PVT.longitude,8,'filled');
title('$\textbf{Latitude vs Longitude}$')
ylabel('Lon [deg]')
xlabel('Lat [deg]')
grid on
legend('Spirent', 'Gnss-sdr','Location','northwest');

subplot(1,2,2)
hold on
scatter(rad2deg(spirent.motion.Lat),spirent.motion.Height,10,'*');
scatter(PVT.latitude,PVT.height,8,'filled');
title('$\textbf{Latitude vs height}$')
ylabel('Height [m]')
xlabel('Lat [deg]')
grid on
legend('Spirent', 'Gnss-sdr','Location','northwest');

filename = fullfile(results_path, 'pos_geodetic.png');
saveas(gcf, filename);


%% PLOT: POSITION IN ECEF
figure
set(gcf,'WindowState','maximized');
sgtitle('Position in ECEF');

subplot(1,2,1)
hold on
scatter(spirent.motion.Pos_X,spirent.motion.Pos_Y,10,'*');
scatter(PVT.pos_x,PVT.pos_y,8,'filled');
title('$\textbf{2D Trajectory in XY plane}$')
ylabel('$y_{ECEF}$ [m]')
xlabel('$x_{ECEF}$ [m]')
grid on
legend('Spirent', 'Gnss-sdr','Location','northwest');

subplot(1,2,2)
hold on
scatter(spirent.motion.Pos_X,spirent.motion.Pos_Z,10,'*');
scatter(PVT.pos_x,PVT.pos_z,8,'filled');
title('$\textbf{2D Trajectory in XZ plane}$')
ylabel('$z_{ECEF}$ [m]')
xlabel('$x_{ECEF}$ [m]')
grid on
legend('Spirent', 'Gnss-sdr','Location','northwest');

filename = fullfile(results_path, 'pos_ecef.png');
saveas(gcf, filename);


%% PLOT: VELOCITY IN ECEF
figure
set(gcf,'WindowState','maximized');
sgtitle('Velocity in ECEF');

subplot(1,2,1)
hold on
scatter(spirent.motion.Vel_X,spirent.motion.Vel_Y,10,'*');
scatter(PVT.vel_x,PVT.vel_y,8,'filled');
title('$\textbf{Velocity XY}$')
ylabel('$\dot{y}_{ECEF}$ [m/s]')
xlabel('$\dot{x}_{ECEF}$ [m/s]')
grid on
legend('Spirent', 'Gnss-sdr','Location','northwest');

subplot(1,2,2)
hold on
scatter(spirent.motion.Vel_X,spirent.motion.Vel_Z,10,'*');
scatter(PVT.vel_x,PVT.vel_z,8,'filled');
title('$\textbf{Velocity XZ}$')
ylabel('$\dot{z}_{ECEF}$ [m/s]')
xlabel('$\dot{x}_{ECEF}$ [m/s]')
grid on
legend('Spirent', 'Gnss-sdr','Location','northwest');

filename = fullfile(results_path, 'vel_ecef.png');
saveas(gcf, filename);


%% PVT GNSS-SDR

TransmitTime = linspace(startTime,endTime,length(PVT.pos_x));

figure
set(gcf,'WindowState','maximized');
sgtitle('GNSS-SDR position')

% Geodetic coordinates
subplot(1,2,1)
hold on
scatter(PVT.longitude,PVT.latitude,15,TransmitTime,'filled')
c = colorbar;
c.Label.String = 'TransmitTime [s]';
c.Label.Interpreter = 'latex';
set(c,'TickLabelInterpreter','latex')
title('$\textbf{Position latitude-longitude}$')
xlabel('Lat [deg]')
ylabel('Lon [deg]')
grid on

% Cartesian coordinates
subplot(1,2,2)
scatter3(PVT.pos_x,PVT.pos_y,PVT.pos_z,15,TransmitTime,'filled')
title('$\textbf{3D Trajectory}$')
xlabel('$x_{ECEF}$ [m]')
ylabel('$y_{ECEF}$ [m]')
zlabel('$z_{ECEF}$ [m]')
grid on

filename = fullfile(results_path, 'gnsssdr_pos.png');
saveas(gcf, filename);

end

