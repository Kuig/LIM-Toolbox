function [ bw ] = hz2ERB( f )
%HZ2ERB get bandwidths of the filters in human hearing
%
%[ bw ] = HZ2ERB( f )
%
%	ERB approximation of the bandwidths of the filters in human hearing, using
%	the unrealistic but convenient simplification of modeling the filters as
%	rectangular band-pass filters. The approximation is applicable at
%   moderate sound levels and for values of f between 0.1 and 6.5 kHz
%
%   Reference: Moore, Brian CJ, and Brian R. Glasberg. "Suggested formulae 
%              for calculating auditory?filter bandwidths and excitation
%              patterns." The journal of the acoustical society of
%              America 74.3 (1983): 750-753.
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also ERB2HZ, ERBS2HZ, HZ2ERBS, GETFREQCONVERTERS, RESCALEFREQ

%   bw = 24.7*(4.37*f/1000+1);                      % Linear approx
    bw = 6.23*(f/1000).^2 + 93.39*(f/1000) + 28.52; % Polynomial approx

end

% ------------------------------------------------------------------------
%
% hz2ERB.m: bandwidths of the filters in human hearing
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