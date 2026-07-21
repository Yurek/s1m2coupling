% from plotCCA_2.m
% fig 5 and S5 (SignalCCA folder)
clear
close all
% TrialTypes = {'lefttrllick'};
% TrialTypes = {'alltrials','hit','right','fa','miss'};
MedSIfrc  = 0.2866;
NegDt = -0.05; %s default:0.11
PosDt = +0.05; %s default:0.11
DFB = [0.000 , -0.015];
DFF = [0.01 , -0.005];
FeedType = ["FF", "FB"];
TrialTypes = {'All'};
Pre = 50; %ms
Post = 200; %ms
tWind = 10; %ms
Caxis = [[0.2, 0.5];[0.2, 0.6]];
Caxis_ = [[0.0,0.4];[0.0,0.4]];
addpath('.\utils\linspecer\')
C = linspecer(3);
darkMagenta =  [175/255 34/255 175/255];
darkBrown = [190/255 132/255 9/255];
p = zeros(6,2);
figPos = [[457 347 483 581];[947 346 483 581]];
cBarTicks={0.2:0.1:0.5, 0.2:0.2:0.6};
N = 0;
for CorType = ["Total", "Noise"]
    N = N + 1;
    
    for Ttype = 1:numel(TrialTypes)
        load(".\data\CorrMapFin_"+CorType+"CCA_5msBin_Dim1_"+string(TrialTypes{Ttype})+".mat")
        figure('Position',figPos(N,:),'name',TrialTypes{Ttype},'NumberTitle','off')
        for i = 1:9
            ax(i) = subplot(3,3,i); hold(ax(i),'all')
            set(ax(i),'YDir','normal','tickdir','out','box','off','color','none',...
                'ticklength',[0.03,0.35],'LineWidth',1)
            axis(ax(i),'square')
        end
        CCV = cell(2,1);
        S1Sim = cell(2,1);
        M2Sim = cell(2,1);
        for ds = 1:numel(DFB)
            dFb = DFB(ds);
            dFf = DFF(ds);
            [Corr_, t_Corr, Delay] = get_submap(Edata.CorMapAll, Edata.delays, Edata.t_corr,...
                tWind, NegDt, PosDt, Pre, Post);
            shfCorr_ = get_submap(Edata.shflCorMap, Edata.delays, Edata.t_corr,...
                tWind, NegDt, PosDt, Pre, Post);
            dist_S1 = get_submap(Edata.distMapAll_S1, Edata.delays, Edata.t_corr,...
                tWind, NegDt, PosDt, Pre, Post);
            dist_M2 = get_submap(Edata.distMapAll_M2, Edata.delays, Edata.t_corr,...
                tWind, NegDt, PosDt, Pre, Post);
            if ds==1
                imagesc(ax(1), t_Corr, Delay*1000, mean(Corr_,3),Caxis(N,:))
                plot(ax(1), [ax(1).XLim(1),0], [dFb*1000, dFb*1000], 'color',[1,1,1])
                plot(ax(1), [ax(1).XLim(1),0], [dFf*1000, dFf*1000], 'color',[1,1,1])
                ylabel(ax(1),'Delay (ms)')
                title(ax(1),['CCV','\_',char(lower(CorType))],'fontweight','normal','fontangle','italic')
                c1 = colorbar(ax(1),'Position',[0.3269 0.9 0.0112 0.0929]);
                c1.Ticks = cBarTicks{N};
                
                imagesc(ax(2), t_Corr, Delay*1000, mean((dist_S1),3),Caxis_(N,:))
                plot(ax(2), [ax(2).XLim(1),0], [dFb*1000, dFb*1000], 'color',[1,1,1])
                plot(ax(2), [ax(2).XLim(1),0], [dFf*1000, dFf*1000], 'color',[1,1,1])
                title(ax(2),'Similarity in S1','fontweight','normal','fontangle','italic')
                c2 = colorbar(ax(2),'Position',[ 0.6275   0.9    0.0112    0.0929]);
                
                imagesc(ax(3), t_Corr, Delay*1000, mean((dist_M2),3),Caxis_(N,:))
                plot(ax(3), [ax(3).XLim(1),0], [dFb*1000, dFb*1000], 'color',[1,1,1])
                plot(ax(3), [ax(3).XLim(1),0], [dFf*1000, dFf*1000], 'color',[1,1,1])
                title(ax(3),'Similarity in M2','fontweight','normal','fontangle','italic')
                c3 = colorbar(ax(3),'Position',[ 0.9215   0.9    0.0112    0.0929]);
            end
            
            % get baseline CI
            [~,tminus] = min(abs(t_Corr-(-0.05)));
            [~,tplus] = min(abs(t_Corr-(-0)));
            Ts3 = tminus:tplus;
            [~,dminus] = min(abs(Delay-dFb));
            [~,dplus] = min(abs(Delay-dFf));
            Delay_ = dminus:dplus;
            [~,dminus] = min(abs(Delay-(-0.05)));
            [~,dplus] = min(abs(Delay-(-0.04)));
            Delay_fbc1 = dminus:dplus;
            [~,dminus] = min(abs(Delay-(0.04)));
            [~,dplus] = min(abs(Delay-(0.05)));
            Delay_fbc2 = dminus:dplus;
            
            meanCorrPerSess = squeeze(mean(Corr_(Delay_,:,:),1))';
            meanShfCorrPerSess = squeeze(mean(shfCorr_(Delay_,:,:),1))';
            meanDistBPerSess = squeeze(mean((dist_S1(Delay_,:,:)),1))';
            meanDistAPerSess = squeeze(mean((dist_M2(Delay_,:,:)),1))';
            
            L1 = plot_shaded_errorbar(ax(1+ds*3), t_Corr, meanCorrPerSess, C(1,:), 1, '', 0);
            L1_ = plot_shaded_errorbar(ax(1+ds*3), t_Corr, meanShfCorrPerSess, [0.6,.6,.6], 1, '', 0);
            base = squeeze(mean(Corr_(Delay_,Ts3,:),1))';
            X = squeeze(mean(Corr_(Delay_,:,:),1))';
            [~,t_1] = min(abs(t_Corr-(0.0)));
            [~,t_2] = min(abs(t_Corr-(0.1)));
            CCV{ds}  = X(:,t_1:t_2);
            [CIupper, CIlower] = get_ci(base);
            disp([char(CorType), ' Corr ', char(FeedType(ds)),':',])
            p(1,ds) = do_stat_upper(X, base, CIupper);
            p(2,ds) = do_stat_lower(X, base, CIlower);
            L4 = plot(ax(1+ds*3), [-Pre/1000,Post/1000],[mean(CIupper),mean(CIupper)], '-','color',[.5,.5,.8]);
            plot(ax(1+ds*3), [-Pre/1000,Post/1000],[mean(CIlower),mean(CIlower)], '-','color',[.5,.5,.8])
            title(ax(1+ds*3), {['p_u_p = ',num2str(p(1,ds))];['p_d_o_w_n = ',num2str(p(2,ds))]},...
                'fontweight','normal')
            
            L2 = plot_shaded_errorbar(ax(2+ds*3), t_Corr, meanDistBPerSess, darkMagenta, 1, '', 0);
            S1_base = squeeze(mean(dist_S1(Delay_,Ts3,:),1))';
            S1 = squeeze(mean(dist_S1(Delay_,:,:),1))';
            S1Sim{ds}  = S1(:,t_1:t_2);
            [CIupper, CIlower] = get_ci(S1_base);
            disp([char(CorType), ' S1 ', char(FeedType(ds)),':',])
            p(3,ds) = do_stat_upper(S1, S1_base, CIupper);
            p(4,ds) = do_stat_lower(S1, S1_base, CIlower);
            L4 = plot(ax(2+ds*3), [-Pre/1000,Post/1000],[mean(CIupper),mean(CIupper)], '-','color',[.5,.5,.8]);
            plot(ax(2+ds*3), [-Pre/1000,Post/1000],[mean(CIlower),mean(CIlower)], '-','color',[.5,.5,.8])
            title(ax(2+ds*3), {['p_u_p = ',num2str(p(3,ds))];['p_d_o_w_n = ',num2str(p(4,ds))]},...
                'fontweight','normal')
            
            L3 = plot_shaded_errorbar(ax(3+ds*3), t_Corr, meanDistAPerSess, darkBrown, 1, '', 0);
            M2_base = squeeze(mean(dist_M2(Delay_,Ts3,:),1))';
            M2 = squeeze(mean(dist_M2(Delay_,:,:),1))';
            M2Sim{ds}  = M2(:,t_1:t_2);
            [CIupper, CIlower] = get_ci(M2_base);
            disp([char(CorType), ' M2 ', char(FeedType(ds)),':',])
            p(5,ds) = do_stat_upper(M2, M2_base, CIupper);
            p(6,ds) = do_stat_lower(M2, M2_base, CIlower);
            L4 = plot(ax(3+ds*3), [-Pre/1000,Post/1000],[mean(CIupper),mean(CIupper)], '-','color',[.5,.5,.5]);
            plot(ax(3+ds*3), [-Pre/1000,Post/1000],[mean(CIlower),mean(CIlower)], '-','color',[.5,.5,.5])
            title(ax(3+ds*3), {['p_u_p = ',num2str(p(5,ds))];['p_d_o_w_n = ',num2str(p(6,ds))]},...
                'fontweight','normal')
        end
        [p,~,stats] = signrank(mean(CCV{1},2),mean(CCV{2},2));
        disp(" ------- "+CorType+" CCV, p = " + string(p))
        disp(stats)
                [p,~,stats] = signrank(mean(S1Sim{1},2),mean(S1Sim{2},2));
        disp(" --------S1Sim, p = " + string(p))
        disp(stats)
         [p,~,stats] = signrank(mean(M2Sim{1},2),mean(M2Sim{2},2));
        disp(" --------M2Sim, p = " + string(p))
        disp(stats)
    end
end
xl = xlabel(ax(8),'Time from air puff (s)');
xl.Position(1) = xl.Position(1)-0.05;

%% FUNCTIONS
function [CIupper, CIlower] = get_ci(Cor_)
Shfl=zeros(size(Cor_,1),size(Cor_,2));
for i = 1:size(Cor_,1)
    tempColor = Cor_(i, :);
    Shfl(i,:)=tempColor(randperm(numel(tempColor)));
end
rng(3)
CI = bootci(1000,{@mean, Shfl}, 'type','bca','alpha',0.05);
CIupper = smooth(CI(2,:),3);
CIlower = smooth(CI(1,:),3);
end

function [p,h] = do_stat_upper(Cor, Cor_, CI_upper)
Cor_Sig = Cor(:,mean(Cor)>mean(CI_upper));
Cor_Sig = mean(Cor_Sig,2);
Cor_Base = mean(Cor_,2);
try
    [p,h,stats]=signrank(Cor_Sig, Cor_Base);
    if p >= 0.0001
        disp(['     UP p value = ',sprintf('%0.5f',p)])
        disp(stats)
    else
        disp(['     UP p value = ',sprintf('%0.2e',p)])
        disp(stats)
    end
catch
    p = NaN;
    disp(['     UP p value = ',sprintf('%0.5f',p)])
end
end

function [p,h] = do_stat_lower(Cor, Cor_, CI_lower)
Cor_Sig = Cor(:,mean(Cor)<mean(CI_lower));
Cor_Sig = mean(Cor_Sig,2);
Cor_Base = mean(Cor_,2);
try
    [p,h,stats]=signrank(Cor_Sig, Cor_Base);
    if p >= 0.0001
        disp(['     DOWN p value = ',sprintf('%0.5f',p)])
        disp(stats)
    else
        disp(['     DOWN p value = ',sprintf('%0.2e',p)])
        disp(stats)
    end
catch
    p = NaN;
    disp(['     DOWN p value = ',sprintf('%0.5f',p)])
end
end