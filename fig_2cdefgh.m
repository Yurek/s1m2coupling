%% plots examples in Figure 2c-h
clear
close all
TrialTypes = {'All','Go','NoGo'};
Titles = {'All','Go','No-go'};

CorType = {'Total','Noise'};
dFb = -0.01;
dFf = 0.01;
Alpha = 0.05;
preStim = 0.45; 
postStim = 1.95;
for ct = 1:numel(CorType)
    n=0;
    addpath('.\utils\linspecer\')
    C = linspecer(3);
    figure('Position',[680+(ct-1)*400 50 373 882], 'name',CorType{ct},'NumberTitle','off')
    for i = 1:numel(TrialTypes)
        ax(i) = subplot(numel(TrialTypes),1,i);
        hold(ax(i),'all')
    end
    for  Ttype =1:numel(TrialTypes)
        n=n+1;
        load(['.\data\CorrMapFin_',CorType{ct},'CCA_5msBin_Dim1_',TrialTypes{Ttype},'.mat'])
        disp(TrialTypes{Ttype})
        [~,dminus] = min(abs(Edata.delays-dFb));
        [~,dplus] = min(abs(Edata.delays-dFf));
        Ds = dminus:dplus;
        [~,tminus] = min(abs(Edata.t_corr-(-.25)));
        [~,tplus] = min(abs(Edata.t_corr-(-0.0)));
        Ts3 = tminus:tplus;
        Cor_ = squeeze(mean(Edata.CorMapAll	(Ds,Ts3,:),1))'; % lick
        Shfl=zeros(size(Cor_,1),size(Cor_,2));
        for i = 1:size(Cor_,1)
            tempColor = Cor_(i, :);
            Shfl(i,:)=tempColor(randperm(numel(tempColor)));
        end
        rng(3)
        CI = bootci(1000,{@mean, Shfl}, 'type','bca','alpha',Alpha);
        CIupper = smooth(CI(2,:),3);
        CIlower = smooth(CI(1,:),3);
        
        [~,tminus] = min(abs(Edata.t_corr-(-preStim)));
        [~,tplus] = min(abs(Edata.t_corr-(+1))); % for stats
        Ts = tminus:tplus;
        [~,tplus] = min(abs(Edata.t_corr-(+postStim))); % for plotting
        Ts_ = tminus:tplus;
        
        Cor = squeeze(mean(Edata.CorMapAll(Ds,Ts,:),1))';
        Cor_p = squeeze(mean(Edata.CorMapAll(Ds,Ts_,:),1))';
        gmFR = squeeze(mean(Edata.FrMap(Ds,Ts_,:),1))';
        CorShf = squeeze(mean(Edata.shflCorMap(Ds,Ts_,:),1))';
        yyaxis(ax(n),'right')
        L1 = plot_shaded_errorbar(ax(n), Edata.t_corr(Ts_), gmFR , C(2,:), 1, '', 0);
%         ylim(ax(n),RYlim(n,:))
        yyaxis(ax(n),'left')
        L2 = plot_shaded_errorbar(ax(n), Edata.t_corr(Ts_), Cor_p, C(1,:), 1, '', 0);
        try
            sbj = cellfun(@(x) split_choose_trim(x, '_',1,''), Edata.recIDs,'UniformOutput', false);
            [p,~,stats] = do_stat_upper(Cor, Cor_, CIupper);
            disp([CorType{ct},' ', TrialTypes{Ttype},' UP p value = ',num2str(p)])
            disp(stats)
        catch
            warning('no upper CI crossing');
        end
        try
            [p,~,stats] = do_stat_lower(Cor, Cor_, CIlower);
            disp([CorType{ct},' ', TrialTypes{Ttype},' DOWN p value = ',num2str(p)])
            disp(stats)
        catch
            warning('no lower CI crossing');
        end
        L3 = plot_shaded_errorbar(ax(n), Edata.t_corr(Ts_), CorShf, [0.5,0.5,0.5], 1, '', 0);
        L4 = plot(ax(n), [-preStim,postStim],[mean(CIupper),mean(CIupper)], '-','color',[.5,.5,.8]);
        plot(ax(n), [-preStim,postStim],[mean(CIlower),mean(CIlower)], '-','color',[.5,.5,.8])
        ax(n).YAxis(1).Color = C(1,:)-.1;
        ax(n).YAxis(2).Color = C(2,:)-.1;
        xlim(ax(n),[-preStim-.03,postStim+0.03])
        ylim(ax(n),[0.29,0.52])
        yyaxis(ax(n),'right')
        ylim(ax(n),[0.013 0.15])
        set(ax(n),'tickdir','out','Color','none','fontsize',20,...
            'LineWidth',1*2.0660,'TickLength',[.03,0.035], 'XColor','k')
        title(ax(n),Titles{Ttype},'FontWeight','normal','FontAngle','italic')
        anArrow = annotation('arrow','LineStyle','-','HeadStyle','cback2','HeadLength',7,'HeadWidth',5);
        anArrow.Parent = ax(n);
        anArrow.Position = [0, 0.14, 0, -0.001];
        anArrow_ = annotation('arrow','LineStyle','-','HeadStyle','cback2',...
            'HeadLength',7,'HeadWidth',5, 'color',[0.6 0.6 0.6]);
        anArrow_.Parent = ax(n);
        anArrow_.Position = [1.2, 0.14, 0, -0.002];
        
    end
end
%%
function [p,h,stats] = do_stat_upper(Cor, Cor_, CIupper)
Cor_Sig = Cor(:,mean(Cor)>mean(CIupper));
size(Cor_Sig)
Cor_Sig = mean(Cor_Sig,2);
Cor_Base = mean(Cor_,2);
[p,h,stats]=signrank(Cor_Sig, Cor_Base);
end
function [p,h,stats] = do_stat_lower(Cor, Cor_, CIlower)
Cor_Sig = Cor(:,mean(Cor)<mean(CIlower));
size(Cor_Sig)
Cor_Sig = mean(Cor_Sig,2);
Cor_Base = mean(Cor_,2);
[p,h,stats]=signrank(Cor_Sig, Cor_Base);
end