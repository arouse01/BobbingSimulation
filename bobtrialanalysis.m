function [outputTable, outputMeans] = bobtrialanalysis(rawData, threshold)
    % gives individual trial analysis from the giant list of all intervals and phases by trial
    % rawData = readtable('all subjects_checked.xlsx','Sheet','Raw', Range="A:H",ReadVariableNames=true);
    rawPhaseTable = rawData(~isnan(rawData.Phase)&rawData.Phase <= 180,["Subject","Group","Tempo", "Trial", "Bob","Phase","Phase_Rad"]);
    % rawPhaseTable.Phase_Rad = deg2rad(rawPhaseTable.Phase(:));

    means = varfun(@circ_mean, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"]);
    vectors = varfun(@circ_r, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"]);
    % v test
    vTestfunc = @(x)circ_vtest(x,0);
    vTest = rowfun(vTestfunc, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"], "OutputVariableNames",["VTestp","vTestz"]);

    rTest = rowfun(@circ_rtest, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"], "OutputVariableNames",["RTestp","RTestz"]);
    % means = renamevars(means,"circ_mean_Phase_Rad","Phase_Mean");

    rawIntervalTable = rawData(~isnan(rawData.Interval) & rawData.Interval < 1,["Subject","Group","Tempo", "Trial", "Bob","Interval"]);
    intervalStats = groupsummary(rawIntervalTable,["Subject","Group","Tempo", "Trial"],["mean","std"],"Interval");

    outputTable = means(:,["Subject","Group","Trial","Tempo","circ_mean_Phase_Rad"]);
    outputTable = join(outputTable,vectors(:,["Subject","Trial","circ_r_Phase_Rad"]),'Keys',["Subject","Trial"]);
    outputTable.PhaseStd = sqrt(-2*log(outputTable.circ_r_Phase_Rad));
    % outputTable.VectorLength = vectors(vectors.Group=="Human",:).circ_r_Phase_Rad;
    outputTable = join(outputTable,rTest(:,["Subject","Trial","RTestp","RTestz"]),'Keys',["Subject","Trial"]);
    outputTable = join(outputTable,vTest(:,["Subject","Trial","VTestp","vTestz"]),'Keys',["Subject","Trial"]);
    
    outputTable = join(outputTable,intervalStats(:,["Subject","Trial","mean_Interval","std_Interval"]),'Keys',["Subject","Trial"]);
    % outputTable.Interval_Mean = intervalStats(intervalStats.Group=="Human",:).mean_Interval;
    % outputTable.Interval_Std = intervalStats(intervalStats.Group=="Human",:).std_Interval;

    % outputTable.VectorLength = vectors(vectors.Group=="Human",:).circ_r_Phase_Rad;

    outputTable = renamevars(outputTable,["circ_mean_Phase_Rad","circ_r_Phase_Rad","mean_Interval","std_Interval"], ...
        ["PhaseMean","VectorLength","IntervalMean","IntervalStd"]);
    outputTable.RTestSig = outputTable.RTestp < 0.05;
    outputTable.VTestSig = outputTable.VTestp < 0.05;
    % get averages across trial averages
    means_trial = varfun(@circ_mean, outputTable(:,["Subject","Group","Tempo","Trial","PhaseMean"]), "InputVariables","PhaseMean", "GroupingVariables",["Group","Tempo"]);
    vectors_trial = varfun(@circ_r, outputTable(:,["Subject","Group","Tempo","Trial","PhaseMean"]), "InputVariables","PhaseMean", "GroupingVariables",["Group","Tempo"]);
    intervalStats_trial = groupsummary(outputTable(:,["Subject","Group","Tempo","Trial","IntervalMean"]),["Group","Tempo"],["mean","std"],"IntervalMean");
    RTest_trial = groupsummary(outputTable(:,["Subject","Group","Tempo","Trial","RTestSig"]),["Group","Tempo"],"sum","RTestSig");
    VTest_trial = groupsummary(outputTable(:,["Subject","Group","Tempo","Trial","VTestSig"]),["Group","Tempo"],"sum","VTestSig");
    outputMeans = means_trial(:,["Group","Tempo","circ_mean_PhaseMean"]);
    outputMeans = renamevars(outputMeans, "circ_mean_PhaseMean", "PhaseMean_Trial");
    outputMeans.VectorLength_Trial = vectors_trial.circ_r_PhaseMean;
    outputMeans.PhaseStd_Trial = sqrt(-2*log(outputMeans.VectorLength_Trial));
    outputMeans.IntervalMean_Trial = intervalStats_trial.mean_IntervalMean;
    outputMeans.IntervalStd_Trial = intervalStats_trial.std_IntervalMean;
    outputMeans.RTestn = RTest_trial.sum_RTestSig;
    outputMeans.VTestn = VTest_trial.sum_VTestSig;
    outputMeans.n = VTest_trial.GroupCount;



    if threshold > 0
        outputTable = outputTable(outputTable.VectorLength > threshold, :);

    end
