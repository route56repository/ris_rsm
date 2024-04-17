function varargout = ABEP(varargin)
%ABEP Calculates the Average Bit Error Probability for a 4-PSK modulation
%in the RSM scheme
%   alpha: normalization factor, inv(trace(inv(H*H')))
%   P: Average transmit power
%   noise_power: Noise power (Gaussian)
%   s: modulation symbol (size M, j: 1,M)
%   Na: Number of transmitted spatial bits
%   c: channel uncertainty.
%       1: Estimation with errors
%       0: Perfect estimation

alpha = varargin{1};
P = varargin{2};
noise_power = varargin{3};
Na = varargin{4};

SNR = P./noise_power;
SNR_dB = 10*log10(SNR);

P_rec = alpha*P;

if(alpha>0)
    gamma = 1/2*sqrt(P_rec);            % Estimated threshold for HIGH SNR APPROX. (HSA) \gamma=1/2*sqrt(alpha*P*trace(Rs))

    % ABEP: Average Bit Error Probability
    % Pes: Spatial Bit Error Probability
    % Pem: Modulation Bit Error Probability

    Pem = 0;
    M = 2^Na;                           % Size of modulation symbol
    Pr = 1/(2^Na -1);                   % Probability of each possible transmitted symbol
    if(M==4)
        si = {[0,1],[1,0],[1,1]};       % All symbols of 4-PSK except 0 (possible transmitted)
        sn = {[0,0],[0,1],[1,0],[1,1]}; % All symbols of 4-PSK (possible detected)
    elseif(M==8)
        si = {[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]};
        sn = {[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]};
    end
    sn_mat = cell2mat(sn');

    for i=1:(2^Na-1)
        var2 = noise_power;
        P1 = 1 - marcumq(1*sqrt(2/var2)*sqrt(P_rec),1*sqrt(2/var2)*gamma);
        P0 = exp(-gamma^2/var2);

        for n=1:2^Na
            bin00 = 0;
            bin01 = 0;
            bin10 = 0;
            bin11 = 0;
            b = abs(si{i}-sn_mat(n,:));
            for bit = 1:Na % For each bit
                if si{i}(bit) == 0 %b01 or b00
                    % if b_i = 0 -> same bit: b00 ++, else different bit: b01++
                    if b(bit) == 0
                        bin00 = bin00 + 1;
                    else
                        bin01 = bin01 + 1;
                    end
                elseif si{i}(bit)==1
                    if b(bit) == 0
                        bin11 = bin11 + 1;
                    else
                        bin10 = bin10 + 1;
                    end
                end
            end

            SNR_c = bin11^2*P_rec/(bin11+bin01)/var2;             % Combined SNR
            SNR_c(isnan(SNR_c)) = 0;
            BEP = 2/log2(M)*qfunc(sqrt(2*SNR_c)*sin(pi/M));

            Pr_c = P1^bin10*(1-P1)^bin11*P0^bin01*(1-P0)^bin00;
            Pem = Pem + BEP*Pr_c*Pr;
        end

        Pes(i) = 0.5*(P1+P0);
        SNR_real(i) = P_rec/var2;
    end
    Pes_mean = mean(Pes);
    SNR_mean_real = 10*log10(mean(SNR_real));

    ABEP = (Na*Pes_mean+ log2(M)*Pem)/(Na+log2(M));

else
    ABEP = 0.5;
    Pes=0;
    Pem=0;
    SNR_mean_real = 0;
end

varargout = {ABEP,SNR_mean_real,Pes,Pem, SNR_dB};
end