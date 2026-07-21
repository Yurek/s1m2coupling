%% plot rasters to be used in the schematic in Fig. 1f
clear
close all
load('.\data\Fig1f.mat')
addpath(genpath('.\utils'))

figure('Position',[350, 509, 924, 322],...
    'name',"Fig. 1f; spike rasters",'NumberTitle','off');
ax(1) = subplot(2,4,[1,2,3]);
ax(2) = subplot(2,4,4);
ax(3) = subplot(2,4,[5,6,7]);
ax(4) = subplot(2,4,8);

% M2
plot_raster(ax(1), raster_M2, preStimT, fs,'color',C_M2, 'markersize',mrkrSz);
title(ax(1),UnitID)

% S1
plot_raster(ax(3), raster_S1, preStimT, fs, 'color',C_S1,'markersize',mrkrSz);
xlabel(ax(3), 'Time from air puff (s)')
xlabel(ax(1), 'Time from air puff (s)')
ylabel(ax(3), 'Trials')
ylabel(ax(1), 'Trials')
set([ax(1),ax(3)], 'tickdir','out','color','none')
set([ax(2),ax(4)], 'visible','off')

