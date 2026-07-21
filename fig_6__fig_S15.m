clear
close all
fRow = 3;
fCol = 6;
NegDt = -0.05;  % s
PosDt = +0.05;
Pre = 0;
Post = 100; % ms
tWind = 10;  % ms
CorType = ["Total","Noise"];
FigName = ["S15 Fig","Fig 6"];
for ct = 1:numel(CorType)
    PeakCCVTimes = [];
    PeakS1Sim = [];
    PeakM2Sim = [];
    PeakCCV_Mag = [];
    PeakS1Sim_Mag = [];
    PeakM2Sim_Mag = [];
    if CorType(ct) == "Noise"
        Ylim = [-0.02, 0.1000 ;  -0.02, 0.1500 ; -0.04, 0.1500]; % noise
    else
        Ylim = [-0.02, 0.15000 ;  -0.02, 0.200 ; -0.04, 0.1500];
    end
    addpath('.\utils\linspecer\')
    C_ = linspecer(3);
    darkGreen = [0.4660 0.6740 0.1880];
    darkMagenta =  [175/255 34/255 175/255];
    darkCyan = [0.3010 0.7450 0.9330];
    darkBrown = [190/255 132/255 9/255];
    figure('Position',[100+(ct-1)*300 200-(ct-1)*100 1272 711],...
        'name',FigName(ct)+ ", "+CorType(ct),'NumberTitle','off')
    for i = 1:fCol*fRow
        ax(i) = subplot(fRow,fCol,i);
        hold(ax(i),'all')
        set(ax(i),'color','none','TickDir','out',...
            'linewidth',1,'ticklength',[0.025,0.035],'fontsize',11)
    end
    for Dim = 1:4
        load(".\data\CorrMapFin_"+CorType(ct)+"CCA_5msBin_Dim"+string(Dim)+"_All.mat")
        if CorType(ct)=="Total"
            Ylabels = ["CCV_t_o_t_a_l","S1 similarity","M2 similarity"];
        else
            Ylabels = ["CCV_n_o_i_s_e","S1 similarity","M2 similarity"];
        end
        C = [C_(1,:); darkMagenta; darkBrown];
        for FigRow = 1:3
            switch FigRow
                case 1
                    [Map, ~, Delay] = get_submap(Edata.CorMapAll, Edata.delays,...
                        Edata.t_corr,tWind, NegDt, PosDt, Pre, Post);
                case 2
                    [Map, ~, Delay] = get_submap(Edata.distMapAll_S1, Edata.delays,...
                        Edata.t_corr,tWind, NegDt, PosDt, Pre, Post);
                case 3
                    [Map, ~, Delay] = get_submap(Edata.distMapAll_M2, Edata.delays,...
                        Edata.t_corr,tWind, NegDt, PosDt, Pre, Post);
            end
            for i = 1:size(Map,3)
                Map(:,:,i) = Map(:,:,i)-mean2(Map(1,:,i));
            end
            meanCorrPerSess = squeeze(mean(Map,2))';
            plot_shaded_errorbar(ax((FigRow-1)*fCol+Dim),Delay*1000,...
                meanCorrPerSess,C(FigRow,:), 1,'',0);
            plot(ax((FigRow-1)*fCol+Dim), [0 0], Ylim(FigRow,:), '-k')
            Leg.ItemTokenSize = [10, 10];
            [Max,indMax] = max(meanCorrPerSess,[],2);
            DELAYS= Delay(indMax)'*1000;
            switch FigRow
                case 1
                    PeakCCVTimes = [PeakCCVTimes,Delay(indMax)'*1000];
                    PeakCCV_Mag = [PeakCCV_Mag, Max];
                    
                case 2
                    PeakS1Sim = [PeakS1Sim, Delay(indMax)'*1000];
                    PeakS1Sim_Mag = [PeakS1Sim_Mag, Max];
                case 3
                    PeakM2Sim = [PeakM2Sim, Delay(indMax)'*1000];
                    PeakM2Sim_Mag = [PeakM2Sim_Mag, Max];
            end
            
            ylabel(ax((FigRow-1)*fCol+1), Ylabels(FigRow))
            
            xlabel(ax((FigRow-1)*fCol+Dim), 'Delay (ms)')
            
            ylim(ax((FigRow-1)*fCol+Dim), Ylim(FigRow,:))
            if Dim > 1
                set(ax((FigRow-1)*fCol+Dim), 'yticklabel','')
            end
        end
        
    end
    % plot and perform repeated measure anova over dimensions
    plot_overDim(PeakCCV_Mag, ax(Dim+1));
    [tbl,mcp] = get_ranova(PeakCCV_Mag, 1, 4);
    plot_overDim((PeakCCVTimes), ax(Dim+2));
    [tbl,mcp] = get_ranova(abs(PeakCCVTimes), 1, 4);
    
    plot_overDim(PeakS1Sim_Mag, ax(Dim+fCol+1));
    [tbl,mcp] = get_ranova(PeakS1Sim_Mag, 1, 4);
    plot_overDim((PeakS1Sim), ax(Dim+fCol+2));
    [tbl,mcp] = get_ranova(abs(PeakS1Sim), 1, 4);
    
    plot_overDim(PeakM2Sim_Mag, ax(Dim+2*fCol+1));
    [tbl,mcp] = get_ranova(PeakM2Sim_Mag, 1, 4);
    plot_overDim((PeakM2Sim), ax(Dim+2*fCol+2));
    [tbl,mcp] = get_ranova(abs(PeakM2Sim), 1, 4);
    
    set(ax, 'box','off','color','none')
end

%% FUNCTIONS
function plot_overDim(X, ax)
g = repmat(1:size(X,2), size(X,1), 1);
plot(ax, X', '-', 'color',[0.7,0.7,0.7])
hold(ax,'all')
boxplot(ax, X(:), g(:),'notch','on');
median_lines = findobj(ax, 'Tag', 'Median');
set(median_lines, 'Color', 'g','linewidth',2);
h=findobj('LineStyle','--'); set(h, 'LineStyle','-');
end