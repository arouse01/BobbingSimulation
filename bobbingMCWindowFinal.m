% Ronan rhythm entrainment Monte Carlo simulation

function [outputTable, rawPhaseTable, rawIntervalTable, humanTable, rawTable, trialData] = bobbingMCWindowFinal(varargin)
    p = inputParser;
    defaultTrials = 5000;
    defaultBobs = 24;
    defaultVectorThresh = 0;
    addOptional(p, "trials", defaultTrials);
    addOptional(p, "bobs", defaultBobs);
    addOptional(p, "threshold", defaultVectorThresh);
    parse(p,varargin{:})
    trials = p.Results.trials;
    bobs = p.Results.bobs;
    vectorThresh = p.Results.threshold;

    tempi = [112; 120; 128];
    nTempi = length(tempi);
    windowSize = 4;
    trialMax = 25;
    nWindows = trialMax - windowSize + 1;

    %% import data
    rawTable = readtable('all subjects_checked.xlsx','Sheet','Raw', Range="A:H",ReadVariableNames=true);
    rawTable.Phase_Rad = deg2rad(rawTable.Phase(:));
    rawTable = rawTable(~isnan(rawTable.Phase),:);
    trialData = bobtrialanalysis(rawTable, vectorThresh);

    % filterData = true;
    if vectorThresh > 0
        % filter worst trials
        vectors = varfun(@circ_r, rawTable, "InputVariables","Phase_Rad", "GroupingVariables",["Subject","Group","Tempo", "Trial"]);
        vectors = renamevars(vectors,"circ_r_Phase_Rad","VectorLength");
        rawTable = join(rawTable,vectors(:,["Subject","Trial","VectorLength"]),'Keys',["Subject","Trial"]);
        rawTable = rawTable(rawTable.VectorLength > vectorThresh,:);
    end

    % Phase data
    rawPhaseTable = rawTable(~isnan(rawTable.Phase) & abs(rawTable.Phase) <= 180,["Group","Bob","Tempo","Phase"]);
    rawPhaseTable.Phase_Rad = deg2rad(rawPhaseTable.Phase(:));
    means = varfun(@circ_mean, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Group", "Tempo"]);
    % Von Mises distribution has a mean and a 'concentration' (kappa)
    kappas = varfun(@circ_kappa, rawPhaseTable, "InputVariables","Phase_Rad", "GroupingVariables",["Group", "Tempo"]);
    phaseStats = renamevars(means,"circ_mean_Phase_Rad","PhaseMean");
    phaseStats.PhaseKappa = kappas.circ_kappa_Phase_Rad;

    % Interval data
    rawIntervalTable = rawTable(~isnan(rawTable.Interval),["Group","Tempo","Interval"]);
    intervalStats = groupsummary(rawIntervalTable,["Group", "Tempo"],["mean","std"],"Interval");

    humanTable = phaseStats(phaseStats.Group=="Human",["Tempo","PhaseMean","PhaseKappa"]);
    % humanTable.PhaseStd = sqrt(-2*log(outputMeans.VectorLength_Trial));
    humanTable.IntMean = intervalStats(intervalStats.Group=="Human",:).mean_Interval;
    humanTable.IntStd = intervalStats(intervalStats.Group=="Human",:).std_Interval;
    humanTable.Properties.RowNames = string(humanTable.Tempo);

    %% Generate Results
    % preallocate the result columns
    meanTempoCol = zeros(1,trials*nTempi);
    % stdTempoCol = zeros(1,trials*nTempi);
    meanVectorCol = zeros(1,trials*nTempi);
    meanAngleCol = zeros(1,trials*nTempi);
    TempoCol = zeros(1,trials*nTempi);
    allIntervalList = cell(1,trials*nTempi);
    allPhaseList = cell(1,trials*nTempi);

    % Construct joint distribution
    for z = 1:nTempi
        currTempo = tempi(z);
        rawData = rawTable( ...
            rawTable.Group=="Human" & ...
            rawTable.Tempo == currTempo & ...
            rawTable.Interval < 1 & ...
            abs(rawTable.Phase) <= 180, ...
            ["Bob","Interval","Phase"]);


        % Standardized distributions from data

        % windowJointPDF = {};
        windowJointMax = zeros(1,nWindows);
        windowIntMean = zeros(1,nWindows);
        windowIntStd = zeros(1,nWindows);
        windowPhaseMean = zeros(1,nWindows);
        windowPhaseKappa = zeros(1,nWindows);
        
        for y = 1:(nWindows)
            windowData = table2array(rawData(rawData.Bob>=y & rawData.Bob<=(y+windowSize-1), ["Interval","Phase"]));
            intMean = mean(windowData(:,1));
            intStd = std(windowData(:,1));
            phaseMean = circ_mean(deg2rad(windowData(:,2)));
            phaseKappa = circ_kappa(deg2rad(windowData(:,2)));
            
            pdfMax = circ_vmpdf(phaseMean, phaseMean, phaseKappa);

            windowIntMean(y) = intMean;
            windowIntStd(y) = intStd;
            windowPhaseMean(y) = phaseMean;
            windowPhaseKappa(y) = phaseKappa;
            % windowJointPDF(y) = {joint_pdf};
            windowJointMax(y) = pdfMax;

        end
        humanTable.windowIntMean(z) = {windowIntMean};
        humanTable.windowIntStd(z) = {windowIntStd};
        humanTable.windowPhaseMean(z) = {windowPhaseMean};
        humanTable.windowPhaseKappa(z) = {windowPhaseKappa};
        % humanTable.jointPDF(z) = {windowJointPDF};
        humanTable.pdfMax(z) = {windowJointMax};


    end


    for i=1:trials

        if mod(i,200)==0
            fprintf("loop %i\n", i)
        end

        for j=1:nTempi
            currTempo = tempi(j);


            % % generate intervals one at a time but validate the calculated interval/phase pairs with rejection
            % sampling, using idealized forms of the interval and phase
            dt = 60/currTempo;

            intervalList = zeros(bobs-1,1);
            phaseList = zeros(bobs,1);
            bobOnsets = zeros(bobs,1);
            beatOnsets = (0:(bobs+5))'.*dt;  % +5 to capture any offset because of skipped beats or lapping

% bobbingMCWindow
            for m = 1:(bobs)
                currWindow = max(1, min(nWindows, m - floor(windowSize / 2)));
                phaseMean = humanTable{string(currTempo),"windowPhaseMean"}{:}(currWindow);
                phaseKappa = humanTable{string(currTempo),"windowPhaseKappa"}{:}(currWindow);
                intMean = humanTable{string(currTempo),"windowIntMean"}{:}(currWindow);
                intStd = humanTable{string(currTempo),"windowIntStd"}{:}(currWindow);

                pdfMax = humanTable{string(currTempo),"pdfMax"}{:}(currWindow);
                
                if m == 1
                    % set first phase randomly
                    phaseList(m) = circ_vmrnd(phaseMean, phaseKappa,1);
                    % get beat onset time from phase
                    bobOnsets(m) = 0 + (phaseList(1)/(2*pi()))*dt;
                else
                    k = 0;
                    match = false;
                    while ~match
                        % rejection sampling
                        k = k+1;

                        if mod(k,10000)==0
                            fprintf("Rejection sample loop %i\n", k)
                        end

                        % generate interval for bob_m
                        tempInterval = normrnd(intMean, intStd,1, 1);
                        % calculate that bob's onset time
                        tempBobTime = bobOnsets(m-1) + tempInterval;
                        % calculate the phase of that bob
                        tempPhase = getSinglePhase(tempBobTime, beatOnsets);

                        % % rejection sampling of phase
                        % get the probability at that point
                        pPhase = circ_vmpdf(tempPhase, phaseMean, phaseKappa);
                        phaseProb = (pPhase)/pdfMax;
                        if phaseProb > 1
                            warning('jointProb > 1')
                        end

                        % calculate acceptance criterion
                        uPhase = rand(1);
                        if uPhase < phaseProb
                            intervalList(m-1) = tempInterval;
                            phaseList(m) = tempPhase;
                            bobOnsets(m) = tempBobTime;

                            match = true;

                        end
                    end
                end
            end


            % The angles can be considered vectors with unit length (length = 1).
            % Therefore each angle can be represented as a set of coordinates on the unit circle.
            % Points (vectors) on the unit circle can be represented as complex numbers with magnitude z = cos(theta) + i*sin(theta)
            % which is (conveniently) equal to exp(1i*theta).
            % Therefore, mean magnitude is just abs(mean(exp(1i*theta))), and angle is angle(mean(exp(1i*theta)))

            meanPhase = rad2deg(circ_mean(phaseList));
            meanVector = abs(mean(exp(1i*phaseList)));

            % add values to result columns
            meanTempoCol(3*(i-1)+j) = mean(intervalList);
            % stdTempoCol(3*(i-1)+j) = std(intervalList);
            meanVectorCol(3*(i-1)+j) = meanVector;
            meanAngleCol(3*(i-1)+j) = meanPhase;
            TempoCol(3*(i-1)+j) = currTempo;
            allIntervalList(3*(i-1)+j) = {intervalList};
            allPhaseList(3*(i-1)+j) = {phaseList};


        end
    end
    
    % outputTable = table(TempoCol', meanTempoCol',stdTempoCol',meanVectorCol',meanAngleCol', allIntervalList', allPhaseList','VariableNames', ...
    %     ["StimTempo", "TempoMean", "TempoStd","VectorLengthMean", "PhaseMean", "IntervalList","PhaseList"]);
    outputTable = table(TempoCol', meanTempoCol',meanVectorCol',meanAngleCol', allIntervalList', allPhaseList','VariableNames', ...
        ["StimTempo", "TempoMean", "VectorLengthMean", "PhaseMean", "IntervalList","PhaseList"]);


    function phaseOut = getSinglePhase(bobTime, beatTimes)
        % bobTime: onset of bob in s
        % beatTimes: vector of beat onsets in s
        % phaseOut: resulting phase in radians
        %

        % Get nearest two beats
        [~, index] = mink(abs(beatTimes - bobTime),2);
        % get interval size (60/tempo)
        dt_stim = abs(beatTimes(index(2))-beatTimes(index(1)));

        % then calculate phase relative to closest beat
        phaseOut = 2*pi()*(bobTime - beatTimes(index(1)))/dt_stim;

    end


end
