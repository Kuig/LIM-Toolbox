function [b, a] = getBiquadCoeff(typ, sr, cf, Q, GdB)
%GETBIQUADCOEFF returns digital biquad filter coefficients
%
%[b, a] = getBiquadCoeff(typ, sr, cf, Q, GdB)
%
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
%   sr:  Sampling rate
%   cf:  Cutoff frequency
%   Q:   Q factor
%   GdB: Gain in decibels (used by 'PK', 'LS*', 'HS*' filter types)
%
%   [b, a]: Filter coefficients to be used with FILTER function
%
%(C)2019 - G.PRESTI, LABORATORIO DI INFORMATICA MUSICALE
%Dipartimento di Informatica "Giovanni Degli Antoni"
%Università degli Studi di Milano
%Via Celoria, 18 - 20133 Milano (Italy)
%
%GPL license at the end of file
% See also FILTER, GETMAGNITUDERESP

    omega = 2 * pi * cf/sr;
    sn = sin(omega);
    cs = cos(omega);
    alpha = sn / (2 * Q);

    b = [1,0,0];
    a = [1,0,0];

    switch typ
        case 'BP1'
            b = [alpha, 0, -alpha];
            a = [1+alpha, -2*cs, 1-alpha];
        case 'BP2'
            b = [Q*alpha, 0, -Q*alpha];
            a = [1+alpha, -2*cs, 1-alpha];
        case 'LP'
            t1 = 1-cs; t2 = t1/2;
            b = [t2, t1, t2];
            a = [1+alpha, -2*cs, 1-alpha];
        case 'HP'
            t1 = 1+cs; t2 = t1/2;
            b = [t2, -t1, t2];    
            a = [1+alpha, -2*cs, 1-alpha];
        case 'NC'
            t1 = -2*cs;
            b = [1, t1, 1];
            a = [1+alpha, t1, 1-alpha];
        case 'AP'
            b = [1-alpha, -2*cs, 1+alpha];
            a = [1+alpha, -2*cs, 1-alpha];
        case 'PK'
            G = 10^(GdB/40);
            t1 = alpha * G;
            t2 = alpha / G;
            t3 = -2*cs;
            b = [1+t1, t3, 1-t1];
            a = [1+t2, t3, 1-t2];
        case 'LS1'
            G = 10^(GdB/40);
            beta = sqrt(2 * G) * sn;
            t1 = (G + 1) - (G - 1) * cs;
            t2 = (G - 1) - (G + 1) * cs;
            t3 = (G + 1) + (G - 1) * cs;
            t4 = (G - 1) + (G + 1) * cs;
            b = [G*(t1+beta), 2*G*t2, G*(t1-beta)];
            a = [t3+beta, -2*t4, t3-beta];
        case 'HS1'
            G = 10^(GdB/40);
            beta = sqrt(2 * G) * sn;
            t1 = (G + 1) - (G - 1) * cs;
            t2 = (G - 1) - (G + 1) * cs;
            t3 = (G + 1) + (G - 1) * cs;
            t4 = (G - 1) + (G + 1) * cs;
            b = [G*(t3+beta), -2*G*t4, G*(t3-beta)];
            a = [t1+beta, 2*t2, t1-beta];
        case 'LS2'
            G = 10^(GdB/40);
            beta = sn * sqrt(G) / Q;
            t1 = (G + 1) - (G - 1) * cs;
            t2 = (G - 1) - (G + 1) * cs;
            t3 = (G + 1) + (G - 1) * cs;
            t4 = (G - 1) + (G + 1) * cs;
            b = [G*(t1+beta), 2*G*t2, G*(t1-beta)];
            a = [t3+beta, -2*t4, t3-beta];
        case 'HS2'
            G = 10^(GdB/40);
            beta = sn * sqrt(G) / Q;
            t1 = (G + 1) - (G - 1) * cs;
            t2 = (G - 1) - (G + 1) * cs;
            t3 = (G + 1) + (G - 1) * cs;
            t4 = (G - 1) + (G + 1) * cs;
            b = [G*(t3+beta), -2*G*t4, G*(t3-beta)];
            a = [t1+beta, 2*t2, t1-beta];
        otherwise
    end

    b = b./a(1);
    a = a./a(1);

end

% ------------------------------------------------------------------------
%
% getBiquadCoeff.m: returns digital biquad filter coefficients
% Copyright (C) 2019 - Laboratorio di Informatica Musicale
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