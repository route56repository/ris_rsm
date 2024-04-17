%% LOAD SIMULATION SYSTEM PARAMETERS
freq = 30e9;                        % Carrier freq
c = physconst('LightSpeed');        % Light speed
lam = c/freq;                       % Carrier freq in wavelength
Ptot = 10^(3.2);                    % Total transmitted power (32 dBm)
var2 = 10^(-9.4);                   % Noise power (100 MHz)
BW = 100e6;                         % Channel bandwidth
v=20;                               % Terminal velocity
dist_el = 0.5;                      % Distance between elements in wavelenghts
dist_ant = 0.5;                     % Distance between antennas in wavelenghts
Gt = 3;                             % BS antenna gain = 3dBi
Gr = Gt;                            % UE antenna gain = 3 dBi
