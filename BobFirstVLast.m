function [outputData] = BobFirstVLast()

    tempi = [112; 120; 128];
    nTempi = length(tempi);

    rawTable = readtable('all subjects_checked.xlsx','Sheet','Raw', Range="A:H",ReadVariableNames=true);
    rawTable.Phase_Rad = deg2rad(rawTable.Phase(:));
    rawTable = rawTable(~isnan(rawTable.Phase),:);
    subjects = unique(rawTable.Subject);
    nSubjects = length(subjects);

    outputData = varfun(@circ_mean, rawTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo"]);
    outputData = outputData(:,["Subject","Tempo"]);

    % split bobs by bobs 1:12 and bobs 12:end
    for i=1:nSubjects
        currData = rawTable(strcmp(rawTable.Subject, subjects{i}),:);
        for j=1:nTempi
            k = (i-1)*nTempi+j;
            currTempo = tempi(j);
            currTempoData = currData(currData.Tempo==currTempo,:);
            firstHalf = currTempoData(currTempoData.Bob<12,:);
            secondHalf = currTempoData(currTempoData.Bob>=12,:);
            firstHalfMean = circ_mean(firstHalf.Phase_Rad);
            secondHalfMean = circ_mean(secondHalf.Phase_Rad);
            outputData.FirstHalfMean(k) = firstHalfMean;
            outputData.SecondHalfMean(k) = secondHalfMean;

            [p, pTable] = circ_wwtest(firstHalf.Phase_Rad, secondHalf.Phase_Rad);
            outputData.WWPhase_table(k) = {pTable};
            outputData.F(k) = pTable(2,5);
            outputData.WWPhase_p(k) = p;

        end
    end
end