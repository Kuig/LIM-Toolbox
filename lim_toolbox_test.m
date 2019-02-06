function [ ts ] = lim_toolbox_test ()
%LIM_TOOLBOX_TEST tests if all lim-toolbox functions can be executed
%
%[ ts ] = LIM_TOOLBOX_TEST()
%
%   Tries to run all lim-toolbox functions to check dependencies
%   This function does not check functional correctness!
%
%   ts.e: cell array containing error messages
%
%(C)2019 - G.PRESTI, LABORATORIO DI INFORMATICA MUSICALE
%Dipartimento di Informatica "Giovanni Degli Antoni"
%Università degli Studi di Milano
%Via Celoria, 18 - 20133 Milano (Italy)
%
%GPL license at the end of file
% See also GETSAMPLEAUDIO, GETFD, GETTD

%% TESTS SETTINGS
ts = [];
ts.Fs  = 44100;      % Sampling frequency
ts.dur = 10;         % Duration of samples in seconds
ts.w   = hann(2048); % Window function for frequency domain tests
ts.hop = 512;        % Hop size for frequency domain tests
ts.maxErr = -250;    % Mean square error tolerance (dB)
ts.len = ts.dur * ts.Fs;

ts.srcNames = { 'perc', 'bell', 'noise' }; % Sources for tests

ts.noErr  = '';          % Null object in case of no errors occured
ts.MEproc = @processME; % Turns exception in information to be stored

t = 1;
ts.e = {};
fig = figure;

disp(' ');

%% STDLIM TESTS

disp('Testing stdlim...');

ts.e{t} = test_getSampleFilter(ts); t=t+1;
ts.e{t} = test_getSampleAudio(ts);  t=t+1;

% Generate audio for tests
[ts.x, ts.src, ts.sigma] = getSampleAudio(ts.dur,ts.Fs,2); 

ts.e{t} = test_overlap(ts);      t=t+1;
ts.e{t} = test_getFD_getTD(ts);  t=t+1;

% Generate FD representations of audio for tests
[ts.X1, ~,    ~   ] = getFD(ts.x(:,1), ts.Fs, ts.hop, ts.w);
[ts.X2, ts.F, ts.T] = getFD(ts.x(:,2), ts.Fs, ts.hop, ts.w);

ts.e{t} = test_alignvector(ts);         t=t+1;
ts.e{t} = test_fade(ts);                t=t+1;
ts.e{t} = test_getBinEdges(ts);         t=t+1;
ts.e{t} = test_histw(ts);               t=t+1;
ts.e{t} = test_fixangles(ts);           t=t+1;
ts.e{t} = test_ang2mat(ts);             t=t+1;
ts.e{t} = test_panpot(ts);              t=t+1;
ts.e{t} = test_amp2db2amp(ts);          t=t+1;
ts.e{t} = test_hz2bark2hz(ts);          t=t+1;
ts.e{t} = test_hz2ERB2hz(ts);           t=t+1;
ts.e{t} = test_hz2erbs2hz(ts);          t=t+1;
ts.e{t} = test_hz2mel2hz(ts);           t=t+1;
ts.e{t} = test_hz2st2hz(ts);            t=t+1;
ts.e{t} = test_getFreqConverters(ts);   t=t+1;
ts.e{t} = test_getfbank(ts);            t=t+1; %
ts.e{t} = test_msmatrix(ts);            t=t+1;
ts.e{t} = test_rescaleamp(ts);          t=t+1;
ts.e{t} = test_rescalefreq(ts);         t=t+1;
ts.e{t} = test_whitening(ts);           t=t+1;


%% BMS TESTS

disp('Testing BMS...');

ts.e{t} = test_BMS(ts);                 t=t+1;
ts.e{t} = test_SAngle(ts);              t=t+1;
ts.e{t} = test_CCorr(ts);               t=t+1;
ts.e{t} = test_BS(ts);                  t=t+1;

% Generating BMS for tests
[ts.X, ts.s, ts.C] = BS(ts.X1,ts.X2);
[ts.X, ts.R]       = BS(ts.X1,ts.X2);

