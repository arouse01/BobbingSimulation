function plotMC2d(outputTable, ronanTable, figTitle)

    inset = 0.03;

    rawRonanTrials = ronanTable(ronanTable.Group~="Human",:);

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

