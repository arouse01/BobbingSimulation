function [outputData] = HumanBobLearning()

    tempi = [112; 120; 128];
    nTempi = length(tempi);

    rawTable = readtable('all subjects_checked.xlsx','Sheet','Raw', Range="A:H",ReadVariableNames=true);
    rawTable.Phase_Rad = deg2rad(rawTable.Phase(:));
    rawTable = rawTable(~isnan(rawTable.Phase),:);
    rawTable = rawTable(rawTable.Group=="Human",:);
    subjects = unique(rawTable.Subject);
    nSubjects = length(subjects);
    
    outputData = varfun(@circ_mean, rawTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo"]);
    outputData = outputData(:,["Subject","Tempo"]);
    
    % Compare first trial at tempo to last trial at tempo
    for i=1:nSubjects
        currData = rawTable(strcmp(rawTable.Subject, subjects{i}),:);
        for j=1:nTempi
            k = (i-1)*nTempi+j;
            currTempo = tempi(j);
            currTempoData = currData(currData.Tempo==currTempo,:);
            firstTrialNum = min(currTempoData.Trial);
            lastTrialNum = max(currTempoData.Trial);
            firstTrial = currTempoData(currTempoData.Trial==firstTrialNum,:);
            lastTrial = currTempoData(currTempoData.Bob==lastTrialNum,:);
            firstTrialMean = circ_mean(firstTrial.Phase_Rad);
            lastTrialMean = circ_mean(lastTrial.Phase_Rad);
            outputData.FirstTrialMean(k) = firstTrialMean;
            outputData.LastTrialMean(k) = lastTrialMean;

            [p, pTable] = circ_wwtest(firstTrial.Phase_Rad, lastTrial.Phase_Rad);
            outputData.WWPhase_table(k) = {pTable};
            outputData.F(k) = pTable(2,5);
            outputData.WWPhase_p(k) = p;

        end
    end
end