function varargout = mapINFO(BS,RISs,Ny,x_i,y,Mtx,Nrx,angBS,angUE,ang_RIS,mode)
% mapINFO(BS,RISs,Ny,x_i,y,Mtx,Nrx,angBS,angUE,ang_RIS,mode) Computes
% all the neccesary information for each mode of transmission (RSM) or
% (TxBF) and returns the cell INFO
% INPUT PARAMETERS:
%   BS: 1st antenna at the BS
%   RISs: 1st element at the RIS(s)
%   Ny: Nº elements per column
%   x_i: x-coordinate of the 1st antenna at the UE
%   y: array with y-coordinates of the 1st antenna at the UE
%   Mtx: Nº of antennas at the BS
%   Nrx: Nº of antennas at the UE
%   angBS, angUE, ang_RIS: Orientation angles of BS, UE and RIS
%   mode: Tranmission mode ('RSM' or 'TxBF')

% LOAD SYSTEM PARAMETERS
system_parameters;

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
        % Average bit error rate
        ABEP_bu(a)=0.5;     % For direct channel
        ABEP_rsm(a)=0.5;    % For RIS-aided channel
        ABEP_no(a)=0.5;     % For RIS-aided channel (no optimized)

        % Alpha in RSM
        al_bu(a) = 0;       % For direct channel
        al(a) = 0;          % For RIS-aided channel
        al_no(a) = 0;       % For RIS-aided channel (no optimized)

        % Transmission rate in TxBF
        CBF_bu(a) = 0;      % For direct channel
        CBF(a) = 0;         % For RIS-aided channel
        CBF_no(a) = 0;      % For RIS-aided channel (no optimized)

        % Spectral efficiency
        SE_bu(a) = 0;       % For direct channel in TxBF
        SE_no(a) = 0;       % For RIS-aided channel (no optimized) in TxBF
        SE_bf(a) = 0;       % For RIS-aided channel in TxBF
        SE_rsm(a) = 0;      % For RIS-aided channel in RSM

        % Energy efficiency
        EE_rsm_bu(a) = 0;   % For direct channel in RSM
        EE_rsm(a) = 0;      % For RIS-aided channel in RSM

        EE_bu(a) = 0;       % For direct channel in TxBF
        EE_bf(a) = 0;       % For RIS-aided channel in TxBF
        EE_no(a) = 0;       % For RIS-aided channel (no optimized) in TxBF
    else
        % Calculate direct channel
        Hbu_og = direct_channel(coord_tx, coord_rx,freq,angBS,angUE);

        for r = 1:RIS
            % For each RIS
            % All element locations
            coord_ris = COORD_RIS(RISs{r},Nz,Ny(r),lam,ang_RIS{r});
            dbr = norm(coord_ris(1,:)-coord_tx(1,:)); % Minimum distance BS - RIS
            dru = norm(coord_rx(1,:)-coord_ris(1,:)); % Minimum distance RIS - UE

            % Calculate RIS-UE channel (Hru) and BS-RIS channel (Hbr)
            [Hbr{r},Hru{r},s_path] = compund_channel(dbr,dru,freq,Nz,Ny(r),coord_tx,coord_rx,coord_ris,angBS,angUE,ang_RIS{r});
            ploss_c = s_path*exp(1i*2*pi/lam*(dru+dbr));
            Hbr{r} = Hbr{r}*ploss_c;
        end
        matHbr = cell2mat(Hbr.');
        matHru = cell2mat(Hru);

        Hbu_og = R12inv*Hbu_og;
        matHru = R12inv*matHru;
        % Initial random phases for the RIS coefficients
        random_phases = rand(Nris,1)*2*pi;
        % Matrix of RIS coefficients with no optimization
        phases_no = diag(exp(1i*random_phases));
        isRSM = strcmp(mode,'RSM');

        if(Nrx>2 && isRSM==1) % If RSM transmission and N>2, RAS
            [Hbu, Ht_rsm,it_rsm(a),ARA] = RAS(Hbu_og,matHbr,matHru,random_phases);
            Ht_no = Hbu + matHru(ARA,:)*diag(exp(1i*random_phases))*matHbr;
            disp('RAS OK');
        elseif(isRSM)
            % Optimize RIS phases to maximize alpha
            [phases_rsm,it_rsm] = RIS_opt_RSM(random_phases, Hbu_og, matHbr, matHru);     
            % Compund channel
            Hc_rsm = matHru*phases_rsm*matHbr; % RSM optimization
            Hc_no = matHru*phases_no*matHbr;   % No optimization
            Hbu = Hbu_og;
            % Complete channel
            Ht_rsm = Hbu + Hc_rsm;
            Ht_no = Hbu + Hc_no;
        end

        if(strcmp(mode,'RSM'))
            % Alpha in RSM with ZF
            al_bu(a) = pot(Hbu);                        % Alpha for direct channel
            al(a) = pot(Ht_rsm);                        % Alpha for RIS-aided channel + It.Alg RSM
            al_no(a) = pot(Ht_no);                      % Alpha for RIS-aided channel + No optimization

            % ABEP for RSM: perfect estimation
            ABEP_bu(a) = ABEP(pot(Hbu),Ptot,var2,0);      % ABEP for direct channel
            ABEP_rsm(a) = ABEP(pot(Ht_rsm),Ptot,var2,0);  % ABEP for RIS-aided channel + It.Alg RSM
            ABEP_no(a) = ABEP(pot(Ht_no),Ptot,var2,0);    % ABEP for RIS-aided channel + No optimization

            % ABEP for RSM with error estimation:
            T = 2*Nris+1;
            T_text = '2Nr + 1';
            ABEP_buE(a) = ABEP(pot(Hbu),Ptot,var2,1,Hbu'*inv(Hbu*Hbu'),T,Nris);
            ABEP_rsmE(a) = ABEP(pot(Ht_rsm),Ptot,var2,1,Ht_rsm'*inv(Ht_rsm*Ht_rsm'),T,Nris);
            ABEP_noE(a) = ABEP(pot(Ht_no),Ptot,var2,1,Ht_no'*inv(Ht_no*Ht_no'),T,Nris);

            % EE
            SE_rsm_bu(a) = SE(0,Nrx,BW,freq,v,4);       % SE for direct channel in RSM
            SE_rsm(a) = SE(Nris,Nrx,BW,freq,v,4);       % SE for RIS-aided channel + It.Alg RSM
            EE_rsm_bu(a) = EE(Nrx,SE_rsm_bu(a),0);      % EE for direct channel in RSM
            EE_rsm(a) = EE(Nrx,SE_rsm(a),0);            % EE for RIS-aided channel + It.Alg RSM
        else
            % Optimize RIS phases to maximize alpha
            phases_bf = RIS_opt_BF(random_phases, Hbu_og, matHbr, matHru);
            % Compund channel
            Hc_bf = matHru*phases_bf*matHbr;     % TxBF optimization
            Hc_no = matHru*phases_no*matHbr;     % No optimization
            
            % If obstacle between BS-UE, the direct channel suffers a 30dB
            % attenuation
            obstacle1 = [[45,25],[55,25]];
            obstacle2 = [[25,45];[25,55]];
            % Vector given 1st BS coordinate and 1st UE coordinate
            p = [coord_tx(1,1)-coord_rx(1,1),coord_tx(1,2)-coord_rx(1,2)];
            % Normal line to obstacle 1
            q1 = [0,1];
            % Normal line to obstacle 2
            q2 = [1,0];
            % Vector given 1st BS coordinate and Obs. 1 and Obs.2 coordinate
            o = [coord_tx(1,1)-obstacle1(1,1),coord_tx(1,2)-obstacle1(1,2)];
            o2 = [coord_tx(1,1)-obstacle2(1,1),coord_tx(1,2)-obstacle2(1,2)];
            % Angle of incidence
            ang_inc1 = acosd(dot(p,q1)/(norm(p)*norm(q1)));
            ang_inc2 = acosd(dot(p,q2)/(norm(p)*norm(q2)));
            % Observation angle between the BS and the obstacles
            ang_obs = acosd(dot(o,q1)/norm(o)/norm(q1));
            ang_obs2 = acosd(dot(o2,q2)/norm(o2)/norm(q2));
            
            if(ang_inc1<ang_obs && coord_rx(1,2)< obstacle1(1,2))
                Hbu = Hbu_og*(10^-3); % 30dB attenuation
            elseif(ang_inc2<ang_obs2 && coord_rx(1,1)<obstacle2(1,1))
                Hbu = Hbu_og*(10^-3); % 30dB attenuation
            else
                Hbu = Hbu_og;
            end
            % Complete channel
            Ht_bf = Hbu + Hc_bf;
            Ht_no = Hbu + Hc_no;
            
            % Tranmission rate with TxBF
            CBF_bu(a) = log2(1+max(eig(Hbu'*Hbu))*Ptot/var2);       % Direct channel
            CBF(a) = log2(1+max(eig(Ht_bf'*Ht_bf))*Ptot/var2);      % RIS-aided + It.Alg TxBF
            CBF_no(a) = log2(1+max(eig(Ht_no'*Ht_no))*Ptot/var2);   % RIS-aided + No optimization

            % Spectral efficiency, Energy efficiency
            SE_bu(a) = SE(0,Nrx,BW,freq,v,CBF_bu(a));
            SE_bf(a) = SE(Nris,Nrx,BW,freq,v,CBF(a));
            SE_no(a) = SE(Nris,Nrx,BW,freq,v,CBF_no(a));

            EE_bu(a) = EE(Nrx,SE_bu(a),1);
            EE_bf(a) = EE(Nrx,SE_bf(a),1);
            EE_no(a) = EE(Nrx,SE_no(a),1);
        end
    end
end
if(strcmp(mode,'RSM'))
    INFO = {ABEP_bu,ABEP_rsm,ABEP_no,al_bu,al,al_no,EE_rsm_bu,EE_rsm};
else
    INFO = {CBF_bu,CBF,CBF_no,SE_bu,SE_bf,SE_no,EE_bu,EE_bf,EE_no};
end

varargout = {INFO};
end
