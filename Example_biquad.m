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
%
% ------------------------------------------------------------------------

%   typ: Type of filter, can be one of the following:
%        'BP1' - Band-pass (unity gain at cf)
%        'BP2' - Band-pass (resonant)
%        'LP'  - Resonant Low-pass
%        'HP'  - Resonant High-pass
%        'NC'  - Notch (band-reject)
%        'AP'  - All-pass
%        'PK'  - Peak (bell)
%        'LS1' - Low-shelf (no slope control)
%        'HS1' - High-shelf (no slope control)
%        'LS2' - Low-shelf (resonant, with slope control)
%        'HS2' - High-shelf (resonant, with slope control)

% Choose filter parameters
typ = 'PK';
sr = 44100;
cf = 1000;
Q = 1 / sqrt(2);
GdB = 6;

% Get filter coefficients
[b, a] = getBiquadCoeff(typ, sr, cf, Q, GdB);

% (filter your data with Matlab FILTER function)

% Get filter magnitude response for visualization purpose
f = logspace(log10(20),log10(20000),256);
[~,rdB] = getMagnitudeResp(b, a, f, sr);

% Plot filter response
semilogx(f,rdB); hold on;
semilogx(cf,GdB,'or'); hold off;
ylim([-24,24]);
xlim([f(1),f(end)]);
title({'Filter response',...
    sprintf('Type: %s, Frequency: %.1f Hz, Q: %.3f, Gain: %.1f dB',...
    typ,cf,Q,GdB)})
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
grid on;

% ------------------------------------------------------------------------
%
% examples.m: Examples on how to use the stdlim library
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