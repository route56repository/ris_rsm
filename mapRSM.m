%% MATLAB SCRIPT THAT GENERATES SIMULATIONS FOR MAPPING SCENARIO
% Scenario 2 - RSM tranmission with 4-PSK spatial and modulation 
% symbols and Na = 2

clear all; clc; warning off;

%% GO TO INITIAL FOLDER
% mainFolder = ' ';
mainFolder = pwd;
%% TX-RX PARAMETERS
Mtx = 4;                            % Antennas at the BS
BS = [25 50 10];                     % Location 1st Antenna at the BS

Nrx = 3;                            % Antennas at the UE
UE = [0 0 1.5];                     % Location 1st antenna at the UE

Na = 3;                             % Number of active antennas at RX

% ORIENTACION ANGLES
theta_BS = pi/2;                    % BS Elevation (z-axis = pi/2)
phi_BS = pi/2;                      % BS Azimuth
angBS = [theta_BS,phi_BS];

theta_UE = 0;                    % UE Elevation
phi_UE = pi/4;                      % UE Azimuth
angUE = [theta_UE,phi_UE];

%% RIS PARAMETERS
RIS = 2;                               % Nº of RIS
% Location 0: Special scenarios (2 RIS at left)
% Location 1: RSM_sims.m 50x50(1 RIS per banda/ 1 RIS oposada a la BS)
% Location 2: MAP_scenarios 100x100
loc = 1;                               
[RIS_i,ang_RIS] = RIS_parameters(RIS,loc);
NRIS = 100;                            % Total number of RIS elements (50 or 100)
if(RIS==2)
    % If 2 RIS, the total number of RIS elements are distributed equally
    NRIS = [NRIS/2 NRIS/2];
end
Nz = 5;                                 % Nº of elements per row
Ny = NRIS./Nz;                          % Nº of elements per column

% Plot simplified top view of simulation setup (BS and RIS only)
% plotCOORD(angBS,angUE, ang_RIS,BS,UE,RIS_i);
% title('Top view simulation setup');

% Create folder if needed
resultsFolder = [mainFolder,'\RSM\MAPS\'];
folderRIS = [resultsFolder,num2str(RIS),'RIS'];
Nr_total = sum(Ny)*Nz;
strTest = [num2str(RIS),'RIS_',num2str(Nr_total),'Nr_',num2str(Nrx),'N',num2str(Na),'Na'];
RISmat = cell2mat(RIS_i.');
filename = [folderRIS,'\',strTest,'\info.mat'];
state_mkdir = mkdir(folderRIS,strTest);
pause(5);
% Save simulation information in .mat file
save(filename,'BS','UE','RISmat','angBS','angUE','ang_RIS','NRIS','Na')

% Compute the map information
mapComputationRSM;

% Plot the information calculated
plotMAP_RSM;
