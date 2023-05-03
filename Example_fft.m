% ------------------------------------------------------------------------
%
% Very simple usage example of some stdlim functions
%
% (C)2023 - G.PRESTI, LABORATORIO DI INFORMATICA MUSICALE
% Dipartimento di Informatica "Giovanni Degli Antoni"
% Università degli Studi di Milano
% Via Celoria, 18 - 20133 Milano (Italy)
% 
% GPL license at the end of file

% ------------------------------------------------------------------------

% For reproducibility
rng(10);

% Generate sample audio
sampleRate = 44100; % Hz
duration   = 5;     % Seconds
x = getSampleAudio(5, sampleRate);

% Mix to mono
x = mean(x,2);

% Normalize RMS
x = x./rms(x);

% Get frequency-domain representation by using 
% a 2048 samples hanning window with 75% overlap
[X, F, T, xwindowed] = getFD(x, sampleRate, 256, hann(2048));

% Only keeps magnitude
X = abs(X);

% Compute spectral centroid C 
C = sum(X.*F)./sum(X);

% Set centroid to NAN when signal is silent
threshold = db2amp(-24);
C(rms(xwindowed) < threshold) = nan;

% Resample the magnitude spectrum in (pseudo)log-log scale
% Supported modes: 'mel', 'bark', 'erbs', 'semitone', 'hz', 'log'
targetScale = 'Mel'; 
[Xm, M] = rescalefreq(X,F,targetScale);
Xm = amp2db(Xm);

% Also express centroid in targetScale
[hz2xx, ~ ] = getFreqConverters(targetScale);
Cm = hz2xx(C);

% ------------------------------------------------------------------------

% Plot spectrum in linear scale
subplot(2,1,1)
imagesc(T, F, X); hold on;
colormap('parula')
plot (T, C,'m','LineWidth',2); hold off;
legend('Centroid');
axis('xy'), grid('on');
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Raw spectrogram');

% Plot spectrum in targetScale-dB scale
subplot(2,1,2)
imagesc(T, M, Xm); hold on;
colormap('parula')
plot (T, Cm,'r','LineWidth',2); hold off;
legend('Centroid');
axis('xy'), grid('on');
colorbar;
xlabel('Time (s)');
ylabel(['Frequency (',targetScale,')']);
title([targetScale,'-dB spectrogram']);

% ------------------------------------------------------------------------
%
% examples.m: Examples on hot to use the stdlim library
% Copyright (C) 2023 - Laboratorio di Informatica Musicale
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