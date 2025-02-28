function [outputData] = RonanVHumanAngles()

    rawTable = readtable('all subjects_checked.xlsx','Sheet','Raw', Range="A:H",ReadVariableNames=true);
    rawTable.Phase_Rad = deg2rad(rawTable.Phase(:));
    rawTable = rawTable(~isnan(rawTable.Phase),:);
    rawRonan = rawTable(rawTable.Group~="Human",:);
    rawHuman = rawTable(rawTable.Group=="Human",:);
    [trialData,groupData] = bobtrialanalysis(rawTable,0);
    ronanTrials = trialData(trialData.Group~="Human",:);
    nTrials = height(ronanTrials);
    humanTrials = groupData(groupData.Group=="Human",:);

    outputData = ronanTrials;
    
    for i=1:nTrials

        currTempo = ronanTrials.Tempo(i);
        currHumanData = humanTrials(humanTrials.Tempo==currTempo,:);
        phaseMean = currHumanData.PhaseMean_Trial;
        currTrial = ronanTrials.Trial(i);

        roBobs = rawRonan(rawRonan.Trial==currTrial,:);
        humanBobs = rawHuman(rawHuman.Tempo==currTempo,:);

        [p, zVal] = circ_vtest(deg2rad(roBobs.Phase), phaseMean);
        outputData.Pop_Phase_u(i) = phaseMean;
        outputData.Phase_z(i) = zVal;
        outputData.Phase_p(i) = p;
        [p, pTable] = circ_wwtest(roBobs.Phase_Rad, humanBobs.Phase_Rad);
        outputData.WWPhase_table(i) = {pTable};
        outputData.WWPhase_p(i) = p;


    end

end