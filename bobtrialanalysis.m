function [outputTable, groupMeans, subjectMeans, table2Output] = bobtrialanalysis(rawData, threshold)
    % gives individual trial analysis from the giant list of all intervals and phases by trial
    % rawData = readtable('all subjects_checked.xlsx','Sheet','Raw', Range="A:H",ReadVariableNames=true);
    rawData.Phase_Rad = deg2rad(rawData.Phase(:));
    rawPhaseTable = rawData(~isnan(rawData.Phase)&rawData.Phase <= 180,["Subject","Group","Tempo", "Trial", "Bob","Phase","Phase_Rad"]);
    % 

    means = varfun(@circ_mean, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"]);
    vectors = varfun(@circ_r, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"]);
    % v test
    vTestfunc = @(x)circ_vtest(x,0);
    vTest = rowfun(vTestfunc, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"], "OutputVariableNames",["VTestp","vTestz"]);

    rTest = rowfun(@circ_rtest, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"], "OutputVariableNames",["RTestp","RTestz"]);
    % means = renamevars(means,"circ_mean_Phase_Rad","Phase_Mean");

    rawIntervalTable = rawData(~isnan(rawData.Interval) & rawData.Interval < 1,["Subject","Group","Tempo", "Trial", "Bob","Interval"]);
    rawIntervalTable.InstTempo = 60./rawIntervalTable.Interval;
    intervalStats = groupsummary(rawIntervalTable,["Subject","Group","Tempo", "Trial"],["mean","std"],"Interval");
    tempoStats = groupsummary(rawIntervalTable,["Subject","Group","Tempo", "Trial"],["mean","std"],"InstTempo");

    outputTable = means(:,["Subject","Group","Trial","Tempo","circ_mean_Phase_Rad"]);
    outputTable = join(outputTable,vectors(:,["Subject","Trial","circ_r_Phase_Rad"]),'Keys',["Subject","Trial"]);
    outputTable.PhaseStd = sqrt(-2*log(outputTable.circ_r_Phase_Rad));
    % outputTable.VectorLength = vectors(vectors.Group=="Human",:).circ_r_Phase_Rad;
    outputTable = join(outputTable,rTest(:,["Subject","Trial","RTestp","RTestz"]),'Keys',["Subject","Trial"]);
    outputTable = join(outputTable,vTest(:,["Subject","Trial","VTestp","vTestz"]),'Keys',["Subject","Trial"]);
    
    outputTable = join(outputTable,intervalStats(:,["Subject","Trial","mean_Interval","std_Interval"]),'Keys',["Subject","Trial"]);
    outputTable = join(outputTable,tempoStats(:,["Subject","Trial","mean_InstTempo","std_InstTempo"]),'Keys',["Subject","Trial"]);
    % outputTable.Interval_Mean = intervalStats(intervalStats.Group=="Human",:).mean_Interval;
    % outputTable.Interval_Std = intervalStats(intervalStats.Group=="Human",:).std_Interval;

    % outputTable.VectorLength = vectors(vectors.Group=="Human",:).circ_r_Phase_Rad;

    outputTable = renamevars(outputTable,["circ_mean_Phase_Rad","circ_r_Phase_Rad","mean_Interval","std_Interval","mean_InstTempo","std_InstTempo"], ...
        ["PhaseMean","VectorLength","IntervalMean","IntervalStd","TempoMean","TempoStd"]);
    outputTable.RTestSig = outputTable.RTestp < 0.05;
    outputTable.VTestSig = outputTable.VTestp < 0.05;
    
    % get averages across trial averages
    means_group = varfun(@circ_mean, outputTable(:,["Subject","Group","Tempo","Trial","PhaseMean","VectorLength"]), "InputVariables",["PhaseMean","VectorLength"], "GroupingVariables",["Group","Tempo"]);
    vectors_group = varfun(@circ_r, outputTable(:,["Subject","Group","Tempo","Trial","PhaseMean"]), "InputVariables","PhaseMean", "GroupingVariables",["Group","Tempo"]);
    intervalStats_group = groupsummary(rawIntervalTable,["Group","Tempo"],["mean","std"],"InstTempo");
    % outputTable(:,["Subject","Group","Tempo","Trial","TempoMean"]),["Group","Tempo"],["mean","std"],"TempoMean");
    RTest_group = groupsummary(outputTable(:,["Subject","Group","Tempo","Trial","RTestSig"]),["Group","Tempo"],"sum","RTestSig");
    VTest_group = groupsummary(outputTable(:,["Subject","Group","Tempo","Trial","VTestSig"]),["Group","Tempo"],"sum","VTestSig");
    groupMeans = means_group(:,["Group","Tempo","circ_mean_PhaseMean"]);
    groupMeans = renamevars(groupMeans, "circ_mean_PhaseMean", "PhaseMean_Trial");
    groupMeans.VectorLength = vectors_group.circ_r_PhaseMean;
    groupMeans.PhaseStd = sqrt(-2*log(groupMeans.VectorLength));
    groupMeans.TempoMean = intervalStats_group.mean_InstTempo;
    groupMeans.TempoStd = intervalStats_group.std_InstTempo;
    groupMeans.RTestn = RTest_group.sum_RTestSig;
    groupMeans.VTestn = VTest_group.sum_VTestSig;
    groupMeans.n = VTest_group.GroupCount;

    means_trial = varfun(@circ_mean, outputTable(:,["Subject","Group","Tempo","Trial","PhaseMean"]), "InputVariables","PhaseMean", "GroupingVariables",["Group","Subject","Tempo"]);
    vectors_trial = varfun(@circ_r, outputTable(:,["Subject","Group","Tempo","Trial","PhaseMean"]), "InputVariables","PhaseMean", "GroupingVariables",["Group","Subject","Tempo"]);
    intervalStats_trial = groupsummary(outputTable(:,["Subject","Group","Tempo","Trial","IntervalMean","TempoMean"]),["Group","Subject","Tempo"],["mean","std"],["IntervalMean","TempoMean"]);
    subjectMeans= means_trial(:,["Group","Subject","Tempo","circ_mean_PhaseMean"]);
    subjectMeans = renamevars(subjectMeans, "circ_mean_PhaseMean", "PhaseMean_Trial");
    subjectMeans.VectorLength_Trial = vectors_trial.circ_r_PhaseMean;
    subjectMeans.PhaseStd_Trial = sqrt(-2*log(subjectMeans.VectorLength_Trial));
    subjectMeans.IntervalMean_Trial = intervalStats_trial.mean_IntervalMean;
    subjectMeans.IntervalStd_Trial = intervalStats_trial.std_IntervalMean;
    subjectMeans.TempoMean_Trial = intervalStats_trial.mean_TempoMean;
    subjectMeans.TempoStd_Trial = intervalStats_trial.std_TempoMean;
    subjectMeans.PhaseMeanDeg = rad2deg(subjectMeans.PhaseMean_Trial);

    intervalStats_table = groupsummary(outputTable(:,["Subject","Group","Tempo","Trial","TempoMean"]),["Group","Subject","Tempo"],"mean","TempoMean");
    intervalStats_std = groupsummary(rawIntervalTable,["Group","Subject","Tempo"],"std","InstTempo");
    vectors_table = groupsummary(outputTable(:,["Subject","Group","Tempo","Trial","VectorLength"]),["Group","Subject","Tempo"],"mean","VectorLength");
    
    table2Output = intervalStats_table(:,["Subject","Tempo"]);
    table2Output.MeanTempo = intervalStats_table.mean_TempoMean;
    table2Output.Std = intervalStats_std.std_InstTempo;
    table2Output.Angle = rad2deg(subjectMeans.PhaseMean_Trial);
    table2Output.VectorLength = vectors_table.mean_VectorLength;

    intervalStats_tableAll = groupsummary(intervalStats_trial(:,["Group","Tempo","mean_TempoMean"]),["Group","Tempo"],["mean","std"],"mean_TempoMean");
    % intervalStats_stdAll = groupsummary(rawIntervalTable,["Subject","Group","Tempo"],"std","InstTempo");
    means_trialAll = varfun(@circ_mean, subjectMeans(:,["Group","Tempo","PhaseMean_Trial"]), "InputVariables","PhaseMean_Trial", "GroupingVariables",["Group","Tempo"]);
    vectors_tableAll = groupsummary(vectors_table(:,["Group","Tempo","mean_VectorLength"]),["Group","Tempo"],"mean","mean_VectorLength");
    table2All = intervalStats_tableAll(intervalStats_tableAll.Group=="Human", ["Group","Tempo"]);
    meanTempo = intervalStats_tableAll(intervalStats_tableAll.Group=="Human", :);
    table2All.MeanTempo = meanTempo.mean_mean_TempoMean;
    table2All.Std = meanTempo.std_mean_TempoMean;
    phases = means_trialAll(means_trialAll.Group=="Human",:);
    table2All.Angle = rad2deg(phases.circ_mean_PhaseMean_Trial);
    vectorLength = vectors_tableAll(vectors_tableAll.Group=="Human",:);
    table2All.VectorLength = vectorLength.mean_mean_VectorLength;

    if threshold > 0
        outputTable = outputTable(outputTable.VectorLength > threshold, :);

    end
