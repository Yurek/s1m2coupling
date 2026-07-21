clear
close all

dFb = 0.000; % s
dFf = 0.015; % s
t1_ = 0.0;   % s
t2_ = 0.1;   % s
TrialTypes = {'All','Go','NoGo'};
load('.\data\dPrime.mat')
for CorType = ["Total", "Noise"]
    if CorType=="Total"
        figure('Position',[510 300 631 600],'name',CorType)
    else
        figure('Position',[907 300 631 600],'name',CorType)
    end
    for i = 1:3
        ax(i)  = subplot(3,1,i);hold (ax(i), 'all')
    end
    Xlim = [-0.05,0.25;  -0.05,0.35; -0.02,0.15;
        -0.05,0.25; -0.05,0.25; -0.02,0.2;
        +0.05,0.32; -0.02,0.25;  -0.02,0.15];
    Ylim = [ 0.4,0.6; 0.3,0.6; 0.4,0.6; ...
        0.4,0.6; 0.4,0.6; 0.4,0.6; ...
        0.4,0.6; 0.3,0.6; 0.4,0.6 ];
    Xlabel = cat(2,repmat({'Time from stimulus (s)'},1,6), repmat({'Time from lick (s)'},1,3));
    n=0;
    for  Ttype = 1:numel(TrialTypes)
        n = n+1;
        addpath('.\utils\linspecer\')
        load(['.\data\CorrMapFin_',char(CorType),'CCA_5msBin_Dim1_',TrialTypes{Ttype},'.mat'])
        disp(TrialTypes{Ttype})
        [~,dminus] = min(abs(Edata.delays-(dFb)));
        [~,dplus] = min(abs(Edata.delays-(dFf)));
        Ds = dminus:dplus;
        Pre = 400; % ms
        Post = 1400; % ms
        wStep = 10; % ms
        psthWindSpan = 10; % ms
        
        Corr_ = zeros(numel(Ds), numel(-Pre/wStep:Post/wStep), size(Edata.CorMapAll,3));
        for i = 1:size(Edata.CorMapAll,3)
            [~,indMrt] = min(abs(Edata.t_corr - 0));
            Corr_(:,:,i) = Edata.CorMapAll(Ds, indMrt-Pre/wStep:indMrt+Post/wStep,i);
        end
        t_Corr = Edata.t_corr(indMrt-Pre/wStep:indMrt+Post/wStep);
        meanCorrPerSess = squeeze(mean(Corr_,1))';
        [~,t1Idx] = min(abs(t_Corr-(-.25)));
        [~,t2Idx] = min(abs(t_Corr-(.0))); 
        meanCorrPerSess = meanCorrPerSess - mean(meanCorrPerSess(:,t1Idx:t2Idx),2);
        [~,t1Idx] = min(abs(t_Corr-t1_)); 
        [~,t2Idx] = min(abs(t_Corr-t2_));
       
        meanCor= mean(meanCorrPerSess(:,t1Idx:t2Idx),2);
        % lme vars
        if Ttype == 1 && CorType == "Noise"
            M2FracSel = (Edata.fracSig_M2-mean(Edata.fracSig_M2))';
            S1FracSel = (Edata.fracSig_S1-mean(Edata.fracSig_S1))';
            meanCor_Noise = meanCor - mean(meanCor);
            dPrime_ = dPrime;
            Subject = cellfun(@(x) split_choose_trim(x, '_',1,''), Edata.recIDs,'UniformOutput', false);
        elseif Ttype == 1 && CorType == "Total"
            meanCor_Total = meanCor - mean(meanCor);
        end
        % Pearson's correlation
        dPrime_temp = dPrime;
        meanCor(isnan(dPrime))=[];
        dPrime_temp(isnan(dPrime))=[];
        Cpatch = [.95 .95 .95];
        C = [142/256,189/256, 227/256];
        add_corr_to_scatter(ax(n), meanCor,dPrime_temp,  C, Cpatch);
        C = [88/256,137/256, 176/256];
        scatter(ax(n),meanCor,dPrime_temp, 'filled','markerFaceColor',C,'MarkerEdgeColor','w')
        Range = max(meanCor)-min(meanCor);
        xlim(ax(n), [min(meanCor)-0.2*Range, max(meanCor)+0.2*Range])
        Range = max(dPrime_temp)-min(dPrime_temp);
        axis(ax(n),'square')
        set(ax(n),'TickLength',[0.03,0.35],'LineWidth',1)
    end
end
%% fit linear mixed-effects
% total correlation
disp("LME for total correlatoin")
tbl = table(dPrime_, Subject, S1FracSel, M2FracSel , meanCor_Total);
tbl.Subject = categorical(tbl.Subject);
model = ' dPrime_ ~ meanCor_Total * S1FracSel * M2FracSel + (1|Subject) ';
mdl = fitlme(tbl,model);
disp(mdl.Coefficients(2:end,1:6))
% noise correlation
disp("LME for noise correlatoin")
tbl = table(dPrime_, Subject, S1FracSel, M2FracSel , meanCor_Noise);
tbl.Subject = categorical(tbl.Subject);
model = ' dPrime_ ~ meanCor_Noise * S1FracSel * M2FracSel + (1|Subject) ';
mdl = fitlme(tbl,model);
disp(mdl.Coefficients(2:end,1:6))