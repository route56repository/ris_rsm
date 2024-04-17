function mu_opt = opt_mu(Hbu,Hbr,Hru,psi,s_n,alg)
%mu_opt = OPT_MU Function to optimize the mu value of the iterative
%algorithms 1 (Table 3.1) and 3 (Table 3.3)
% Parameters:
%   Hbu: Direct channel
%   Hbr: Channel between BS and RIS
%   Hru: Channel between RIS and UE
%   psi: Parameter over we seek the derivative
%   s_n: The gradient with respect x
%   alg: Type of iterative algorithm ('RSM' or 'TxBF')

if(strcmp(alg,'RSM')) % Iterative algorithm 1 (RSM - Optimize alpha of H)
    % Function to maximize is alpha = inv(trace(inv(H*H')))
    fun = @(mu) trace(inv((Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu)*(Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu)'));
elseif(strcmp(alg,'TxBF')) % Iteartive algorithm (TxBF - Optimize eigenvalues of H'*H)
    % Function to maximize is = eigenvalues(H'*H)
    fun = @(mu) (1/max(eig((Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu)'*(Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu))));
elseif(strcmp(alg,'WF')) % Iteartive algorithm (WF - Optimize prod of eigenvalues of H'*H)
    % Function to maximize is log2(prod(eig(Ha'*Ha))
    N = size(Hbu,1);
    M = size(Hbu,2);
    SNR = 10/3.981071705534969e-10;
    %fun = @(mu) 1/(log2(prod((svd(Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu).^2)/min(M,N)*(SNR+sum(1./(svd((Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu))).^2)))));
    fun = @(mu) 1/(log2(prod((svd(Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu).^2))));
%     fun = @(mu) -(log2(prod((svd(Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu).^2)/min(M,N)*(SNR+sum(1./(svd((Hru*diag(exp(1i*(psi+mu*s_n)))*Hbr+Hbu))).^2)))));
end

options = optimset('MaxFunEvals',1e5,'MaxIter',1e3,'TolX',1e-5');
%options = optimset('PlotFcns','optimplotfval','TolX',1e-10);
x0 = 0;
mu_opt = fminsearch(fun,x0,options);

% mus = linspace(-1e-3,1e-3);
% for i = 1:size(mus,2)
%     ca(i) = log2(prod(eig((Hru*diag(exp(1i*(psi+mus(i)*s_n)))*Hbr+Hbu)'*(Hru*diag(exp(1i*(psi+mus(i)*s_n)))*Hbr+Hbu))+sum(1./(eig((Hru*diag(exp(1i*(psi+mus(i)*s_n)))*Hbr+Hbu)'*(Hru*diag(exp(1i*(psi+mus(i)*s_n)))*Hbr+Hbu))))/min(M,N)));
% end
% % figure;
% % plot(mus,abs(ca)); hold on;
% % xline(mu_opt);
% index = find(ca==max(ca));
% mu_opt = mus(index);
end
