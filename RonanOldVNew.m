function [outputData] = RonanOldVNew()

    rawTable = readtable('ronan old v new reformat.xlsx','Sheet','Concatenated', Range="A:G",ReadVariableNames=true);
    rawTable.Phase_Rad = deg2rad(rawTable.Phase(:));
    rawTable = rawTable(~isnan(rawTable.Phase),:);

    oldTrials = rawTable(rawTable.Old_New == "Old",:);
    newTrials = rawTable(rawTable.Old_New == "New",:);
    tempi = [80; 96; 108; 120];
    nTempi = length(tempi);
    
    outputData = table(tempi);
    
    for i=1:nTempi

        currTempo = tempi(i);
        currOldTrials = oldTrials(oldTrials.Tempo==currTempo,:);
        currNewTrials = newTrials(newTrials.Tempo==currTempo,:);
        [phasep, phaseTable] = circ_wwtest(currOldTrials.Phase_Rad, currNewTrials.Phase_Rad);
        outputData.OvNPhase_p(i) = phasep;
        outputData.OvNPhase_table(i) = {phaseTable};
        [h, p] = ttest(currOldTrials.Interval, currNewTrials.Interval);
        outputData.OvNInt_p(i) = p;
        outputData.Int_h(i) = h;
        
        % % V test
        outputData.OldPhase_u(i) = circ_mean(currOldTrials.Phase_Rad);
        outputData.OldPhase_uDeg(i) = rad2deg(circ_mean(currOldTrials.Phase_Rad));
        outputData.OldPhase_Vec(i) = circ_r(currOldTrials.Phase_Rad);
        [p, zVal] = circ_vtest((currOldTrials.Phase_Rad), 0);
        outputData.OldPhase_z(i) = zVal;
        outputData.OldPhase_p(i) = p;
        
        outputData.NewPhase_u(i) = circ_mean(currNewTrials.Phase_Rad);
        outputData.NewPhase_uDeg(i) = rad2deg(circ_mean(currNewTrials.Phase_Rad));
        outputData.NewPhase_Vec(i) = circ_r(currNewTrials.Phase_Rad);
        [p, zVal] = circ_vtest((currNewTrials.Phase_Rad), 0);
        outputData.NewPhase_z(i) = zVal;
        outputData.NewPhase_p(i) = p;
    end
    
end