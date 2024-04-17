function [coord_tx, coord_rx] = COORD_TXRX(Mtx,Nrx,BS,UE,lam,angBS,angUE)
%COORD_TXRX(Mtx,Nrx,BS,UE,lam,angBS,angUE) creates all the coordinates of
%the antennas at the BS and the UE.
%   Mtx: Nº of antennas at the BS
%   Nrx: Nº of antennas at the UE
%   BS: 1st antenna location at the BS
%   UE: 1st antenna location at the UE
%   lam: Carrier freqeucny in wavelenght (m)
%   angBS: Orientation angles of BS
%   angUE: Orientation angles of UE

dist_ant = 0.5;         % Antenna spacing at the BS and UE
theta_BS = angBS(1);    % Elevation angle of BS
phi_BS = angBS(2);      % Azimuth angle of BS
theta_UE = angUE(1);    % Elevation angle of UE
phi_UE = angUE(2);      % Azimuth angle of UE

% BS COORDINATES acoording to eq(3.1)
coord_tx(1,:) = BS;
for r = 2:Mtx
    coord_tx(r,:) = coord_tx(r-1,:) + [sin(theta_BS)*sin(phi_BS), sin(theta_BS)*cos(phi_BS), cos(theta_BS)]*dist_ant*lam;
end

% UE COORDINATES acoording to eq(3.2)
coord_rx(1,:) = UE;
for t = 2:Nrx
    coord_rx(t,:) = coord_rx(t-1,:) + [sin(theta_UE)*sin(phi_UE), sin(theta_UE)*cos(phi_UE), cos(theta_UE)]*dist_ant*lam;
end
end