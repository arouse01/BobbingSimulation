function rawCDFcompare(rawPhaseTable, rawIntervalTable, outputTable)

    output112 = outputTable(outputTable.StimTempo==112,:);
    output120 = outputTable(outputTable.StimTempo==120,:);
    output128 = outputTable(outputTable.StimTempo==128,:);
    simPhase112 = rad2deg(cell2mat(output112.PhaseList));
    simPhase120 = rad2deg(cell2mat(output120.PhaseList));
    simPhase128 = rad2deg(cell2mat(output128.PhaseList));
    
    rawPhase112 = rawPhaseTable(rawPhaseTable.Tempo==112 & rawPhaseTable.Group=="Human",:).Phase;
    rawPhase120 = rawPhaseTable(rawPhaseTable.Tempo==120 & rawPhaseTable.Group=="Human",:).Phase;
    rawPhase128 = rawPhaseTable(rawPhaseTable.Tempo==128 & rawPhaseTable.Group=="Human",:).Phase;

    % pd112pS = fitdist(simPhase112, 'kernel','Support',[-180,180]);
    % pd120pS = fitdist(simPhase120, 'kernel','Support',[-180,180]);
    % pd128pS = fitdist(simPhase128, 'kernel','Support',[-180,180]);

    % pd112pR = fitdist(rawPhase112, 'kernel','Support',[-180,180]);
    % pd120pR = fitdist(rawPhase120, 'kernel','Support',[-180,180]);
    % pd128pR = fitdist(rawPhase128, 'kernel','Support',[-180,180]);

    simInterval112 = cell2mat(output112.IntervalList);
    simInterval120 = cell2mat(output120.IntervalList);
    simInterval128 = cell2mat(output128.IntervalList);
    rawInterval112 = rawIntervalTable(rawIntervalTable.Tempo==112 & rawIntervalTable.Group=="Human" & rawIntervalTable.Interval < 1,:).Interval;
    rawInterval120 = rawIntervalTable(rawIntervalTable.Tempo==120 & rawIntervalTable.Group=="Human" & rawIntervalTable.Interval < 1,:).Interval;
    rawInterval128 = rawIntervalTable(rawIntervalTable.Tempo==128 & rawIntervalTable.Group=="Human" & rawIntervalTable.Interval < 1,:).Interval;


    figure

    subplot(3,2,1)
    cdfplot(rawPhase112)
    hold on
    cdfplot(simPhase112)
    title("Phase, 112 bpm")
    legend("Actual Data","Simulated Data")
    hold off

    subplot(3,2,2)
    cdfplot(rawInterval112)
    hold on
    cdfplot(simInterval112)
    title("Interval, 112 bpm")
    xline(60/112, '-k')
    yline(.5, '-k')
    legend("Actual Data","Simulated Data","Stim Tempo")
    hold off

    subplot(3,2,3)
    cdfplot(rawPhase120)
    hold on
    cdfplot(simPhase120)
    title("Phase, 120 bpm")
    legend("Actual Data","Simulated Data")
    hold off

    subplot(3,2,4)
    cdfplot(rawInterval120)
    hold on
    cdfplot(simInterval120)
    title("Interval, 120 bpm")
    xline(60/120, '-k')
    yline(.5, '-k')
    legend("Actual Data","Simulated Data","Stim Tempo")
    hold off

    subplot(3,2,5)
    cdfplot(rawPhase128)
    hold on
    cdfplot(simPhase128)
    title("Phase, 128 bpm")
    legend("Actual Data","Simulated Data")

    hold off
    subplot(3,2,6)
    cdfplot(rawInterval128)
    hold on
    cdfplot(simInterval128)
    title("Interval, 128 bpm")
    xline(60/128, '-k')
    yline(.5, '-k')
    legend("Actual Data","Simulated Data","Stim Tempo")
    hold off

    
end