function distStats = circstatComparison(outputTable, plotFig)
    % compare outputs to standardized distributions

    tempi = [112; 120; 128];
    nTempi = length(tempi);
    distStats = cell2table(cell(0,8));
    distStats.Properties.VariableNames = ["StimTempo", "int_h", "int_p", "int_KSstat", "int_cv","phase_p", "phase_k", "phase_K"];
    for j=1:nTempi
        currTempo = tempi(j);
        outputTrials = outputTable(outputTable.StimTempo==currTempo,:);
        intMean = mean(outputTrials.TempoMean);
        intStd = std(outputTrials.TempoMean);
        % [inth, intp, intksstat] = swtest(outputTrials.TempoMean);
        [inth,intp,intksstat,intcv] = kstest(outputTrials.TempoMean);
        distStats.StimTempo(j) = currTempo;
        distStats.int_h(j) = inth;
        distStats.int_p(j) = intp;
        distStats.int_KSstat(j) = intksstat;
        distStats.int_cv(j) = intcv;
        if plotFig == 1
            figure
            subplot(2,1,1)
            cdfplot(outputTrials.TempoMean);
            hold on
            x_values = linspace(min(outputTrials.TempoMean),max(outputTrials.TempoMean));
            plot(x_values,normcdf(x_values,intMean,intStd),'r-')
            % normcdf(outputTrials.TempoMean,intMean,intStd);
            title(string(currTempo))
            legend("Simulated Data","Normal Data")
            hold off
        end

        meanPhase = circ_mean(deg2rad(outputTrials.PhaseMean));
        meanKappa = circ_kappa(deg2rad(outputTrials.PhaseMean));
        vmcdf = circ_vmrnd(meanPhase, meanKappa,height(outputTrials));
        [phasepval, phasek, phaseK] = circ_kuipertest(deg2rad(outputTrials.PhaseMean), vmcdf, 100, 0);
        distStats.phase_p(j) = phasepval;
        distStats.phase_k(j) = phasek;
        distStats.phase_K(j) = phaseK;
        if plotFig == 1
            subplot(2,1,2)
            cdfplot(deg2rad(outputTrials.PhaseMean));
            hold on
            cdfplot(vmcdf);
            legend("Simulated Data","Normal Data")
            hold off
        end
    end
    % % popStd = circ_var(deg2rad(rawPhase112));
    %
    % % smStd = std(phaseList);
    % sim112phaseMean = circ_mean(deg2rad(output112.PhaseMean));
    % sim120phaseMean = circ_mean(deg2rad(output120.PhaseMean));
    % sim128phaseMean = circ_mean(deg2rad(output128.PhaseMean));
    %
    % humanTable.simPhaseMean = [sim112phaseMean; sim120phaseMean; sim128phaseMean];
    %
    % sim112intMean = mean(output112.TempoMean);
    % sim120intMean = mean(output120.TempoMean);
    % sim128intMean = mean(output128.TempoMean);
    %
    % humanTable.simIntervalMean = [sim112intMean; sim120intMean; sim128intMean];
    %
    % outputTable = humanTable;

