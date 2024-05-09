function spirent(mission,name,Resultspath)
% Create a txt with simulator output data

%% Process Data for Spirent
Data.t = mission.SimOutput.yout{6}.Values.Time; %[s]
Data.Lat = deg2rad(mission.SimOutput.yout{6}.Values.Data(:,1)); %[rad]
Data.Lon = deg2rad(mission.SimOutput.yout{6}.Values.Data(:,2)); %[rad]
Data.Alt = mission.SimOutput.yout{7}.Values.Data;   %[m]
Data.Alt = mission.SimOutput.yout{7}.Values.Data;   %[m]
Data.Vel = mission.SimOutput.yout{2}.Values.Data;   %[m/s]
Data.PosECEF = mission.SimOutput.yout{1}.Values.Data;%[m]

MOT = repmat({'MOT'}, 1, length(Data.t));
V1 = repmat({'v1_M1'}, 1, length(Data.t));

T = table(Data.t,MOT', V1', Data.PosECEF(:,1), Data.PosECEF(:,2) , Data.PosECEF(:,3),...
    Data.Vel(:,1), Data.Vel(:,2), Data.Vel(:,3));

% Write the table to a txt file
file = [Resultspath 'Cubesat_PosECEF_Vel_' name '.txt'];
writetable(T,file,'WriteMode','overwrite');

end