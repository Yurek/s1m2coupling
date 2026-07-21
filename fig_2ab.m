%% plots examples in Fig. 2a, b
clear
close all
TrialTypes = {'All','Go','NoGo'};
Titles = {'All','Go','No-go'};
CorType = {'Total','Noise'};
dFb = -0.1;
dFf = 0.1;
Caxis = [0,.8];
Recs = {'ep17_240110', 'ep20_240404'};
for ct = 1:numel(CorType)
    figure('Position',[680+(ct-1)*200 546-(ct-1)*200 919 432],...
        'name',"Fig. 1, "+CorType{ct},'NumberTitle','off')
    for i=1:6
        ax(i) = subplot(3,2,i);
        hold(ax(i), 'all')
    end
    C = [ 0.3555, 0.3555, 0.3555];
    n=0;
    for  Ttype = 1:numel(TrialTypes)
        n=n+1;
        for rec = 1:2
            load(['.\data\CorrMapFin_',CorType{ct},'CCA_5msBin_Dim1_',TrialTypes{Ttype},'.mat'])
            IDX = Edata.recIDs==Recs{rec};
            [~,dminus] = min(abs(Edata.delays-dFb));
            [~,dplus] = min(abs(Edata.delays-dFf));
            Ds = dminus:dplus;
            Pre = 350; % ms
            Post = 1900; % ms
            wStep = 10; % m
            [~,idx] = min(abs(Edata.t_corr - 0));  % align to event
            Corr = Edata.CorMapAll(Ds, idx-Pre/wStep:idx+Post/wStep,IDX);
            t_Corr = Edata.t_corr(idx-Pre/wStep:idx+Post/wStep);
            PSLH = Edata.PSLH(IDX,idx-Pre/wStep:idx+Post/wStep);
            if string(Recs{rec})=="ep17_240110"
                nax = n*2-1;
                if Ttype==1
                    ttl = title(ax(nax), [Titles{Ttype},'               ',CorType{ct},'  (a)'],...
                        'fontweight','normal','fontangle','italic');
                else
                    ttl = title(ax(nax), Titles{Ttype},'fontweight','normal','fontangle','italic');
                end

                ttl.Units = 'Normalize';
                ttl.Position(1) = 0;
                ttl.HorizontalAlignment = 'left';
            else
                nax = n*2;
                if Ttype==1
                    ttl = title(ax(nax), [Titles{Ttype},'               ',CorType{ct},'  (b)'],...
                        'fontweight','normal','fontangle','italic');
                else
                    ttl = title(ax(nax), Titles{Ttype},'fontweight','normal','fontangle','italic');
                end
                ttl.Units = 'Normalize';
                ttl.Position(1) = 0;
                ttl.HorizontalAlignment = 'left';
            end
            delays = Edata.delays(dminus:dplus);
            imagesc(ax(nax), t_Corr, delays, Corr, Caxis)
            ax(nax).YDir = 'Normal';
            ax(nax).XLim = [-Pre/1000,Post/1000];
            yyaxis(ax(nax),'right')
            plot(ax(nax), t_Corr, PSLH,'color', C)
            ylim(ax(nax), [0,25])
            ax(nax).YAxis(2).Color = C;
            ax(nax).YLabel.String = 'licks/s';
            drawnow
            set(ax(nax), 'TickDir', 'out','color','none',...
                'linewidth',1,'ticklength',[0.02,0.035],'fontsize',10)
            yyaxis(ax(nax),'left')
            ax(nax).XColor = ax(nax).YColor;
            ax(nax).YLabel.String = 'Delay (ms)';
        end
    end
end