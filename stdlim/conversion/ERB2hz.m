function [ f ] = ERB2hz( bw )
%ERB2HZ given the ERB bandwidth return corresponding frequency 
%
%[ f ] = ERB2hz( bw )
%
%   Reference: Moore, Brian CJ, and Brian R. Glasberg. "Suggested formulae 
%              for calculating auditory?filter bandwidths and excitation
%              patterns." The journal of the acoustical society of
%              America 74.3 (1983): 750-753.
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also HZ2ERB, ERBS2HZ, HZ2ERBS, GETFREQCONVERTERS, RESCALEFREQ

%   f = (100000*(10*bw-247))/107939;                       % Linear approx
    f = (500/623) * (sqrt(249200 * bw + 80109737) - 9339); % Polynomial approx

end

% ------------------------------------------------------------------------
%
% ERB2hz.m: return frequency given the ERB bandwidth
% Copyright (C) 2018 - Giorgio Presti - Laboratorio di Informatica Musicale
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