function varargout = RAS_alg(Hbu, Hbr, Hru, fase_i,Na)
%Ha = RAS_alg_noRIS(H) Computes RAS algorithm with RIS-aided channel H
%and returns the channel Ha with 2 active antennas at the RX (Table 3.2)
%[Ha,ARA] = RAS_alg_noRIS(H) Returns Ha and the index of the selected antennas
% INPUT PARAMETERS:
%   Hbu: Direct channel (BS-UE);
%   Hbr: Channel between BS-RIS;
%   Hru: Channel between RIS-UE;
%   fases: Initial random RIS phases;
%   Na: Number of ARAs

M = size(Hbu,2); % Nº of BS antennas
N = size(Hbu,1); % Nº of UE antennas

Ha = [];

V = 1:N;
J = V;
K = [];

for i=1:(N-Na)
    % AUXILIAR VARIABLES
    Hbu_aux = Hbu;
    Hru_aux = Hru;

    l = inf*ones(1,N);
    for j = 1:size(V,2)
        eigen_values = [];
        % Turn off the j-th UE antenna
        Hbu_aux(j,:) = [];
        Hru_aux(j,:) = [];

        % Recalculate the optimized RIS coefficients
        coefs = RIS_opt_RSM(fase_i,Hbu_aux, Hbr, Hru_aux);
        H = Hbu_aux + Hru_aux*coefs*Hbr;
        % N_aux = size(V,2)-1;
        % Rs = 2^N_aux/(2^N_aux-1)*(1/N_aux*eye(N_aux)+1/N_aux);
        % R12inv = inv(chol(Rs).');
        eigen_values = svd(H'*H,0); %H*H'

        l(j) = sum(1./eigen_values(1:min(M,Na)));

        % Restore channels
        Hbu_aux = Hbu;
        Hru_aux = Hru;

    end
    index = find(l == min(l));  % Search for the worst antenna
    K(i) = index(end);         
    index = [];
    V = J(ne(J,K(i)));          % Update the active antennas
    J = V;

    % Update channels without the worst antenna deactivated
    Hbu(K(i),:) = [];
    Hru(K(i),:) = [];

end
% Final optimized RIS coefficients
[coefs_it,it] = RIS_opt_RSM(fase_i, Hbu,Hbr,Hru);
% Complete channel with ARAs
Ha = Hbu + Hru*coefs_it*Hbr;

if nargout == 0
    disp(['ALG 3, Antenes seleccionades = ', num2str(V)]);
else
    varargout = {Ha,it,V};
end
end