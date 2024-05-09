
clc; clear; close all; 

% COMPARISON ORBITS
DRAG = load('Data\ModelComparison\orbitSimOutput_CubesatOrbit.mat');
NODRAG = load('Data\ModelComparison\orbitSimOutput_ISS_nodrag.mat');

pos_Drag = DRAG.mission.SimOutput.yout{1}.Values.Data;
pos_noDrag = NODRAG.mission.SimOutput.yout{1}.Values.Data;

t = linspace(0,minutes(DRAG.mission.Duration),length(pos_Drag));

figure
plot3(-pos_Drag(:,1),-pos_Drag(:,2),pos_Drag(:,3));
hold on
plot3(pos_noDrag(:,1),pos_noDrag(:,2),pos_noDrag(:,3));
grid on 
xlabel('XECEF(m)')
ylabel('ZECEF(m)')
zlabel('ZECEF(m)')
legend('Drag','No Drag')

figure
plot(-pos_Drag(:,1),-pos_Drag(:,2));
hold on
plot(pos_noDrag(:,1),pos_noDrag(:,2));
grid on
xlabel('XECEF(m)')
ylabel('YECEF(m)')
legend('Drag','No Drag')

errorx = -pos_Drag(:,1)-pos_noDrag(:,1);
errory = -pos_Drag(:,2)-pos_noDrag(:,2);

figure
plot(t,errorx*10^-3)
hold on
plot(t,errory*10^-3)
xlabel('t(min)')
ylabel('error(km)')
legend('X_error','Y_error')
