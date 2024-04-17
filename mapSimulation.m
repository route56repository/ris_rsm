%% MATLAB SCRIPT THAT GENERATES SIMULATIONS FOR MAPPING SCENARIO RSM_RIS
% RSM tranmission with 4-PSK spatial and modulation 
% symbols and Na = 2

% clear all; clc; warning off;

%% GO TO INITIAL FOLDER
currentFolder = 'G:\Mi unidad\I2R\VO_RSM';
cd(currentFolder);

%% TX-RX PARAMETERS
Mtx = 4;                            % Antennas at the BS
BS = [50 50 3];                     % Location 1st Antenna at the BS

Nrx = 2;                            % Antennas at the UE
UE = [0 0 1.5];                     % Location 1st antenna at the UE

% ORIENTACION ANGLES
theta_BS = pi/2;                    % BS Elevation (z-axis = pi/2)
phi_BS = pi/2;                      % BS Azimuth
angBS = [theta_BS,phi_BS];

theta_UE = pi/2;                    % UE Elevation
phi_UE = -pi/2;                      % UE Azimuth
angUE = [theta_UE,phi_UE];

%% RIS PARAMETERS
RIS = 1;                                % Nº of RIS
loc = 2;                                % 1 RIS location for scenario 2 and 4
[RIS_i,ang_RIS] = RIS_parameters(RIS,loc);
NRIS = 60;                             % Total number of RIS elements (50 or 100)
if(RIS==2)
    % If 2 RIS, the total number of RIS elements are distributed equally
    NRIS = [NRIS/2 NRIS/2];
end
Nz = 5;                                 % Nº of elements per row
Ny = NRIS./Nz;                          % Nº of elements per column

% Plot simplified top view of simulation setup (BS and RIS only)
% plotCOORD(angBS,angUE, ang_RIS,BS,UE,RIS_i);
% title('Top view simulation setup');

%% TRANSMISSION MODE
mode = 'RSM';
%mode = 'TxBF';

foldername = [currentFolder,'\',mode,'\MAPS'];
cd(foldername);
strRIS = [num2str(RIS),'RIS'];
if(not(isfolder(strRIS)))    
    mkdir(strRIS);
end
cd(strRIS)
test = sum(Ny)*Nz;
strTest = [num2str(RIS),'test',num2str(test),'_',num2str(Nrx)];
if(not(isfolder(strTest)))    
    mkdir(strTest);
else
    disp('THIS TEST ALREADY EXISTS');    
end
cd(strTest)
RISmat = cell2mat(RIS_i.');

% Save simulation information in .mat file
save('info.mat','BS','UE','RISmat','angBS','angUE','ang_RIS','NRIS','mode')

% Compute the map information
createMap;

% Plot the information calculated
plotMAP;
