function [outputData] = bobtrialgroupcompare(rawData)
    % compares phase distributions between groups at each tempo using individual trials

    rawPhaseTable = rawData(~isnan(rawData.Phase)&rawData.Phase <= 180,["Subject","Group","Tempo", "Trial", "Bob","Phase","Phase_Rad","Interval"]);

    roTrials = rawPhaseTable(rawPhaseTable.Group== "Ronan",:);
    humanTrials = rawPhaseTable(rawPhaseTable.Group == "Human",:);

    tempi = [112; 120; 128];
    nTempi = length(tempi);

    outputData = table(tempi);
    for i=1:nTempi

        currTempo = tempi(i);
        currRoTrials = roTrials(roTrials.Tempo==currTempo,:);
        currHumanTrials = humanTrials(humanTrials.Tempo==currTempo,:);
        [phasep, phaseTable] = circ_wwtest(currRoTrials.Phase_Rad, currHumanTrials.Phase_Rad);
        outputData.Phase_p(i) = phasep;
        outputData.Phase_table(i) = {phaseTable};

    end
end