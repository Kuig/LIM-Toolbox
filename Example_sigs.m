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

% Half second fade in and out
x = fade(x, 'inout', 0.5 * sampleRate);

% Delay left channel by 0.25 seconds
x(:,1) = circshift(x(:,1),[0.25 * sampleRate,0]);

% Automatically re-align channels
[y, lag] = alignvector(x);
disp(['The left channel has been shifted by ',num2str(lag/sampleRate),' seconds.'])

% ------------------------------------------------------------------------

% Compute time axis for plotting
len = duration * sampleRate;
t = linspace(0, len-1, len) ./ sampleRate;

% Plot delayed signals
subplot(2,1,1)
plot(t,x)
grid on
title('Before alignment');

% Plot aligned signals
subplot(2,1,2)
plot(t,y)
grid on
title('After alignment');

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