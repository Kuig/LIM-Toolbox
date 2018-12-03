% The Bivariate Mixture Space: a novel method for
% representing bivariate signals.
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
% the reoprted ones (BMS performs better with real world signals).

%% Main test variables
nOfTest     = 50;  % Number of test to run
dataPath    = '.\Dataset\';   % Dataset path (if '', random data will be generated)
plotDetails = 0;    % Display PC and scatterplot of each sample
savePlots   = 0;    % Save final plots to PDF

% Fine tuning test variables
sr        = 44100;  % Sampling frequency (Hz)
maxlen    = 30;     % Maximum sample length (sec)
minlen    = 1;      % Minimum sample length (sec)
reso      = 180;    % # of BMS angles distribution bins
skipThres = -32;    % Minimum test RMS (dBfs)

% Test dependencies
addpath('./Lib');
if missingStuff(), error('Some packages are missing, download and/or add them to MATLAB paths'); end

% Initialize the environment
wbar = waitbar(0,'Initializing...');
rng(42);                      % For reprocucibility
timing    = zeros(nOfTest,2); % Time needed to execute each test
results   = cell(nOfTest,2);  % Results of each test
errors    = zeros(nOfTest,2); % Errors of each test
A         = cell(nOfTest,1);  % Filenames of source 1 of each tests
B         = cell(nOfTest,1);  % Filenames of source 2 of each tests
nOfIters  = zeros(nOfTest,1); % Number of FastICA iterations of each test
skipThres = db2amp(skipThres);% Others small init steps...
flist     = dir([dataPath,'*.wav']);

% Generate random mixture parameters for all tests
angles = rand(nOfTest,2)*pi-pi/2;
len    = randi(maxlen-minlen,nOfTest,1)+minlen;

%% Main test loop
for tst = 1:nOfTest    
    waitbar(tst/nOfTest,wbar,sprintf('Executing test %d/%d (load)...',tst,nOfTest));
    
    % Load a sample from dataset or generate it from scratch
    if isempty(dataPath) || isempty(flist)
        [ x, A{tst}, B{tst} ] = gensample(len(tst), sr, skipThres);
    else
        [ x, A{tst}, B{tst} ] = loadsample(dataPath, flist, len(tst)*sr, skipThres);
    end
    
    % Generate new mixture
    mixMatrix = ang2mat(angles(tst,:));
    y = (mixMatrix*x.').';

    % Test FastICA
    waitbar(tst/nOfTest,wbar,sprintf('Executing test %d/%d (ICA)...',tst,nOfTest));
    [errors(tst,1), timing(tst,1), results{tst,1}, nOfIters(tst)] = test_ica(y, mixMatrix);

    % Test ICA by BMS
    waitbar(tst/nOfTest,wbar,sprintf('Executing test %d/%d (BMS)...',tst,nOfTest));
    [errors(tst,2), timing(tst,2), results{tst,2}] = test_bms(y, reso, mixMatrix);

    % Plot data if asked
    if plotDetails
        waitbar(tst/nOfTest,wbar,sprintf('Executing test %d/%d (plot)...',tst,nOfTest));
        testplot(results,tst,y,angles);
        drawnow()
    end
end

%% Display statistics about results
stats (errors, timing, nOfIters, nOfTest);

% Plot results
waitbar(1,wbar,'Plotting...');
endplot (errors, timing, len, nOfIters, nOfTest, sr, savePlots);

%% Restore default environment
close(wbar)
rng('default');
beep