ts.e{t} = test_getMixtureHists(ts);     t=t+1; %

[ ts.edges, ts.centers ] = getBinEdges(100, [-pi/2,pi/2]);
[ts.D, ts.Df, ts.Dt] = getMixtureHists(ts.X,ts.s,ts.C,ts.edges);

ts.e{t} = test_PSC(ts);                 t=t+1;
ts.e{t} = test_icabybms(ts);            t=t+1;
ts.e{t} = test_angleMask(ts);           t=t+1;
ts.e{t} = test_plotBS(ts);              t=t+1;
ts.e{t} = test_plotdm(ts);              t=t+1;
ts.e{t} = test_analyzeMixture(ts);      t=t+1;
ts.e{t} = test_iBS(ts);                 t=t+1;

%% REPORT

ts.totalTests = size(ts.e,2);
passed = cellfun(@isempty,ts.e);
ts.failed = ts.totalTests-sum(passed);

disp(' ');

if ts.failed == 0
    disp('All tests passed');
else
    warning('Some test failed!');
    disp(ts.e(~passed).');
end

disp(' ');
close(fig);

end

function pe = processME(e,caller)
    pe = [caller, ': ', e.message];
    % warning(pe);
end

function err = mse(x,y)
    err = 20*log10(mean((x(:) - y(:)).^2));
end

function er = test_getSampleFilter(ts)
    try
        [ ~, ~ ] = getSampleFilter( 5 );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'getSampleFilter');
        error('Error in function getSampleFilter(), cannot continue tests');
    end
end

function er = test_getSampleAudio(ts)
    try
        [ ~, ~, ~ ] = getSampleAudio( ts.dur );
        [ ~, ~, ~ ] = getSampleAudio( ts.dur, ts.Fs );
        [ ~, ~, ~ ] = getSampleAudio( ts.dur, ts.Fs, 1 );
        [ ~, ~, ~ ] = getSampleAudio( ts.dur, ts.Fs, 2 );
        [ ~, ~, ~ ] = getSampleAudio( ts.dur, ts.Fs, 2, ts.srcNames );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'getSampleAudio');
        error('Error in function getSampleAudio(), cannot continue tests');
    end
end

function er = test_overlap(ts)
    try
        ws = length(ts.w);
        pad = ceil(ws/4);
        x= [randn(ts.len,1); zeros(pad,1)];
        bx = buffer(x, ws, ws-ts.hop);
        bx = bsxfun(@times,bx,ts.w);
        y = overlap (bx, ts.hop, ts.len+pad, ts.w);
        if mse(x,y) > ts.maxErr
            error('Overlap-and-add generated too much error');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'overlap');
        error('Error in function overlap(), cannot continue tests');
    end
end

function er = test_getFD_getTD(ts)
    try
        [ X, ~ ] = getFD( ts.x(:,1), ts.Fs );
        [ x ] = getTD( X );
        if mse(ts.x(:,1), x) > ts.maxErr
            error('Time to frequency domain and back generated too much error');
        end
        [ X, ~, ~, ~ ] = getFD( ts.x(:,1), ts.Fs, ts.hop, ts.w );
        [ x ] = getTD( X, ts.hop, ts.len, ts.w );
        if mse(ts.x(1:end-ts.hop,1), x(1:end-ts.hop)) > ts.maxErr
            error('Time to frequency domain and back generated too much error');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'getFD/getTD');
        error('Error in functions getTD() or getFD(), cannot continue tests');
    end
end

function er = test_alignvector(ts)
    try
        x = ts.x;
        x(:,1) = circshift(x(:,1),10);
        [~, ~, ~] = alignvector(x);
        [~, ~, ~] = alignvector(x(:,1),x(:,2),20,0);
        [~, ~, ~] = alignvector(x,[],20,1);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'alignvector');
    end
end

function er = test_fade(ts)
    try
        x = ts.x;
        [ ~ ] = fade(x,'in',1);
        [ ~ ] = fade(x,'inout',0.49*ts.Fs,2);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'fade');
    end
