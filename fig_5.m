clear
close all
fRow = 3;
fCol = 4;
NegDt = -0.05; % s
PosDt = +0.05; % s
Pre =  0;
Post = 100;
tWind = 10; % ms
addpath('.\utils\linspecer\')
C_ = linspecer(3);
Ylim = [-0.02, 0.1000 ;  -0.02, 0.1500 ; -0.04, 0.1500];
figure('Position',[169 178 1029 711])
for i = 1:fCol*fRow
    ax(i) = subplot(fRow,fCol,i);
    hold(ax(i),'all')
    set(ax(i),'color','none','TickDir','out',...
        'linewidth',1,'ticklength',[0.025,0.035],'fontsize',11)
end
darkMagenta =  [175/255 34/255 175/255];
darkBrown = [190/255 132/255 9/255];
load(".\data\CorrMapFin_NoiseCCA_5msBin_Dim1_All.mat")
[Corr_, t_Corr, Delay] = get_submap(Edata.CorMapAll, Edata.delays, Edata.t_corr,...
    tWind, NegDt, PosDt, Pre, Post);
for i = 1:size(Corr_,3)
    Corr_(:,:,i) = Corr_(:,:,i) - mean2(Corr_(1,:,i));
end
imagesc(ax(1), t_Corr, Delay*1000, mean(Corr_,3))
ylabel(ax(1),'Delay (ms)')
plot(ax(1),[-Pre/1000,Post/1000], [0,0],'-','color',[1,1,1],'linewidth',1.2);
ylim(ax(1), [NegDt*1000,PosDt*1000])
XL = xlabel(ax(1),'Time from air puff (s)');
c = colorbar(ax(1));
c.Position = [0.9308    0.7349    0.0117    0.1266];
dist_S1 = get_submap(Edata.distMapAll_S1, Edata.delays, Edata.t_corr,...
    tWind,  NegDt, PosDt, Pre, Post);
for i = 1:size(dist_S1,3)
    dist_S1(:,:,i) = dist_S1(:,:,i) - mean2(dist_S1(1,:,i));
end
imagesc(ax(1+fCol), t_Corr, Delay*1000, mean(dist_S1,3))
ylabel(ax(1+fCol),'Delay (ms)')
plot(ax(1+fCol),[-Pre/1000,Post/1000], [0,0],'-','color',[1,1,1],'linewidth',1.2);
ylim(ax(1+fCol), [NegDt*1000,PosDt*1000])
XL = xlabel(ax(1+fCol),'Time from air puff (s)');
c = colorbar(ax(1+fCol));
c.Position = [ 0.9308    0.4550    0.0117    0.1266];
dist_M2 = get_submap(Edata.distMapAll_M2, Edata.delays, Edata.t_corr,...
    tWind,  NegDt, PosDt, Pre, Post);
for i = 1:size(dist_M2,3)
    dist_M2(:,:,i) = dist_M2(:,:,i) - mean2(dist_M2(1,:,i));
end
imagesc(ax(1+2*fCol), t_Corr, Delay*1000, mean(dist_M2,3))
ylabel(ax(1+2*fCol),'Delay (ms)')
plot(ax(1+2*fCol),[-Pre/1000,Post/1000], [0,0],'-','color',[1,1,1],'linewidth',1.2);
ylim(ax(1+2*fCol), [NegDt*1000,PosDt*1000])
XL = xlabel(ax(1+2*fCol),'Time from air puff (s)');
c = colorbar(ax(1+2*fCol));
c.Position = [    0.9308    0.1512    0.0117    0.1266];
title(ax(1),{'CCV_t_o_t_a_l'},'fontweight','normal','fontangle','italic')
title(ax(1+fCol),{'S1 similarity'},'fontweight','normal','fontangle','italic')
title(ax(1+2*fCol),{'M2 similarity'},'fontweight','normal','fontangle','italic')
Ylabels = ["CCV_t_o_t_a_l","S1 similarity","M2 similarity"];
C = [C_(1,:); darkMagenta; darkBrown];
for FigRow = 1:3
    switch FigRow
        case 1
            [Map, t_Corr, Delay] = get_submap(Edata.CorMapAll, Edata.delays,...
                Edata.t_corr,tWind, NegDt, PosDt, Pre, Post);
        case 2
            [Map, t_Corr, Delay] = get_submap(Edata.distMapAll_S1, Edata.delays,...
                Edata.t_corr,tWind, NegDt, PosDt, Pre, Post);
        case 3
            [Map, t_Corr, Delay] = get_submap(Edata.distMapAll_M2, Edata.delays,...
                Edata.t_corr,tWind, NegDt, PosDt, Pre, Post);
    end
    for i = 1:size(Map,3)
        Map(:,:,i) = Map(:,:,i) - mean2(Map(1,:,i));
    end
    ylim(ax(1+(FigRow-1)*fCol+1), Ylim(FigRow,:))
    meanCorrPerSess = squeeze(mean(Map,2))';
    plot_shaded_errorbar(ax(1+(FigRow-1)*fCol+1),Delay*1000,...
        meanCorrPerSess,C(FigRow,:), 1,'',0);
    plot(ax(1+(FigRow-1)*fCol+1), [0 0], ax(1+(FigRow-1)*fCol+1).YLim, '-k')
    Leg.ItemTokenSize = [10, 10];
    [Max,indMax] = max(meanCorrPerSess,[],2);
    rng(5)
    DELAYS= Delay(indMax)'*1000;
    if FigRow ==1; DELAYS_ = DELAYS;end
    scatter(ax(1+(FigRow-1)*fCol+2), DELAYS, Max, 15,...
        'o','filled','MarkerFaceColor',C(FigRow,:),'markeredgecolor','none')
    Leg.ItemTokenSize = [10 10];
    ylabel(ax(1+(FigRow-1)*fCol+1), Ylabels(FigRow))
    ylabel(ax(1+(FigRow-1)*fCol+2), "Peak " + Ylabels(FigRow))
    
    plot(ax(1+(FigRow-1)*fCol+2), [0 0], ax(1+(FigRow-1)*fCol+2).YLim, '-k')
    
    xlabel(ax(1+(FigRow-1)*fCol+1), 'Delay (ms)')
    xlabel(ax(1+(FigRow-1)*fCol+2), 'Delay (ms)')
    
    scatter(ax(1+(FigRow-1)*fCol+3),Edata.fracSig_S1, (DELAYS),15,'markerfacecolor',...
        C(FigRow,:), 'markeredgecolor','none')
    plot(ax(1+(FigRow-1)*fCol+3), ax(1+(FigRow-1)*fCol+3).XLim,[0 0], '-k')
    ylabel(ax(1+(FigRow-1)*fCol+3), 'peak \Deltat (ms)' )
    xlabel(ax(1+(FigRow-1)*fCol+3), 'Frac. Sel. S1')
end
xlim(ax([2,3,6,7,10,11]),[-50,50])
%% lme delay and fraction selective S1
Subject = string(cellfun(@(x) split_choose_trim(x,'_',1,''), [Edata.recIDs],'UniformOutput',false));
S1Sel = Edata.fracSig_S1';
tbl = table(DELAYS_, S1Sel, Subject);
Model = 'DELAYS_ ~ S1Sel + (1|Subject)';
mdl = fitlme(tbl,Model);
disp(mdl.Coefficients(2:end,1:6))