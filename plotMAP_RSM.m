function plotMAP_RSM
% LOAD FILES
files = dir('*.mat');

info = load(files(end).name);
BS = info.BS;
UE = info.UE;
RIS = info.RISmat;
angBS = info.angBS;
angUE = info.angUE;
ang_RIS = info.ang_RIS;
NRIS = info.NRIS;
Na = info.Na;
current_Folder = pwd;
RIS_element_size = current_Folder(end-4);
if(~strcmp(current_Folder(end-5),'_'))
    RIS_element_size=current_Folder(end-5:end-4);
end
% RIS_element_size='0.25';
m = info.m;
n = info.n;

i1 = 1;
i2 = 1;

system_parameters;

for i=1:length(files)-1
    a = load(files(i).name);
    if(i1 == m/n+1)
        i1 = 1;
        i2 = i2+1;
    end
%     cell_ABEP_bu{i1,i2} = a.ABEP_bu.';
%     cell_ABEP{i1,i2} = a.ABEP.';

    cell_al_bu{i1,i2} = a.al_bu.';
    cell_al{i1,i2} = a.al.';
    cell_al_coef1{i1,i2} = a.al_coef1.';
    
    i1 = i1+1;
    
end
x_all = 0:n/10:m;
y_all = 0:n/10:m;

%%
% PLOT COMPLETE CHANNEL
% ABEP
lims_ABEP = [-5,0];
%lims_ABEP = 0;
strlg = ['\textbf{$a=b=$',RIS_element_size,'$\lambda_c$, MIMO ' num2str(a.Mtx),'x',num2str(a.Nrx),'Nr = ', num2str(sum(NRIS)),'}'];
strlg_bu = ['\textbf{MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),'}'];

figure
hold on
mat_al_bu = cell2mat(cell_al_bu);
for ii = 1:m/(n/10)
    for iii = 1:m/(n/10)
        ABEP_bu(ii,iii) = ABEP(mat_al_bu(ii,iii),Ptot,var2,Na,0);
    end
end
imagesc(x_all,y_all,log10(ABEP_bu));
t1 = 'log_1_0(ABEP) - Direct channel ';
infoMAP(t1,lims_ABEP);
lg=TopView(BS,angBS,NaN,ang_RIS);
title(lg,strlg_bu,'Interpreter','latex');
fig_title = [num2str(a.Nrx),'N_',num2str(size(RIS,1)),'RIS_',num2str(sum(NRIS)),'Nr'];
savefig(['ABEP_bu_',fig_title]);


figure;
hold on
mat_al = cell2mat(cell_al);
for ii = 1:m/(n/10)
    for iii = 1:m/(n/10)
        ABEP_rsm(ii,iii) = ABEP(mat_al(ii,iii),Ptot,var2,Na,0);
    end
end
imagesc(x_all,y_all,log10(ABEP_rsm));
t2 = 'log_1_0(ABEP) - RIS-aided channel';
infoMAP(t2,lims_ABEP);
lg=TopView(BS,angBS,RIS,ang_RIS);
title(lg,strlg,'Interpreter','latex');
savefig(['ABEP_rsm_',fig_title]);

figure
hold on
mat_al_coef1 = cell2mat(cell_al_coef1);
for ii = 1:m/(n/10)
    for iii = 1:m/(n/10)
        ABEP_bu(ii,iii) = ABEP(mat_al_coef1(ii,iii),Ptot,var2,Na,0);
    end
end
imagesc(x_all,y_all,log10(ABEP_bu));
t1 = 'log_1_0(ABEP) - RIS-aided coefs = 1 ';
infoMAP(t2,lims_ABEP);
lg=TopView(BS,angBS,RIS,ang_RIS);
title(lg,strlg,'Interpreter','latex');
savefig(['ABEP_coef1_',fig_title]);

% ALPHA IN RSM
% lims_SNR = 0;
% % Direct channel
% figure
% hold on
% SNR_bu = 10*log10(abs((Ptot/var2).*cell2mat(cell_al_bu)));
% imagesc(x_all,y_all,SNR_bu);
% tt = 'SNR - Direct channel (10*log)';
% infoMAP(tt,lims_SNR);
% lg=TopView(BS,angBS,NaN,ang_RIS);
% title(lg,strlg_bu,'Interpreter','latex');
% 
% % RIS OPT
% figure;
% hold on
% SNR_t = 10*log10(abs((Ptot/var2).*cell2mat(cell_al)));
% imagesc(x_all,y_all,SNR_t);
% tt = 'SNR - RIS channel (10*log)';
% infoMAP(tt,lims_SNR);
% lg=TopView(BS,angBS,RIS,ang_RIS);
% title(lg,strlg,'Interpreter','latex');
end