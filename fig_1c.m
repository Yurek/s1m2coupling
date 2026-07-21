%% plots lick rasters in Figure 1c
clear
load('.\data\Fig1c.mat')
addpath(genpath('.\utils'))
nTrls=[];
figure('Position',[789 366 370 420],...
    'name','Lick raster','NumberTitle','off');
ax = subplot(1,1,1);
hold(ax, 'all')
plot(ax, [3.5,3.5],ylim, '-','color','k')
for i = 1: numel(LickRaster)
    nTrls = [nTrls, numel(LickRaster{i})];
    plot_raster(ax, LickRaster{i}, preStimT, fs, ...
        'color',C(i,:), 'markersize',3,'offset',sum(nTrls(1:end-1)));
    plot([-3.8,-3.8],[sum(nTrls(1:end-1)), sum(nTrls)], ...
        '-','color',C(i,:),'LineWidth',2.5)
    drawnow
end
plot(ax,[0,0],ylim, '-','color',[.5,.5,.5])
plot(ax,[mRT, mRT],ylim,'-c')
plot(ax,[preStimT,preStimT],ylim, '-','color','k')
plot(ax,[postStimT,postStimT],ylim, '-','color','k')
set(ax,'YDir','reverse','color','none','TickDir','out')
box(ax, 'off')
xlabel(ax,'Time from air puff (s)')
ylabel(ax,'Trials')
title(ax,SessionID)
