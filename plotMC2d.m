function plotMC2d(outputTable, humanTable, figTitle)
    ver = 3;
    if ver == 1
        output112 = outputTable(outputTable.StimTempo==112,:);
        output120 = outputTable(outputTable.StimTempo==120,:);
        output128 = outputTable(outputTable.StimTempo==128,:);
        rawTrials112 = humanTable(humanTable.Tempo==112,:);
        rawTrials120 = humanTable(humanTable.Tempo==120,:);
        rawTrials128 = humanTable(humanTable.Tempo==128,:);

        scatter(output112.TempoMean,output112.VectorLengthMean,1,[0.4940 0.1840 0.5560],'.')
        hold on
        scatter(output120.TempoMean,output120.VectorLengthMean,1,[0 0.4470 0.7410],'.')
        scatter(output128.TempoMean,output128.VectorLengthMean,1,[0.3010 0.7450 0.9330],'.')

        scatter(rawTrials112.IntervalMean, rawTrials112.VectorLength, 20,[0.9290 0.6940 0.1250],'filled')
        scatter(rawTrials120.IntervalMean, rawTrials120.VectorLength, 20,[0.8500 0.3250 0.0980],'filled')
        scatter(rawTrials128.IntervalMean, rawTrials128.VectorLength, 20,[0.6350 0.0780 0.1840],'filled')
        scatter([0.530426515,0.532578066,0.529392764,0.530326642], [0.941909817,0.968807053,0.897767361,0.924604733], 40,[0.4660 0.6740 0.1880],"square",'filled')
        scatter([0.495117487 0.493433881 0.492791348 0.492336536], [0.931612749 0.8973519 0.874411389 0.869241151],40,[0.4660 0.6740 0.1880],"square",'filled')
        scatter([0.46578753 0.463689374 0.462084986 0.470531316], [0.960872504 0.894107538 0.829227107 0.825746036], 40,[0.4660 0.6740 0.1880],"square",'filled')
        xlabel("Mean Interval (s)")
        ylabel("Vector Length")
        % zlabel("Mean Phase")
        xline(60/112, '-k')
        xline(60/120, '-k')
        xline(60/128, '-k')
        legend('112 Model', '120 Model', '128 Model', ...
            '112 Human', '120 Human', '128 Human', ...
            'Ronan', '', '')
        hold off

        title(figTitle);

        figure
        scatter(output112.TempoMean,output112.PhaseMean,1,[0.4940 0.1840 0.5560],'.')
        hold on
        scatter(output120.TempoMean,output120.PhaseMean,1,[0 0.4470 0.7410],'.')
        scatter(output128.TempoMean,output128.PhaseMean,1,[0.3010 0.7450 0.9330],'.')

        scatter(rawTrials112.IntervalMean, rad2deg(rawTrials112.PhaseMean),20,[0.9290 0.6940 0.1250],'filled')
        scatter(rawTrials120.IntervalMean, rad2deg(rawTrials120.PhaseMean),20,[0.8500 0.3250 0.0980],'filled')
        scatter(rawTrials128.IntervalMean, rad2deg(rawTrials128.PhaseMean),20,[0.6350 0.0780 0.1840],'filled')
        scatter([0.530426515,0.532578066,0.529392764,0.530326642], [-24.19336632, -27.40893042, -44.01373858, -41.52410116],40,[0.4660 0.6740 0.1880],"square",'filled')
        scatter([0.495117487 0.493433881 0.492791348 0.492336536], [-19.41359107 -31.51781941 -33.3568666 -28.30426237],40,[0.4660 0.6740 0.1880],"square",'filled')
        scatter([0.46578753 0.463689374 0.462084986 0.470531316], [-4.628532905 8.739601183 8.237523807 24.88054188],40,[0.4660 0.6740 0.1880],"square",'filled')
        xlabel("Mean Interval (s)")
        ylabel("Mean Phase")
        % zlabel("Mean Phase")
        xline(60/112, '-k')
        xline(60/120, '-k')
        xline(60/128, '-k')
        legend('112 Model', '120 Model', '128 Model', ...
            '112 Human', '120 Human', '128 Human', ...
            'Ronan', '', '')
        hold off
        title(figTitle);
    
    elseif ver == 2
        output112 = outputTable(outputTable.StimTempo==112,:);
        output120 = outputTable(outputTable.StimTempo==120,:);
        output128 = outputTable(outputTable.StimTempo==128,:);
        rawTrials = humanTable(humanTable.Group=="Human",:);
        rawRonanTrials = humanTable(humanTable.Group~="Human",:);
        
        figure
        subplot(2,1,1)
        scatter(output112.TempoMean,output112.VectorLengthMean,1,[0.4940 0.1840 0.5560],'.')
        hold on
        scatter(output120.TempoMean,output120.VectorLengthMean,1,[0 0.4470 0.7410],'.')
        scatter(output128.TempoMean,output128.VectorLengthMean,1,[0.3010 0.7450 0.9330],'.')

        scatter(rawTrials.IntervalMean, rawTrials.VectorLength, 20,"k+")
        scatter(rawRonanTrials.IntervalMean, rawRonanTrials.VectorLength, 40,"kx")
        % xlabel("Mean Interval (s)")
        ylabel("Vector Length")
        xline(60/112, '-k')
        xline(60/120, '-k')
        xline(60/128, '-k')
        legend('112 Model', '120 Model', '128 Model', 'Human','Ronan')
        hold off
        xticklabels([])

        title(figTitle);

        subplot(2,1,2)
        scatter(output112.TempoMean,output112.PhaseMean,1,[0.4940 0.1840 0.5560],'.')
        hold on
        scatter(output120.TempoMean,output120.PhaseMean,1,[0 0.4470 0.7410],'.')
        scatter(output128.TempoMean,output128.PhaseMean,1,[0.3010 0.7450 0.9330],'.')

        scatter(rawTrials.IntervalMean, rad2deg(rawTrials.PhaseMean), 20,"k+")
        scatter(rawRonanTrials.IntervalMean, rad2deg(rawRonanTrials.PhaseMean), 40,"kx")
        
        xlabel("Mean Interval (s)")
        ylabel("Mean Phase")
        % zlabel("Mean Phase")
        xline(60/112, '-k')
        xline(60/120, '-k')
        xline(60/128, '-k')
        % legend('112 Model', '120 Model', '128 Model', 'Human','Ronan')
        hold off
        ylim([-180 180])
        % title(figTitle);

    elseif ver == 3
        inset = 0.03;

        rawRonanTrials = humanTable(humanTable.Group~="Human",:);
        
        fig = tiledlayout(2,1);
        ax1 = nexttile;
        
        simSD = sqrt(-2*log(outputTable.VectorLengthMean));  % convert vector length to stdev
        h1 = scatter(outputTable.TempoMean,simSD,1,[0.75 0.75 0.75],'.');
        hold on
        box on

        % roSD = sqrt(-2*log(rawRonanTrials.VectorLength));  % convert vector length to stdev
        h2 = scatter(rawRonanTrials.IntervalMean, rawRonanTrials.PhaseStd, 40,"bx");

        label_h = ylabel({"Standard Deviation","(% of Interval)"});
        % label_h.Position(1) = 0.4264; % change horizontal position of ylabel
        xline(60/112, '--k')
        xline(60/120, '--k')
        xline(60/128, '--k')
        l = legend([h2, h1],'Measured sea lion data', 'Simulated human performance', 'EdgeColor', "none");
        l.ItemTokenSize(1) = 10;  % shrink space between symbol and text
        hold off
        
        set(ax1,'XAxisLocation','top')
        xticks(ax1, [60/128, 60/120, 60/112])
        xticklabels({"128 bpm", "120 bpm", "112 bpm"})
        xlim([.44 .56])
        set(gca,'TickDir','None');
        ax1Height = 2.5;
        yticks(ax1, [0+ax1Height*inset,ax1Height*(1-inset)])
        yticklabels({"0",ax1Height})

        ax2 = nexttile;
        scatter(outputTable.TempoMean,outputTable.PhaseMean,1,[0.75 0.75 0.75],'.');
        hold on
        

        scatter(rawRonanTrials.IntervalMean, rad2deg(rawRonanTrials.PhaseMean), 40,"bx");
        
        set(gca,'TickDir','None');
        box on
        
        xline(60/112, '--k')
        xline(60/120, '--k')
        xline(60/128, '--k')
        
        hold off
        ylabel("Mean Phase (\circ)");
        % label_h.Position(1) = 0.4264; % change horizontal position of ylabel
        xlim([.44 .56])
        ylim([-180 180])
        yticks(ax2, [-180+360*inset,0,180-360*inset])
        yticklabels({"-180","0","180"})

        xlabel(fig, "Mean Interval (s)", 'FontSize',10)

        fig.TileSpacing = 'compact';
        fig.Padding = 'compact';
        fontname('Calibri Light')
    end
end
