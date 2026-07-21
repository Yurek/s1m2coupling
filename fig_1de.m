%% plot waveforms in Fig. 1d and rasters in Fig. 1e
clear
close all
load('.\data\Fig1de.mat')
addpath(genpath('.\utils'))

FigNames = ["Fig. 1e; hit rasters","Fig. 1d; waveforms e; CR rasters"];
for i = 1:size(raster_M2_cell, 1)
    
    figure('Position',[350+(i-1)*200, 509-(i-1)*200, 924, 322],...
        'name',FigNames(i),'NumberTitle','off');
    ax(1) = subplot(2,4,[1,2,3]);
    ax(2) = subplot(2,4,4);
    ax(3) = subplot(2,4,[5,6,7]);
    ax(4) = subplot(2,4,8);
    % M2
    plot_raster(ax(1), raster_M2_cell{i,2}, preStimT, fs,'color',C_M2, 'markersize',mrkrSz);
    title(ax(1),UnitID{i})
    % S1
    plot_raster(ax(3), raster_S1_cell{i,2}, preStimT, fs, 'color',C_S1,'markersize',mrkrSz);
    if i==2
        t = (1:size(clusterWaveM2,2))/fs*1000;
        plot(ax(2), t, clusterWaveM2(41,:), 'color',C_M2);
        plot(ax(4), t, clusterWaveS1(41,:),'color',C_S1)
    else
        set([ax(2),ax(4)], 'visible','off')
    end
    xlabel(ax(3), 'Time from air puff (s)')
    xlabel(ax(1), 'Time from air puff (s)')
    ylabel(ax(3), 'Trials')
    ylabel(ax(1), 'Trials')
    set([ax(1),ax(3)], 'tickdir','out','color','none')   
end