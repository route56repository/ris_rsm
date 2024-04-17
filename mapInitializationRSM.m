%% MATLAB SCRIPT THAT GENERATES SIMULATIONS FOR SCENARIO 2 AND SCENARIO 4
% clear all; clc; warning off;

%% GO TO INITIAL FOLDER
%mainFolder = 'G:\Mi unidad\I2R\VO_RSM';
mainFolder = projectFolder;

system_parameters;
% ORIENTACION ANGLES
theta_BS = pi/2;                    % BS Elevation (z-axis = pi/2)
phi_BS = pi/2;                      % BS Azimuth
angBS = [theta_BS,phi_BS];

theta_UE = pi/2;                    % UE Elevation
phi_UE = pi/2;                      % UE Azimuth
angUE = [theta_UE,phi_UE];

%% TX-RX PARAMETERS
Mtx = 4;                            % Antennas at the BS
BS = [40 80 10];                     % Location 1st Antenna at the BS

%Nrx = 3;                            % Antennas at the UE
UE = [0 0 1.5];                     % Location 1st antenna at the UE

%Na = 3;                             % Number of active antennas at RX
%% RIS PARAMETERS
%RIS = 2;                               % Nº of RIS
% Location 0: Special scenarios (2 RIS at left)
% Location 1: RSM_sims.m 50x50(1 RIS per banda/ 1 RIS oposada a la BS)
% Location 2: MAP_scenarios 100x100
loc = 1;
n = 20;
m = 80;

[RIS_i,ang_RIS] = RIS_parameters(RIS,loc,m);
%NRIS = 100;                            % Total number of RIS elements (50 or 100)
if(RIS==2)
    % If 2 RIS, the total number of RIS elements are distributed equally
    NRIS = [NRIS/2 NRIS/2];
end
Nz = 5;                                 % Nº of elements per row
Ny = NRIS./Nz;                          % Nº of elements per column

resultsFolder = [mainFolder,'\RESULTS\MAPS\'];
folderRIS = [resultsFolder,num2str(RIS),'RIS\',num2str(Mtx),'x2'];
Nr_total = sum(Ny)*Nz;
T = Nrx*(Nr_total+1);
strTest = [num2str(RIS),'RIS_',num2str(Nr_total),'Nr_',num2str(Nrx),'N_',num2str(dist_el),'d_el'];
RISmat = cell2mat(RIS_i.');
filename = [folderRIS,'\',strTest,'\info.mat'];
state_mkdir = mkdir(folderRIS,strTest);
pause(10);
% Save simulation information in .mat file
save(filename,'BS','UE','RISmat','angBS','angUE','ang_RIS','NRIS','Na','m','n')

% Compute the map information
mapComputationRSM;
