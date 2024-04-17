function spectral_eff = SE(Nr,N,BW,fc,v,Na)
%SE Computes the spectral efficiency with losses (bits/s/Hz)
%   Nr: Nº of RIS elements
%   N: Antennas at the UE
%   BW: Channel bandwidth (Hz)
%   fc: Carrier frequency (Hz)
%   v: terminal velocity (m/s)
%   Ha: Channel
%   R: Maximum achievable transmission rate (bits/s/Hz)
%   Na: Number of ARAs
%   A: size of the modulation symbols
A = 2^Na;
R = Na + log2(A);
Lse = SE_losses(Nr,N,BW,fc,v);
spectral_eff = (1-Lse)*R;
end