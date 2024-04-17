function P = pot(H)
%POT Computes alpha=inv(trace(inv(H_aux*H_aux')))
% H_aux = H;
P = 1/(trace(inv(H*H')));
end