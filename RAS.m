function varargout = RAS(varargin)
%RAS Receiver Antenna Selection for RSM
% Ha = RAS. Computes RAS. Returns Ha for the direct channel
% [Ha_bu, Ha_rsm] = RAS. Computes RAS. Returns Ha_bu for the direct channel
% and Ha_rsm for the RIS-aided channel
% INPUT PARAMETERS:
%   Hbu: Direct channel (BS-UE);
%   Hbr: Channel between BS-RIS;
%   Hru: Channel between RIS-UE;
%   fases: Initial random RIS phases;
Hbu = varargin{1};      % Direct channel
Hbr = varargin{2};      % BS_RIS Channel    
Hru = varargin{3};      % RIS_UE Channel
fase_i = varargin{4};   % Initial random phases
Na = varargin{5};       % Number of ARAs
% RAS Algorithm for direct channel
[Ha_bu,ARA] = RAS_alg_noRIS(Hbu,Na);
% RAS Algrithm for RIS-aided channel in RSM
if(Hbr == 0)
    Ha_rsm=0;
    it_rsm=0;
else
    [Ha_rsm,it_rsm,ARA_rsm] = RAS_alg(Hbu,Hbr,Hru,fase_i,Na);
end
varargout = {Ha_bu, Ha_rsm,it_rsm,ARA,ARA_rsm};
end