end

function er = test_getBinEdges(ts)
    try
        [ ~, ~ ] = getBinEdges();
        [ ~, c ] = getBinEdges(1,[0 1]);
        if mse(c, 0.5) > ts.maxErr
            error('getBinEdges performed with too much error');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'getBinEdges');
    end
end

function er = test_getfbank(ts)
    try
        [ ~, ~ ] = getfbank(ts.F);
        [ ~, ~ ] = getfbank(ts.F, 100);
        [ ~, ~ ] = getfbank(ts.F, 'auto', 'bark');
        [ ~, ~ ] = getfbank(ts.F, 'auto', 'erb', @hann);
        [ ~, ~ ] = getfbank(ts.F, 'auto', 'st', @hann, 4);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'getfbank');
    end
end

function er = test_histw(ts)
    try
        x = rand(10,20);
        w = ones(size(x));
        [ ~, edges ] = histw( x, w, 200 );
        [ ~, ~ ] = histw( x, w, edges );
        [ ~, ~ ] = histw( x, w, edges, 1 );
        [ ~, ~ ] = histw( x, w, edges, 2 );
        [ ~, ~ ] = histw( x, w, edges, [1 2], @mean );
        [ ~, ~ ] = histw( x(:), w(:), edges, [1 2] );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'histw');
    end
end

function er = test_fixangles(ts)
    try
        angles = [1, 0; 0, -1];
        [ o, ~ ] = fixangles( angles );
        if mse(o, [1,0;0,1]) > ts.maxErr
            error('Error in angle fixing');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'ang2mat');
    end
end

function er = test_ang2mat(ts)
    try
        angles = [0, -pi/2];
        [ A ] = ang2mat( angles, 0 );
        if mse(A, [1,0;0,-1]) > ts.maxErr
            error('Error in angle to matrix conversion (/wo fix)');
        end
        [ A ] = ang2mat( angles, 1 );
        if mse(A, [1,0;0,1]) > ts.maxErr
            error('Error in angle to matrix conversion (/w fix)');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'ang2mat');
    end
end

function er = test_panpot(ts)
    try
        [ ~ ] = panpot( ts.x, 0 );
        [ ~ ] = panpot( ts.x(:,1), pi );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'panpot');
    end
end

function er = test_amp2db2amp(ts)
    try
        a = [0.5, 1, 0];
        a1 = db2amp(amp2db(a,-inf));
        if mse(a, a1) > ts.maxErr
            error('Error in amp/dB representation');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'amp2db/db2amp');
    end
end

function er = test_hz2bark2hz(ts)
    try
        f = ts.F;
        f1 = bark2hz(hz2bark(f));
        if mse(f, f1) > ts.maxErr
            error('Bark to Hz and back performed with too much error');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'hz2bark/bark2hz');
    end
end

function er = test_hz2ERB2hz(ts)
    try
        f = ts.F;
        f1 = ERB2hz(hz2ERB(f));
        if mse(f, f1) > ts.maxErr
            error('ERB to Hz and back performed with too much error');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'hz2ERB/ERB2hz');
    end
end

function er = test_hz2erbs2hz(ts)
    try
        f = ts.F;
        f1 = erbs2hz(hz2erbs(f));
        if mse(f, f1) > ts.maxErr
            error('ERBS to Hz and back performed with too much error');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'hz2erbs/erbs2hz');
    end
end

function er = test_hz2mel2hz(ts)
    try
        f = ts.F;
        f1 = mel2hz(hz2mel(f));
        if mse(f, f1) > ts.maxErr
            error('Mel to Hz and back performed with too much error');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'hz2mel/mel2hz');
    end
end

function er = test_hz2st2hz(ts)
    try
        f = ts.F;
        f1 = st2hz(hz2st(f));
        if mse(f, f1) > ts.maxErr
            error('Note number to Hz and back performed with too much error');
        end
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'hz2st/st2hz');
    end
end

