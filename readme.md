These scripts are used to analyze data in the paper

Requires the CircStat package for MATLAB (https://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics)

Contents:

	Raw analysis
		bobtrialanalysis.m	Compiles raw bob/chop timings into per-trial measures for further analysis, including per-trial significance

	Simulation
		bobbingMCWindowFinal.m	Monte Carlo simulation of humam rhythm entrainment
		simulatedData.mat	Output of the bobbingMCWindowFinal.m script
		plotMC2d.m	Plots comparison between simulated human data and actual Ronan data
		rawCDFcompare.m	Plots comparison between simulated human data and actual human data
		runall.m	Visualizes and runs comparative analysis of simulated data
	
	Ronan self-comparison
		RonanOldVNew.m	Compares Ronan's performance at age 3 to performance at age 15

	Ronan-Human comparison
		RonanVHumanAngles.m	Compares mean angle of each of Ronan's trials to the human mean angle for that tempo
		bobtrialgroupcompare.m	Compares Ronan's mean angle at each tempo to the human mean angle for that tempo
		bobtrialgroupcompare.m	Uses Watson-Williams multi-sample test for equal means to compare Ronan's mean phase angles per trial to the human participants at each tempo
		
	Human self-comparison
		HumanBobLearning.m	Compares first trial to last trial at each tempo for each human subject
		BobFirstVLast.m	Compares first half of trials to second half of trials to evaluate improvement in performance over the course of a trial
		