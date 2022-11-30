% The Bivariate Mixture Space: a novel method for
% representing bivariate mixtures.
%
% G. Presti - Laboratorio di Informatica Musicale
% Universita' degli studi di milano - Milano (IT)
%
% This script should reproduce the experimental results of [publication]
% The datased used in the publication is available at:
%
%   https://www.upf.edu/web/mtg/mass
%
% To use it, all mixtures in the dataset should be discarted, and all
% remaining wav files has to be collected in one folder. In absence of
% the dataset, random data will be generated, but results may differ from
% the reoprted ones.

%% Main test variables
nOfTest     = 500;  % Number of test to run
dataPath    = '';   % Dataset path (in the format './Folder/'. If '', uses random data)
plotDetails = 0;    % Display PC and scatterplot of each sample
savePlots   = 0;    % Save final plots to PDF

% Fine tuning test variables
sr        = 44100;  % Sampling frequency (Hz)
maxlen    = 30;     % Maximum sample length (sec)
minlen    = 1;      % Minimum sample length (sec)
skipThres = -32;    % Minimum test RMS (dBfs)

% Test dependencies
addpath('./Lib');
if missingStuff(), error('Some packages are missing, download and/or add them to MATLAB paths'); end

% Initialize the environment
wbar = waitbar(0,'Initializing...');
rng(42);                      % For reprocucibility
timing    = zeros(nOfTest,2); % Time needed to execute each test
results   = cell(nOfTest,2);  % Results of each test
scores    = zeros(nOfTest,2); % Errors of each test
A         = cell(nOfTest,1);  % Filenames of source 1 of each tests
B         = cell(nOfTest,1);  % Filenames of source 2 of each tests
skipThres = db2amp(skipThres);% Others small init steps...

% Initialize dataset
flist     = dir([dataPath,'*.wav']);
noDataset = isempty(dataPath) || isempty(flist); % Is dataset missing?

% Settings for the ICA-by-BMS function
sets.resolution = 180;      % # of BMS sigma-distribution bins
sets.refineMode = 'top5';   % Sigma-distribution peak refine method
sets.corrWeight = 0.5;      % C exponent in weighted distribution
sets.smoothing  = pi/180;   % Distribution smoothing
sets.ampExp     = 1;        % Amplitude exponent in weighted distribution
sets.whitening  = 'on';     % Use whitening

% Generate random mixture parameters for all tests
angles = rand(nOfTest,2)*pi-pi/2;
len    = randi(maxlen-minlen,nOfTest,1)+minlen;

%% Main test loop
for tst = 1:nOfTest    
    waitbar(tst/nOfTest,wbar,sprintf('Executing test %d/%d (load)...',tst,nOfTest));
    
    % Load a sample from dataset or generate it from scratch
    if noDataset
        [ x, A{tst}, B{tst} ] = gensample(len(tst), sr, skipThres);
    else
        [ x, A{tst}, B{tst} ] = loadsample(dataPath, flist, len(tst)*sr, skipThres);
    end
    
    % Generate new mixture
    mixMatrix = ang2mat(angles(tst,:));
    y = (mixMatrix*x.').';

    % Test SOBI
    waitbar(tst/nOfTest,wbar,sprintf('Executing test %d/%d (SOBI)...',tst,nOfTest));
    [scores(tst,1), timing(tst,1), results{tst,1}] = test_sobi(y, mixMatrix);
    
    % Test ICA by BMS
    waitbar(tst/nOfTest,wbar,sprintf('Executing test %d/%d (BMS)...',tst,nOfTest));
    [scores(tst,2), timing(tst,2), results{tst,2}] = test_bms(y, mixMatrix, sets);

    % Plot data if asked
    if plotDetails
        waitbar(tst/nOfTest,wbar,sprintf('Executing test %d/%d (plot)...',tst,nOfTest));
        testplot(results,tst,y,angles);
        drawnow()
    end
end

%% Display statistics about results
stats (scores, timing, nOfTest);

% Plot results
waitbar(1,wbar,'Plotting...');
endplot (scores, timing, len, nOfTest, sr, savePlots);

%% Restore default environment
close(wbar)
rng('default');
beep