function energy_eff = EE(N,SE,mode)
%EE Calculates the energy efficiency (bits/Hz/J)
%   N: Antennas at the UE
%   SE: Spectral efficiency (bits/s/Hz)
%   Pc: Power consumption
%   Pref: Reference power = 20mW
%   mode: 0 if RSM, 1 if TxBF

Pref = 20e-3;
PLNA= Pref;     
PPS=1.5*Pref;
PSW=0.25*Pref;
PRF=2*Pref;
PADC=10*Pref;
PBB=Pref;

if(mode==0)
    Pc = N*(2*PLNA+PPS+PSW)+2*(PRF+PADC)+PBB;
else
    Pc = 2*N*(PLNA+PRF+PADC)+PBB;
end

energy_eff= SE/Pc;

end