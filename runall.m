[outputTable, rawPhaseTable, rawIntervalTable, humanTable, ~, trialData] = bobbingMCWindowFinal('trials',10000,'bobs',24,'method',11,'threshold',0.4);

% trialData = bobtrialanalysis();
plotMC2d(outputTable,trialData,"Rejection Sampling, Phase - Windowed Normal & VM (winSize = 4)");
rawCDFcompare(rawPhaseTable, rawIntervalTable, outputTable);
% outComparison = circstatComparison(humanTable, outputTable);