
% Load or generate audio sample
% [x, Fs] = audioread('SillySample.wav');
Fs = 44100; dur = 8; len = dur*Fs;
x = getSampleAudio(dur,Fs);

% Get STFT
w = hann(2048); hop = 512;
[L, F, T] = getFD(x(:,1),Fs,hop,w);
[R, ~, ~] = getFD(x(:,2),Fs,hop,w);

% Plot Bivariate Spectrum and Principal Spectral Content Distributions
analyzeMixture( L, R, F, T, 200, 'yscale', 'mel', 'gamma', 0.3 );
