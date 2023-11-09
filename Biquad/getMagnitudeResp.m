function [r, rdB] = getMagnitudeResp(b, a, f, sr)
%GETMAGNITUDERESP returns digital biquad filter magnitude response
%
%[r, rdB] = getMagnitudeResp(b, a, f, sr)
%
%   [b, a]: Filter coefficients (3 elements vectors)
%   f:      Frequencies in Hz where the filter response should be sampled
%   sr:     Sampling rate
%
%   r:   Filter magnitude response at given f
%   rdB: Filter magnitude response at given f (in dB)
%
%(C)2019 - G.PRESTI, LABORATORIO DI INFORMATICA MUSICALE
%Dipartimento di Informatica "Giovanni Degli Antoni"
%Università degli Studi di Milano
%Via Celoria, 18 - 20133 Milano (Italy)
%
%GPL license at the end of file
% See also FILTER, GETBIQUADCOEFF

    phi =  sin( (2 * pi * f) ./ (2 * sr) ).^2;
    sqphi = phi.^2;
    r = polinom(b, phi, sqphi) ./ polinom(a, phi, sqphi);
    r = sqrt(max(r,0));
    
    if nargout > 1
        rdB = amp2db(r);
    end

end

function pz = polinom(x, phi, sqphi)

    pz = ( 16*x(1)*x(3)*sqphi + (sum(x)^2) - 4*( x(1)*x(2) + 4*x(1)*x(3) + x(2)*x(3))*phi );

end

% ------------------------------------------------------------------------
%
% getMagnitudeResp.m: returns digital biquad filter magnitude response
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