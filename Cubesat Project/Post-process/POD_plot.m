function POD_plot(PVT,spirent,Type,cubesat)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

startTime = 0;
endTime = seconds(cubesat.Duration);

% Filter data to a specific constellation 
% Find the rows where Sat_Type = 'GPS'
indices_gps = strcmp(spirent.satData.Sat_type, Type);

% Identify the max number of GPS satellites
spirent.satData = structfun(@(x) x(indices_gps, :), spirent.satData, 'UniformOutput', false);

t_spirent = linspace(startTime,endTime,length(spirent.motion.Pos_X));

t_gnssSDR = linspace(startTime,endTime,length(PVT.pos_x));
recPos_gnssSDR = [PVT.pos_x; PVT.pos_y; PVT.pos_z];
velPos_gnssSDR = [PVT.vel_x; PVT.vel_y; PVT.vel_z];


figure
set(gcf, 'Position', get(0, 'Screensize'));
sgtitle('Precise orbit determination');

% Discrete Time Scatter plot
subplot(3,1,1)
plot(t_gnssSDR,recPos_gnssSDR(1,:));
hold on
plot(t_spirent,spirent.motion.Pos_X)
title('$\textbf{X-ECEF}$')
xlabel('Time [s]')
ylabel('Position [m]')
grid on
legend('Gnss SDR','Spirent', 'Location','southeast','orientation','horizontal');

subplot(3,1,2)
plot(t_gnssSDR,recPos_gnssSDR(2,:));
hold on
plot(t_spirent,spirent.motion.Pos_Y)
title('$\textbf{Y-ECEF}$')
xlabel('Time [s]')
ylabel('Position [m]')
grid on

subplot(3,1,3)
plot(t_gnssSDR,recPos_gnssSDR(3,:));
hold on
plot(t_spirent,spirent.motion.Pos_Z)
title('$\textbf{Z-ECEF}$')
xlabel('Time [s]')
ylabel('Position [m]')
grid on


figure
set(gcf, 'Position', get(0, 'Screensize'));
sgtitle('Precise orbit determination - velocity ');

% Discrete Time Scatter plot
subplot(3,1,1)
plot(t_gnssSDR,velPos_gnssSDR(1,:));
hold on
plot(t_spirent,spirent.motion.Vel_X)
title('$\textbf{VX-ECEF}$')
xlabel('Time [s]')
ylabel('Velocity [m/s]')
grid on
legend('Gnss SDR','Spirent', 'Location','southeast','orientation','horizontal');

subplot(3,1,2)
plot(t_gnssSDR,velPos_gnssSDR(2,:));
hold on
plot(t_spirent,spirent.motion.Vel_Y)
title('$\textbf{VY-ECEF}$')
xlabel('Time [s]')
ylabel('Velocity [m/s]')
grid on

subplot(3,1,3)
plot(t_gnssSDR,velPos_gnssSDR(3,:));
hold on
plot(t_spirent,spirent.motion.Vel_Z)
title('$\textbf{VZ-ECEF}$')
xlabel('Time [s]')
ylabel('Velocity [m/s]')
grid on


figure
set(gcf, 'Position', get(0, 'Screensize'));

% Discrete Time Scatter plot
subplot(3,1,1)
plot(t_gnssSDR,PVT.latitude);
hold on
plot(t_spirent,spirent.motion.Lat)
title('$\textbf{Latitude}$')
xlabel('Time [s]')
ylabel('Lat [deg]')
grid on
legend('Gnss SDR','Spirent', 'Location','southeast','orientation','horizontal');

subplot(3,1,2)
plot(t_gnssSDR,PVT.longitude);
hold on
plot(t_spirent,spirent.motion.Long)
title('$\textbf{Longitude}$')
xlabel('Time [s]')
ylabel('Lon [deg]')
grid on

subplot(3,1,3)
plot(t_gnssSDR,PVT.height);
hold on
plot(t_spirent,spirent.motion.Height)
title('$\textbf{Height}$')
xlabel('Time [s]')
ylabel('Height [m]')
grid on



end