%PLOTRSM Plots RSM simulations for Scenario 1
search = input('SEARCH FROM FILE (1 (yes), 0 (no)): ');
if(search == 1)
    clear all;
    currentFolder = pwd;
    files = dir('*.mat');
    if(size(files,1)>1)
        what
        index_file = input('Choose file: ');
        load(files(index_file).name);
    else
        load(files.name);
    end
end

%% SIMULATION SETUP
figure;
l1 = plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS_i,1);
title('Top view simulation setup');
l1.Location = 'best';
title(l1,['MIMO ',num2str(Mtx),'x',num2str(Nrx)]);

%% ALPHA RSM
figure
plot(Nris,alpha_bu);
title('\alpha RSM');
hold on
plot(Nris, alpha);
lg2 = legend('Direct channel','Opt(1) RIS-aided channel','Location','best');
title(lg2,['MIMO ', num2str(Mtx), 'x', num2str(Nrx)]);
xlabel('Nº of RIS elements');
ylabel('\alpha');

for aa = 1:length(alpha)
ABEP_bu(aa) = ABEP(alpha_bu(aa),Ptot,var2,Na,0);
ABEP_rsm(aa) = ABEP(alpha(aa),Ptot,var2,Na,0);
end
figure
plot(Nris,log10(ABEP_bu));
title('\alpha RSM');
hold on
plot(Nris, log10(ABEP_rsm));
lg2 = legend('Direct channel','Opt(1) RIS-aided channel','Location','best');
title(lg2,['MIMO ', num2str(Mtx), 'x', num2str(Nrx)]);
xlabel('Nº of RIS elements');
ylabel('ABEP');

% %% ABEP with perfect estimation
% figure;
% semilogy(Nris,ABEP_bu);
% hold on;
% semilogy(Nris,ABEP_rsm);
% semilogy(Nris,ABEP_no);
% title('ABEP for 4-PSK: Perfect estimation')
% lgg = legend('Direct channel','Opt(1) RIS-aided channel','NO-Opt RIS-aided channel','Location','best');
% title(lgg,['SNR = Pt/\sigma^2 = ', num2str(10*log10(Ptot/var2)), ' dB']);
% xlabel('Nº of RIS elements');
% ylabel('ABEP')
% 
% %% ABEP with error estimation
% figure;
% semilogy(Nris,ABEP_buE);
% hold on;
% semilogy(Nris,ABEP_rsmE);
% semilogy(Nris,ABEP_noE);
% title('ABEP for 4-PSK: Error estimation')
% lgg = legend('Direct channel','Opt(1) RIS-aided channel','NO-Opt RIS-aided channel','Location','best');
% title(lgg,['SNR = Pt/\sigma^2 = ', num2str(10*log10(Ptot/var2)), ' dB, T = ', T_text]);
% xlabel('Nº of RIS elements');
% ylabel('ABEP')

%% ABEP and SNR
% figure;
% yyaxis left
% semilogy(Nris,ABEP_bu,'DisplayName','Hbu');
% hold on;
% semilogy(Nris,ABEP_rsm,'DisplayName','Hrsm');
% ylabel('ABEP')
% ylim([1e-10,1]);
% yyaxis right
% semilogy(Nris,SNR_bu,'DisplayName','Hbu (SNR)');
% hold on;
% plot(Nris,SNR_rsm,'DisplayName','Hrsm (SNR)');
% title(['ABEP and SNR for ', num2str(2^Na),'-PSK']);
% lgg = legend;
% lgg.Location = 'best';
% lgg.NumColumns = 2;
% xlabel('Nº of RIS elements');
% ylabel('SNR (dB)')

%% CONDITION LAMBDA1/LAMBDA2
figure;
% semilogy(Nris,coef_no);
% hold on
semilogy(Nris,coef_rsm);
title('Condition \lambda_1/\lambda_2')
lg6 = legend('NO-opt RIS-aided channel','Opt(1) RIS-aided channel with ZF','Location','best');
xlabel('Nº of RIS elements');
ylabel('\lambda_1/\lambda_2');
mat_arsm = cell2mat(autovalors);
table(Nris',sqrt(mat_arsm(1,:))',sqrt(mat_arsm(2,:))',sqrt(mat_arsm(3,:))','VariableNames',["Nr","\lambda_1","\lambda_2","\lambda_3"])
%% SPECTRAL EFFICIENCY
% figure;
% plot(Nris, SE_bu);
% title('Spectral Efficiency')
% hold on
% plot(Nris, SE_rsm);
% llg4 = legend('Direct channel','RIS-aided channel','Location','best');
% title(llg4,['BW = ' num2str(BW*1e-6) ' MHz, v = ' num2str(v) ' m/s']);
% xlabel('Nº of RIS elements');
% ylabel('SE [bits/s/Hz]');


