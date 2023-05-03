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
rng(42);

% Desired outcome
nOfLines   = 5;     % number of lines to draw in the sample image
duration   = 5;     % seconds
sampleRate = 44100; % Hz
fftSize    = 2048;
hopSize    = fftSize / 4;
length = duration * sampleRate;
numFrames = ceil(length / hopSize);

% Generate an image to be used as a magnitude spectrum
img = getSampleImage(1+fftSize/2,numFrames,nOfLines);

% Turn the image to a proper "frequency domain signal" by adding
% random phase information (i.e. from real to complex numbers)
X = img.*exp(2i * pi * rand(size(img)));

% Run iFFT
snd = getTD(X, hopSize, length, sqrt(hann(fftSize)));

% Normalize peak to avoid clipping
snd = snd ./ max(abs(snd));

% Get the sound spectrum to be compared with the image
[Y, F, T] = getFD(snd,sampleRate,hopSize,hann(fftSize));
Y = amp2db(abs(Y), -96);

% ------------------------------------------------------------------------

% Play the corresponding sound;
sound(snd, sampleRate);

% Plot the input image
subplot(2,1,1)
imagesc(img)
colormap("gray")
axis xy, grid on
xlabel('x'), ylabel('y')
title('Input image');

% Plot the output sound spectrum
subplot(2,1,2)
imagesc(T,F,Y)
colormap("gray")
axis xy, grid on
xlabel('Time'), ylabel('Frequency')
title('Output sound');

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