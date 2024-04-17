function varargout = cap(H,Ptot,var2)
%CAP Channel capacity using waterfilling
%   H: Channel
%   Ptot: Total transmitted power
%   var2: Noise power

% Numero de modes possibles
K = min(size(H));
% Autovalors del canal
aut = svd(H,0);
% Waterfilling
P_bu = waterfill(Ptot,(var2./(aut.^2)).');
C = 0;
% Capacitat MIMO
for k = 1:K
    C = C + log2(1+P_bu(k)*aut(k)^2/var2);
end
varargout = {C,aut};
end
