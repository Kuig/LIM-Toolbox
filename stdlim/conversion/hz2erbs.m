function [ n ] = hz2erbs( f )
%HZ2ERBS return number of ERB below given frequency
%
%[ n ] = HZ2ERBS( f )
%
%   ERBS returns the number of equivalent rectangular bandwidths below the
%   given frequency f.
%
%   Reference: Moore, Brian CJ, and Brian R. Glasberg. "Suggested formulae 
%              for calculating auditory?filter bandwidths and excitation
%              patterns." The journal of the acoustical society of
%              America 74.3 (1983): 750-753.
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also ERBS2HZ, ERB2HZ, HZ2ERB, GETFREQCONVERTERS, RESCALEFREQ

%   n = 21.4 * log10(1+0.00437*f);                      % From linear approx
    n = 11.17268 * log(1+((46.06538*f)./(f+14678.49))); % From polynomial approx

end

% ------------------------------------------------------------------------
%
% hz2erbs.m: number of ERB below given frequency
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