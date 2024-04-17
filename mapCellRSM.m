function varargout = mapCellRSM(BS,RISs,Ny,x_i,y,Mtx,Nrx,Na,angBS,angUE,ang_RIS)
% mapCellRSM(BS,RISs,Ny,x_i,y,Mtx,Nrx,Na,angBS,angUE,ang_RIS) Computes
% all the neccesary information for an RSM transmission and returns the
% cell INFO
% INPUT PARAMETERS:
%   BS: 1st antenna at the BS
%   RISs: 1st element at the RIS(s)
%   Ny: Nº elements per column
%   x_i: x-coordinate of the 1st antenna at the UE
%   y: array with y-coordinates of the 1st antenna at the UE
%   Mtx: Nº of antennas at the BS
%   Nrx: Nº of antennas at the UE
%   Na: Number of active antennas at RX
%   angBS, angUE, ang_RIS: Orientation angles of BS, UE and RIS

% LOAD SYSTEM PARAMETERS
system_parameters;
randn('seed',3);
rand('seed',3);
% Initial UE position
UE = [x_i,0,1.5];

% All possible BS and UE antennas
[coord_tx, coord_rx_i] = COORD_TXRX(Mtx,Nrx,BS,UE,lam,angBS,angUE);
Nz = 5;
RIS = size(RISs,2);         % Nº of RIS
Nris = sum(Ny)*Nz;          % Nº total RIS elements

Rs = 2^Nrx/(2^Nrx-1)*(1/Nrx*eye(Nrx)+1/Nrx);
R12inv = inv(chol(Rs).');

% For each y-coordinate, compute the complete channel and the parameters
% of each type of transmission
for a = 1:size(y,2)
    % New UE antenna coordinates and distance between BS-UE
    coord_rx = coord_rx_i + y(a)*[0,1,0];
    dbu = norm(coord_rx(1,:)-coord_tx(1,:));

    % If dbu<10, the pathloss equation cannot be used, therefore all the
    % possible parameters to be evaluated will be null
    if(dbu<=10)
        % Alpha in RSM
        al_bu(a) = 0;       % For direct channel
        al(a) = 0;          % For RIS-aided channel
        al_coef1(a)=0;
    else
        % Calculate direct channel
        [Hbu_og,beta_bu] = NF_bu(coord_tx,coord_rx);
        Hbu_og = Hbu_og./beta_bu;
        for r = 1:RIS
            % For each RIS
            % All element locations
            coord_ris = COORD_RIS(RISs{r},Nz,Ny(r),lam,ang_RIS{r});
            
            % Calculate RIS-UE channel (Hru) and BS-RIS channel (Hbr)
            [Hbr{r},Hru_aux,s_path] = NF_Hc(Nz,Ny(r),coord_tx,coord_rx,coord_ris,ang_RIS{r});
            Hbr{r} = Hbr{r}*s_path;
            Hru{r} = Hru_aux;
        end
        % Normalize
        % matHbr = cell2mat(Hbr.');
        matHbr = cell2mat(Hbr.')./beta_bu;
        matHru = cell2mat(Hru);

        Hbu_og = R12inv*Hbu_og;
        matHru = R12inv*matHru;

        % Initial random phases for the RIS coefficients
        random_phases = rand(Nris,1)*2*pi;
        % MATRIU DIAGONAL COEFICIENTS 1
        coefs1 = eye(Nris);

        if(Nrx>Na) % If RSM transmission and N>Na, RAS
            [Hbu, Ht_rsm,it_rsm(a),ARA] = RAS(Hbu_og,matHbr,matHru,random_phases,Na);
            [Ht_coef1,ARAs] = RAS_alg_noRIS(Hbu_og+matHru*coefs1*matHbr,Na);
            disp('RAS OK');
            Hbu = Hbu.*beta_bu;
            Ht_rsm = Ht_rsm.*beta_bu;
            Ht_coef1 = Ht_coef1.*beta_bu;
        else
            % Optimize RIS phases to maximize alpha
            [phases_rsm,it_rsm] = RIS_opt_RSM(random_phases, Hbu_og, matHbr, matHru);

            % Compund channel
            Hc_rsm = beta_bu.*matHru*phases_rsm*matHbr; % RSM optimization
            Hbu = Hbu_og*beta_bu;
            % Complete channel
            Ht_rsm = Hbu + Hc_rsm;
            Ht_coef1 = Hbu + beta_bu.*matHru*coefs1*matHbr;
        end

        % Alpha in RSM with ZF
        al_bu(a) = pot(Hbu);                        % Alpha for direct channel
        al(a) = pot(Ht_rsm);
        al_coef1(a) = pot(Ht_coef1);

    end
end                
INFO = {al_bu,al,al_coef1};

varargout = {INFO};
end
