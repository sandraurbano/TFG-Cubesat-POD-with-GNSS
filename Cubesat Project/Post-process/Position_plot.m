function Position_plot(PVT,cubesat,results_path)
% Aim: Creates a position plot using GNSS-SDR data
%
% INPUT  --> PVT: struct that contains position, velocity and time data from GNSS-sdr
%            cubesat: struct that constains the simulation data and simulink output 
%            results_path: string with the path of the results folder
% OUTPUT --> figure: Lat-Lon and 3D Position in ECEF

startTime = 0;
endTime = seconds(cubesat.Duration);

Lon  = PVT.longitude;
Lat = PVT.latitude;
recPos = [PVT.pos_x; PVT.pos_y; PVT.pos_z];
TransmitTime = linspace(startTime,endTime,length(Lon));

figure
set(gcf,'WindowState','maximized');
subplot(1,2,1)
hold on
scatter(Lat,Lon,15,TransmitTime,'filled')

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

filename = fullfile(results_path, 'gnsssdr_position.png');
saveas(gcf, filename);


end

