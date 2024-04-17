function Lse = SE_losses(Nr,N,BW,fc,v)
%SE_LOSSES Computes the spectral effiency losses in a RSM scheme with a
%RIS-aided channel.
% Nr: Nº of RIS elements
% BW: Channel bandwidth (Hz)
% fc: Carrier frequency (Hz)
% v: terminal velocity (m/s)
% Tt: Transmision periodicity
c = physconst('LightSpeed');
Nc = 0.423*BW/fc*c/v;           % Coherence time in terms of number of symbols
Tt = (Nc/10);
Lse = N*(Nr+1)/Tt;              % Spectral efficiency losses
end