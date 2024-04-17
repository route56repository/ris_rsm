function [coef_diag,it] = RIS_opt_RSM(varargin)
%[coef_diag,it] = RIS_OPT_RSM(varargin): Iterative algorithm 1 for RSM 
% and RIS elements optimization. Returns the diagonal matrix with the
% optimized coefficients and number of iterations needed. (Table 3.1)
% INPUT PARAMETERS:
%   fases: Initial random RIS phases;
%   Hbu: Direct channel (BS-UE);
%   Hbr: Channel between BS-RIS;
%   Hru: Channel between RIS-UE;

fases = varargin{1};
Hbu = varargin{2};
Hbr = varargin{3};
Hru = varargin{4};

hd = vec(Hbu);          % Vectorized direct channel
Nr = size(Hbr,1);       % Nº of RIS elements

for i = 1:Nr
    h1i = Hru(:,i);
    h2i = Hbr(i,:);
    H12(:,i) = vec(h1i*(h2i));  % Composite channel matrix
end

ep=1e-4;                                            % Tolerance for stopping criterion
Ha=Hru*diag(exp(1i*fases))*Hbr+Hbu;                 % Complete channel

t = 2;
psi=fases;                                          % Initial values for the RIS phases
alpha = [0 0.1];                                    % Convergence is checked on alpha
gr_old = 0;
s_old = 0;
while abs((alpha(t)-alpha(t-1))/alpha(t))>ep        % Iterative maximization of alpha wrt to RIS coefficients
    psi_1=psi;
    % Compute the derivate (steepest direction)
    Ha2i=inv(Ha*Ha');
    HH=(Ha2i*Ha2i)'*Ha;
    c = exp(1i*psi_1);
    gr = imag(diag(conj(c))*H12'*HH(:));
    % Compute beta_PR
    bPR = gr.'*(gr-gr_old)/(gr_old.'*gr_old);
    bPR(isinf(bPR))=0;                              % Initial case, when gr_old=0
    b = max(0,bPR);
    % Update the conjugate direction
    s_t = gr+b*s_old;
    % Find the step size
    mu(t) = opt_mu(Hbu,Hbr,Hru,psi_1,s_t,'RSM');
    % Update the phases
    psi=psi_1+mu(t)*gr;
    c=exp(1i*psi);                                  % Restriction of unit modulus for the RIS elements
    t=t+1;
    Ha=Hru*diag(c)*Hbr+Hbu;
    alpha(t)=1/(sum(diag(inv(Ha*Ha'))));                  % Value of alpha for Ha
    gr_old = gr;
    s_old = s_t;
    if(t>90)
        disp('MÉS DE 100 IT')
        break;  % Limitate the number of iterations to reduce time complexity
    end
end

alpha(1:2) = alpha(3);

% TESTING PLOTS
if(nargin>4)
    f1 = varargin{5}(1);
    f2 = varargin{5}(2);
    f3 = varargin{5}(3);
    f4 = varargin{5}(4);
    if(Nr<=50)
        figure(f1)
        subplot(5,2,Nr/5)
        yyaxis left
        plot(alpha)
        yyaxis right
        plot(mu)
    elseif(Nr>50 && Nr<=100)
        figure(f2)
        subplot(5,2,(Nr-50)/5)
        yyaxis left
        plot(alpha)
        yyaxis right
        plot(mu)
    elseif(Nr>100 && Nr<=150)
        figure(f3)
        subplot(5,2,(Nr-100)/5)
        yyaxis left
        plot(alpha)
        yyaxis right
        plot(mu)
    else
        figure(f4)
        subplot(5,2,(Nr-150)/5)
        yyaxis left
        plot(alpha)
        yyaxis right
        plot(mu)
    end
    title([num2str(i) ' RIS elements']);
    xlabel('Iterations');
    yyaxis left
    ylabel('alpha');
    yyaxis right
    ylabel('mu');   
end
coef_diag = diag(c);
it = t;
end