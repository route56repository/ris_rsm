function varargout = NF_bu(coord_tx, coord_rx)
%DIRECT_CHANNEL Calculates the total direct channel between BS-UE
%   Model in the near-field
%   coord_tx: BS antenna locations
%   coord_rx: UE antenna location
%   freq: Carrier frequency
%   R: Rank direct channel

%   SIMULATION ANTENNA PARAMETERS
system_parameters;
hbs = coord_tx(1,3);                    % BS antenna height
hue = coord_rx(1,3);                    % UE antenna height
dbp = 4*(hbs-1)*(hue-1)*freq/physconst('LightSpeed');
dbu = norm(coord_tx(1,:)-coord_rx(1,:));
for i=1:size(coord_rx,1)
    for e=1:size(coord_tx,1)
        d_ie = norm(coord_tx(e,:)-coord_rx(i,:));   % Distance between i^th BS antenna and e^th UE antenna
        d_2d = norm(coord_tx(e,1:2)-coord_rx(i,1:2));
        if d_2d < dbp
            PL = 32.4+21*log10(d_ie)+20*log10(freq*1e-9);
        elseif d_2d >= dbp && d_2d < 5000
            PL = 32.4+40*log10(d_ie)+20*log10(freq*1e-9)-9.5*log10((dbp^2+(hbs-hue)^2));
        else
            disp('ERROR: CHANGE DISTANCES');
        end
        % PL = 28 + 20*log10(freq*1e-9) + 20*log10(dbu);
        ploss_direct_dB = Gt + Gr - PL;
        pathloss = 10^((ploss_direct_dB)/10);

        % Hbu(i,e) = sqrt(pathloss)*exp(-1i*2*pi/lam*(d_ie-dbu))*exp(1i*2*pi/lam*dbu);
        Hbu(i,e) = sqrt(pathloss)*exp(-1i*2*pi/lam*d_ie);
        ds(i,e) = d_ie;
    end
end
% Direct channel from Eq(3.8)
% Hbu = sqrt(pathloss)*Hbu;

varargout = {Hbu,sqrt(pathloss),ds};
end