function er = test_msmatrix(ts)
    try
        L = 0.5; R = 0.5;
        LR = [L,R];
        [ ~ ] = msmatrix( LR );
        [ ~ ] = msmatrix( L, R );
        [ ~, ~ ] = msmatrix( LR );
        [ ~, ~ ] = msmatrix( L, R );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'msmatrix');
    end
end

function er = test_rescaleamp(ts)
    try
        [ ~ ] = rescaleamp(ts.X1, -96, 0);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'rescaleamp');
    end
end

function er = test_rescalefreq(ts)
    try
        [ ~, ~ ] = rescalefreq(abs(ts.X1), ts.F, 'mel', 'fb');
        [ ~, ~ ] = rescalefreq(abs(ts.X1), ts.F, 'st', 'int');
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'rescalefreq');
    end
end

function er = test_getFreqConverters(ts)
    try
        [ ~, ~, ~ ] = getFreqConverters('hz');
        [ ~, ~, ~ ] = getFreqConverters('st', ts.F);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'getFreqConverters');
    end
end

function er = test_whitening(ts)
    try
        [ ~, ~, ~ ] = whitening(ts.x);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'whitening');
    end
end

% --------------- BMS --------------- %

function er = test_BMS(ts)
    try
        BMS(ts.X1,ts.X2,pi);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'BMS');
        error('Error in function BMS(), cannot continue tests');
    end
end

function er = test_BS(ts)
    try
        [~,~,~] = BS(ts.X1,ts.X2);
        [~,~]   = BS(ts.X1,ts.X2);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'BS');
        error('Error in function BS(), cannot continue tests');
    end
end

function er = test_iBS(ts)
    try
        [~,~] = iBS(ts.X,ts.R);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'iBS');
    end
end

function er = test_CCorr(ts)
    try
        CCorr(ts.X1,ts.X2);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'CCorr');
        error('Error in function CCorr(), cannot continue tests');
    end
end

function er = test_getMixtureHists(ts)
    try
        edg = getBinEdges(50,[-pi/2,pi/2]);
        [~, ~] = getMixtureHists (ts.X, ts.s, ts.C, edg);
        [~, ~, ~] = getMixtureHists (ts.X, ts.s, ts.C, edg);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'getMixtureHists');
    end
end

function er = test_PSC(ts)
    try
        [ ~, ~ ] = PSC( ts.X1, ts.X2 );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'PSC');
    end
end

function er = test_SAngle(ts)
    try
        SAngle(ts.X1,ts.X2);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'SAngle');
        error('Error in function SAngle(), cannot continue tests');
    end
end

function er = test_icabybms(ts)
    try
        [ ~, ~, ~, ~, ~, ~ ] = icabybms( ts.x );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'icabybms');
    end
end

function er = test_angleMask(ts)
    try
        [ ~ ] = angleMask( ts.s, 0, [-1,1] );
        [ ~ ] = angleMask( ts.centers, 0, [-1,1], 'type', 'gauss', 'saturation', 10 );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'angleMask');
    end
end

function er = test_plotBS(ts)
    try
        [ ~, ~ ] = plotBS( ts.X, ts.s, ts.C, ts.F, ts.T );
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'plotBS');
    end
end

function er = test_plotdm(ts)
    try
        plotdm(ts.D)
        plotdm(ts.D,0,0.5,'rotate','on');
        plotdm(ts.D,0,0.5,'rotate','on','background',ts.Dt.');
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'plotdm');
    end
end

function er = test_analyzeMixture(ts)
    try
        [~, ~] = analyzeMixture( ts.X1, ts.X2, ts.F, ts.T, 100);
        er = ts.noErr;
    catch ME
        er = ts.MEproc(ME,'analyzeMixture');
    end
end


% --------------- LSF --------------- %


% ------------------------------------------------------------------------
%
% lim_toolbox_test.m: test if all lim-toolbox functions can be executed
% Copyright (C) 2018 - Laboratorio di Informatica Musicale
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>
%
% ------------------------------------------------------------------------
