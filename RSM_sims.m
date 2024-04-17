%% MATLAB SCRIPT THAT GENERATES SIMULATIONS FOR RSM_RIS
% RSM transmission with 4-PSK spatial and modulation symbols and Na = 2
clear all; clc; warning off;
randn('seed',1);
rand('seed',1);
% f1 = figure('Name','Algoritme 2.2 (5-50)','NumberTitle','off');
% f2 = figure('Name','Algoritme 2.2 (55-100)','NumberTitle','off');
% f3 = figure('Name','Algoritme 2.2 (105-150)','NumberTitle','off');
% f4 = figure('Name','Algoritme 2.2 (155-200)','NumberTitle','off');

tic;
%% LOAD SYSTEM PARAMETERS
system_parameters;

%% TX-RX PARAMETERS
Mtx = 10;                            % Antennas at the BS
BS = [40 80 10];                    % Location 1st Antenna at the BS

Nrx = 3;                            % Antennas at the UE3
UE = [40 30 1.5];                   % Location 1st antenna at the UE

% ORIENTATION ANGLES
theta_BS = pi/2;                    % BS Elevation (z-axis = pi/2)
phi_BS = pi/2;                      % BS Azimuth
angBS = [theta_BS,phi_BS];

theta_UE = pi/2;                    % UE Elevation
phi_UE = pi/2;                      % UE Azimuth
angUE = [theta_UE,phi_UE];

% NUMBER OF ACTIVE ANTENNAS AT THE RECEIVER
Na = 3;
if Nrx < Na
    quit;
end
%% DIRECT CHANNEL - Hbu
% All possible antenna coordinates at the BS and UE
[coord_tx, coord_rx] = COORD_TXRX(Mtx,Nrx,BS,UE,lam,angBS,angUE);
% Calculate direct channel
[Hbu_og,beta_bu] = NF_bu(coord_tx,coord_rx);
Hbu_og = Hbu_og./beta_bu;

%% RIS PARAMETERS
RIS = 2;                                % Nº of RIS
loc = 1;                                % Location for Scenario 1
m = 80;
n = 20;
[RIS_i,ang_RIS] = RIS_parameters(RIS,loc,m);
Ny = 1;                                 % Nº of elements per column
if(RIS==2)
    Ny = [1,1];
end
Nz = 5;                                 % Nº of elements per row

% Plot top view of simulation setup
% figure;
% plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS_i,1);

% Nrx = Na !
Rs = 2^Nrx/(2^Nrx-1)*(1/Nrx*eye(Nrx)+1/Nrx);
R12inv = inv(chol(Rs).');

Hbu_og = R12inv*Hbu_og;

Hbu = Hbu_og.*beta_bu;
alpha_og = pot(Hbu);

for s = 1:(500/RIS)
    Nris(s) = Nz*sum(Ny);                            % Total number of RIS elements
    for r = 1:RIS
        % For each RIS
        % Calculate all RIS element locations
        coord_ris = COORD_RIS(RIS_i{r},Nz,Ny(r),lam,ang_RIS{r});
        dbr = norm(coord_ris(1,:)-coord_tx(1,:)); % Minimum distance BS - RIS
        dru = norm(coord_rx(1,:)-coord_ris(1,:)); % Minimum distance RIS - UE

        % Calculate RIS-UE channel and BS-RIS channel
        [Hbr{r},Hru_aux,s_path] = NF_Hc(Nz,Ny(r),coord_tx,coord_rx,coord_ris,ang_RIS{r});
        Hbr{r} = Hbr{r}*s_path;
        Hru{r} = Hru_aux;
    end
    matHbr = cell2mat(Hbr.')./beta_bu;
    %matHbr = cell2mat(Hbr.');
    matHru = cell2mat(Hru);    
    matHru = R12inv*matHru;

    random_phases = rand(Nris(s),1)*2*pi;    % Initial random RIS phases

    disp(['NRIS ', num2str(Nris(s))]);
    
    if(Nrx>Na)
        %% RAS ALGORITHM: Na = 2
        [Hbu, Ht_rsm,it_rsm(s),ARA] = RAS(Hbu_og,matHbr,matHru,random_phases,Na);
        Ht_no = Hbu + matHru(ARA,:)*diag(exp(1i*random_phases))*matHbr;
        disp('RAS OK');
    else
        fases_no = diag(exp(1i*random_phases));
        % Optimize RIS phases to maximize alpha
        %[phases_rsm,it_rsm] = RIS_opt_RSM(random_phases, Hbu_og, matHbr, matHru,[f1,f2,f3,f4]);
        if(Nris(s)==700)
            disp('STOP')
        end
        [phases_rsm,it_rsm] = RIS_opt_RSM(random_phases, Hbu_og, matHbr, matHru);
        % Compund channel
        Hc_rsm = beta_bu.*matHru*phases_rsm*matHbr; % RSM optimization        

        % Complete channel
        Ht_rsm = Hbu + Hc_rsm;
    end

    % Alpha in RSM with ZF
    alpha_bu(s) = pot(Hbu);         % Direct channel
    alpha(s) = pot(Ht_rsm);         % RIS-aided + It.Alg RSM

    rank_Hrsm(s) = rank(Ht_rsm);
    rank_Hbu(s) = rank(Hbu);

    % Rank enhancement for RSM: (λ1/λ2) with λ = eigenvalue of H
    arsm = svd(Ht_rsm,0);
    coef_rsm(s) = sqrt(arsm(1)/arsm(2));
    autovalors{s} = arsm;

    % ABEP for RSM: Perfect estimation
%     [ABEP_bu(s),SNR_bu(s)] = ABEP(pot(Hbu),Ptot,var2,Na,0);
%     [ABEP_rsm(s),SNR_rsm(s)] = ABEP(pot(Ht_rsm),Ptot,var2,Na,0);

    % Spectral efficiency and Energy efficiency
%     SE_rsm(s) = SE(Nris(s),Nrx,BW,freq,v,Na);
%     SE_bu(s) = SE(0,Nrx,BW,freq,v,Na);

    Ny = Ny+10;
    disp('');
end
toc;

%% PLOT FIGURES
plotRSM;
