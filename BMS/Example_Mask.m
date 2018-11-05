
% Load or generate audio sample
% [x, Fs] = audioread('SillySample.wav');
Fs = 44100; dur = 8; len = dur*Fs;
x = getSampleAudio(dur,Fs);

% Listen to sample
% sound(x,Fs);

% Get STFT
w = hann(2048); hop = 512;
[L, F, T] = getFD(x(:,1),Fs,hop,w);
[R, ~, ~] = getFD(x(:,2),Fs,hop,w);

% Compute Bivariate Spectrum
[ X, s, C ] = BS(L,R);

% Find a source by locating a peak in the BS angle distribution
[D,Df,~,a] = PSCDist(X,s,C,201);
[pk, loc] = max(D(:,1));
sourcePosition = a(loc);
tolerance = 0.08;

% Viusalize data (background y axis is frequency)
background = rescalefreq(Df,F,'st','int');
background = max(background,0).^0.5;
subplot(3,1,2)
plotDMask( D(:,1), sourcePosition, tolerance, 1, background );
title('Mask and distribution')

% Retrive binary mask
mask = getSMask( s, sourcePosition, tolerance );

% Apply mask
newL = L .* mask;
newR = R .* mask;

% Back to time domain
y(:,1) = getTD(newL, hop, len, w);
y(:,2) = getTD(newR, hop, len, w);

% Listen to result
sound(y,Fs);

% Plot input and output Bivariate Spectra
subplot(3,1,1)
    [X,s,C] = BS(L,R);
    plotBS(X,s,C,F,T);
    grid on, ylim([40,128]);
    title('Input');
    
subplot(3,1,3)
    [X,s,C] = BS(newL,newR);
    plotBS(X,s,C,F,T);
    grid on, ylim([40,128]);
    title('Output');

