function plotMAP
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
mode = info.mode;

for i=1:length(files)-1
    a = load(files(i).name);
    if(strcmp(mode,'RSM'))
        mat_ABEP_bu{i} = a.ABEP_bu;
        mat_ABEP{i} = a.ABEP;
        mat_ABEP_no{i} = a.ABEP_no;

        mat_al_bu{i} = log10(a.al_bu);
        mat_al{i} = log10(a.al);
        mat_al_no{i} = log10(a.al_no);

        mat_EE_rsm_bu{i} = a.EE_rsm_bu;
        mat_EE_rsm{i} = a.EE_rsm;
    else
        mat_CBFbu{i} = a.CBFbu;
        mat_CBF{i} = a.CBF;
        mat_CBF_no{i} = a.CBF_no;

        mat_SE_bu{i} = a.SE_bu;
        mat_SE_no{i} = a.SE_no;
        mat_SE_bf{i} = a.SE_bf;

        mat_EE_bu{i} = a.EE_bu;
        mat_EE_bf{i} = a.EE_bf;
        mat_EE_no{i} = a.EE_no;
    end
end

% PLOT COMPLETE CHANNEL
if(strcmp(mode,'RSM'))
    % ABEP
    figure
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,log10(a.ABEP_bu.'));
    end
    t1 = 'log_1_0(ABEP) - Direct channel ';
    c=infoMAP(t1);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS);
    title(lg,['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(a.NRIS)]);

    figure;
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,log10(a.ABEP.'));
    end
    t2 = 'log_1_0(ABEP) - Opt(1) RIS-aided channel';
    newLims=[-10,0];
    infoMAP(t2,newLims);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS);
    NRIS = a.NRIS;
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);

    figure;
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,log10(a.ABEP_no.'));
    end
    t3 = 'log_1_0(ABEP) - NO-Opt RIS-aided channel';

    infoMAP(t3,newLims);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS);
    title(lg,['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(a.NRIS)]);

    % ALPHA IN RSM
    % RIS OPT
    figure;
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.al.');
    end
    tt = 'log_1_0(\alpha) in RSM - Opt(1) RIS-aided channel';
    c2=infoMAP(tt);
    limsALPHA = c2.Limits;
    limsALPHA = [0,0.8e-7];
    infoMAP(tt,limsALPHA);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);


    % Direct channel
    figure
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.al_bu.');
    end
    tt = 'log_1_0(\alpha) in RSM - Direct channel';
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);
    infoMAP(tt,limsALPHA);

    % NO opt RIS-aided channel
    figure
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.al_no.');
    end
    tt = 'log_1_0(\alpha) in RSM - NO-Opt RIS-aided channel';
    infoMAP(tt,limsALPHA);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);

    % CDF
    % ABEP
    figure
    ax = axes;
    xlim([1e-10,0.5]);
    ax.XAxis.Scale = 'log';
    xlabel('log_1_0(ABEP)');
    hold on
    cdfplot(vec(cell2mat(mat_ABEP_bu)));
    cdfplot(vec(cell2mat(mat_ABEP)));
    cdfplot(vec(cell2mat(mat_ABEP_no)));
    ylabel('CDF');
    title('CDF of ABEP');
    legend('Direct channel','Opt(1) RIS-aided channel','NO-Opt RIS-aided channel','Location','best');

    % ALPHA
    figure
    hold on
    cdfplot(vec(cell2mat(mat_al_bu)));
    cdfplot(vec(cell2mat(mat_al)));
    cdfplot(vec(cell2mat(mat_al_no)));
    ylabel('CDF');
    title('CDF of log_1_0(\alpha)');
    legend('Direct channel','Opt(1) RIS-aided channel','NO-Opt RIS-aided channel','Location','best');
end

% TxBF
if(strcmp(mode,'TxBF'))
    % TRANSMISSION RATE
    figure;
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.CBFbu.');
    end
    tt = 'R_B_F - Direct channel';
    limsCBF = [0,18];
    infoMAP(tt,limsCBF);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    title(lg,['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx)]);

    figure;
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.CBF.');
    end
    tt = 'R_B_F - Opt(2) RIS-aided channel';
    infoMAP(tt,limsCBF);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);

    figure;
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.CBF_no.');
    end
    tt = 'R_B_F - NO-Opt RIS-aided channel';
    infoMAP(tt,limsCBF);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);

    % SE and EE
    figure
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.SE_bu.');
    end
    tt = 'SE - Direct channel';
    limsSE = limsCBF;
    infoMAP(tt,limsSE);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    title(lg,['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx)]);

    figure
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.SE_no.'); %%%canvia
    end
    tt = 'SE - Opt(2) RIS-aided channel';
    infoMAP(tt,limsSE);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);

    figure;
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.SE_no.');
    end
    tt = 'SE - NO-Opt RIS-aided channel';
    infoMAP(tt,limsSE);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);

    % CDF BF
    figure
    xlabel('R [bits/s/Hz]');
    hold on
    cdfplot(vec(cell2mat(mat_CBFbu)));
    cdfplot(vec(cell2mat(mat_CBF)));
    cdfplot(vec(cell2mat(mat_CBF_no)));
    ylabel('CDF');
    title('CDF of R_B_F');
    legend('Direct channel','Opt(2) RIS-aided channel','NO-Opt RIS-aided channel','Location','best');
    xlim([12,20]);

    %SE
    figure
    xlabel('SE [bits/s/Hz]');
    hold on
    cdfplot(vec(cell2mat(mat_SE_bu)));
    cdfplot(vec(cell2mat(mat_SE_bf)));
    cdfplot(vec(cell2mat(mat_SE_no)));
    ylabel('CDF');
    title('CDF of SE')
    legend('Direct channel','Opt(2) RIS-aided channel','NO-Opt RIS-aided channel','Location','best');

    % EE
    figure
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.EE_bu.');
    end
    tt = 'EE - Direct channel';
    infoMAP(tt);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx)];
    title(lg,strlg);

    figure
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.EE_bf.');
    end
    tt = 'EE - Opt(2) RIS-aided channel';
    infoMAP(tt);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);

    figure;
    hold on
    for i = 1:length(files)-1
        a = load(files(i).name);
        imagesc(a.x,a.y,a.EE_no.');
    end
    tt = 'EE - NO-Opt RIS-aided channel';
    infoMAP(tt);
    lg=plotCOORD(angBS,angUE,ang_RIS,BS,UE,RIS,0);
    strlg = ['MIMO ',num2str(a.Mtx),'x',num2str(a.Nrx),newline,num2str(a.RIS) 'RIS, Nr = ', num2str(sum(NRIS))];
    title(lg,strlg);
end
% file_CDF = ['mats_',num2str(a.Mtx),'x',num2str(a.Nrx),'_',num2str(a.RIS),'RIS_',num2str(sum(NRIS)),'.mat'];
% save(file_CDF,"mat_CBFbu","mat_CBF","mat_SE_bu","mat_SE_bf","mat_EE_no","mat_EE_bf");
end