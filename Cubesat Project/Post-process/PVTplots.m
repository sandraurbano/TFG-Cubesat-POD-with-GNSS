function PVTplots(PVT,spirent,Type,cubesat)
% Aim: Creates a position and velocity plot to compare Spirent and GNSS-SDR data
%
% INPUT  --> PVT: struct that contains position, velocity and time data from GNSS-sdr
%            spirent: struct that contains satellite data from Spirent
%            Type: string with the constellation type (e.g. 'GPS')
%            cubesat: struct that constains the simulation data and simulink output 
% OUTPUT --> figures: LonLat - HeightLat, PosXy-PosXZ and VelXY-VelXZ 


startTime = 0;
endTime = seconds(cubesat.Duration);

% Filter data to a specific constellation 
% Find the rows where Sat_Type = 'GPS'
indices_gps = strcmp(spirent.satData.Sat_type, Type);

% Identify the max number of GPS satellites
spirent.satData = structfun(@(x) x(indices_gps, :), spirent.satData, 'UniformOutput', false);


t_spirent = spirent.motion.Time_ms*10^-3;

% linspace(startTime,endTime,length(spirent.motion.Pos_X));
t_gnssSDR = PVT.TOW_at_current_symbol_ms*10^-3;

% linspace(startTime,endTime,length(PVT.pos_x));
recPos_gnssSDR = [PVT.pos_x; PVT.pos_y; PVT.pos_z];
velPos_gnssSDR = [PVT.vel_x; PVT.vel_y; PVT.vel_z];



figure
subplot(1,2,1)
hold on
scatter(rad2deg(spirent.motion.Lat),rad2deg(spirent.motion.Long),10,'*');
scatter(PVT.latitude,PVT.longitude,8,'filled');
title('$\textbf{LatLon}$')
ylabel('Lon [deg]')
xlabel('Lat [deg]')
grid on
legend('Spirent', 'Gnss SDR');

subplot(1,2,2)
hold on
scatter(rad2deg(spirent.motion.Lat),spirent.motion.Height,10,'*');
scatter(PVT.latitude,PVT.height,8,'filled');
title('$\textbf{Lat-height}$')
ylabel('Height [m]')
xlabel('Lat [deg]')
grid on
legend('Spirent', 'Gnss SDR');

figure
subplot(1,2,1)
hold on
scatter(spirent.motion.Vel_X,spirent.motion.Vel_Y,10,'*');
scatter(PVT.vel_x,PVT.vel_y,8,'filled');
title('$\textbf{Velocity XY}$')
ylabel('VelY [m/s]')
xlabel('VelX [m/s]')
grid on
legend('Spirent', 'Gnss SDR');

subplot(1,2,2)
hold on
scatter(spirent.motion.Vel_X,spirent.motion.Vel_Z,10,'*');
scatter(PVT.vel_x,PVT.vel_z,8,'filled');
title('$\textbf{Velocity XZ}$')
ylabel('VelZ [m/s]')
xlabel('VelX [m/s]')
grid on
legend('Spirent', 'Gnss SDR');

figure
subplot(1,2,1)
hold on
scatter(spirent.motion.Pos_X,spirent.motion.Pos_Y,10,'*');
scatter(PVT.pos_x,PVT.pos_y,8,'filled');
title('$\textbf{Position XY}$')
ylabel('PosY [m/s]')
xlabel('PosX [m/s]')
grid on
legend('Spirent', 'Gnss SDR');

subplot(1,2,2)
hold on
scatter(spirent.motion.Pos_X,spirent.motion.Pos_Z,10,'*');
scatter(PVT.pos_x,PVT.pos_z,8,'filled');
title('$\textbf{Position XZ}$')
ylabel('PosZ [m]')
xlabel('PosX [m]')
grid on
legend('Spirent', 'Gnss SDR');




end

