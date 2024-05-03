
function Position_plot(PVT)
% Aim: Creates a position plot
% INPUT  --> PVT: struct that contains position, velocity an time data from
%            GNSS-sdr
% OUTPUT --> figure

TransmitTime = PVT.TOW_at_current_symbol_ms- PVT.TOW_at_current_symbol_ms(1); 
Lon  = PVT.longitude - PVT.longitude(1);
Lat = PVT.latitude - PVT.latitude(1);
recPos = [PVT.pos_x; PVT.pos_y; PVT.pos_z] - [PVT.pos_x(1); PVT.pos_y(1); PVT.pos_z(1)];

figure
set(gcf, 'Position', get(0, 'Screensize'));
subplot(1,2,1)
scatter(Lat,Lon,15,TransmitTime*10^-3,'filled')

c = colorbar;
c.Label.String = 'TransmitTime [s]';
c.Label.Interpreter = 'latex';
set(c,'TickLabelInterpreter','latex')
title('$\textbf{Position latitude-longitude}$')
xlabel('Latitude [deg]')
ylabel('Longitude [deg]')
grid on

subplot(1,2,2)
scatter3(recPos(1,:),recPos(2,:),recPos(3,:),15,TransmitTime*10^-3,'filled')
title('$\textbf{ECEF Position x-y-z}$')
xlabel('x-axis [m]')
ylabel('y-axis [m]')
zlabel('z-axis [m]')
grid on

end

