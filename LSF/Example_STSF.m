
% Load or generate audio sample
[x, Fs] = audioread('SillySample.wav');
% Fs = 44100; dur = 8; len = dur*Fs;
% x = getSampleAudio(dur,Fs);

% Convert to mono
x = mean(x,2);

% Get STFT
w = hann(2048); hop = 512;
[X, F, T] = getFD(x,Fs,hop,w);

% Calculate Spectro-Temporal Structure field (LSF canonical method)
disp('Computing STSF, this may take a while...');
[A,w] = getLSFparam(5,8);
stsf = LSF( abs(X), A, w );

% Convert STSF to modulation speed (semitones per second)
spd = stsf2speed( stsf, [ Fs/2048, hop/Fs ], 30, F );

% Plot STSF
h1 = subplot(2,1,1);
    satRange = [ -0.0005, max(abs(stsf(:))) ];
    plotSTSF(stsf,X,F,T,satRange,1);
    grid on, ylim([40,128]);

h2 = subplot(2,1,2);
    satRange = [ -20, 60 ];
    plotSpeed(stsf,X,spd,F,T,satRange,1);
    grid on, ylim([40,128]);

linkaxes([h1,h2]);
zoom on;

    