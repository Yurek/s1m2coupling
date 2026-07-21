clear
close all
TrialTypes = {'All','Go','NoGo'};
CorrType = ["Total","Noise"];
NegDt = -0.05; % s
PosDt = +0.05; % s
Pre = 150; % ms
Post = 250; % ms
tWind = 10; % ms
addpath('.\utils\linspecer\')
C = linspecer(3);
C_patch = [.95 .95 .95];
C_L = [190/256,140/256, 226/256];
figure('Position',[457 466 500 462],'name','ccv','NumberTitle','off')
for i = 1:6
    ax(i) = subplot(3,2,i); hold(ax(i),'all')
    set(ax(i),'YDir','normal','tickdir','out','box','off','color','none',...
        'ticklength',[0.03,0.35],'LineWidth',1)
    axis(ax(i),'square')
end
AxIdx = [1,3,5,2,4,6];
n = 1;
for corTyp = 1:2
    for ttype = 1:numel(TrialTypes)
        
        load(".\data\CorrMapFin_"+CorrType(corTyp)+"CCA_5msBin_Dim1_"+string(TrialTypes{ttype})+".mat")
        %%
        [Corr_, t_Corr, Delay] = get_submap(Edata.CorMapAll, Edata.delays, Edata.t_corr,...
            tWind, NegDt, PosDt, Pre, Post);
        if corTyp ==1
            Caxis = [0.2,.6];
        else
            Caxis = [0.2,0.5];
        end
        imagesc(ax(AxIdx(n)), t_Corr*1000, Delay*1000, mean(Corr_,3),Caxis)
        title(ax(AxIdx(n)), CorrType(corTyp)+ ", " + string(TrialTypes{ttype}), ...
            'fontweight','normal','fontangle','italic')
        n=n+1;
    end
end
ylabel(ax(3),'Delay (ms)')
ylabel(ax(4),'Delay (ms)')
xlabel(ax(5),'Time from air puff (ms)');
xlabel(ax(6),'Time from air puff (ms)');
for i = 1:numel(ax)
    ax(i).XLim = [-Pre,Post];
end
