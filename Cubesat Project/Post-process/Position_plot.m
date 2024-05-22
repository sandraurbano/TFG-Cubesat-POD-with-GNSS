function Position_plot(PVT,cubesat,spirent)
% Aim: Creates a position plot using GNSS-SDR data
%
% INPUT  --> PVT: struct that contains position, velocity and time data from GNSS-sdr
%            cubesat: struct that constains the simulation data and simulink output 
%            spirent: struct that contains satellite data from Spirent
% OUTPUT --> figure: Lat-Lon and 3D Position in ECEF

startTime = 0;
endTime = seconds(cubesat.Duration);

Lon  = PVT.longitude;
Lat = PVT.latitude;
recPos = [PVT.pos_x; PVT.pos_y; PVT.pos_z];
TransmitTime = linspace(startTime,endTime,length(Lon));
%TransmitTime = PVT.TOW_at_current_symbol_ms*10^-3;


figure
% set(gcf, 'Position', get(0, 'Screensize'));
subplot(1,2,1)
hold on
scatter(Lat,Lon,15,'filled')
scatter(spirent.motion.Lat,spirent.motion.Long,15,'o')

c = colorbar;
c.Label.String = 'TransmitTime [s]';
c.Label.Interpreter = 'latex';
set(c,'TickLabelInterpreter','latex')
title('$\textbf{Position latitude-longitude}$')
xlabel('Latitude [deg]')
ylabel('Longitude [deg]')
grid on

subplot(1,2,2)
scatter3(recPos(1,:),recPos(2,:),recPos(3,:),15,TransmitTime,'filled')
title('$\textbf{ECEF Position x-y-z}$')
xlabel('x-axis [m]')
ylabel('y-axis [m]')
zlabel('z-axis [m]')
grid on




end

