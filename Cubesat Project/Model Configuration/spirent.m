function spirent(mission)
% Create a txt with simulator output data

%% Process Data for Spirent
Data.t = mission.SimOutput.yout{6}.Values.Time; %[s]
Data.Lat = deg2rad(mission.SimOutput.yout{6}.Values.Data(:,1)); %[rad]
Data.Lon = deg2rad(mission.SimOutput.yout{6}.Values.Data(:,2)); %[rad]
Data.Alt = mission.SimOutput.yout{7}.Values.Data;   %[m]
Data.Vel = mission.SimOutput.yout{2}.Values.Data;   %[m/s]
Data.Acc = mission.SimOutput.yout{3}.Values.Data;   %[m/s^2]

T = table(Data.t, Data.Lat, Data.Lon , Data.Alt, Data.Vel(:,1), ...
    Data.Vel(:,2), Data.Vel(:,3), Data.Acc(:,1),Data.Acc(:,2),Data.Acc(:,3),...
    'VariableNames',{'t','lat','lon','alt','v1','v2','v3','a1','a2','a3'});
 
% Write the table to a CSV file
writetable(T,'Data/CubesatLocation.txt','WriteMode','overwrite');

end