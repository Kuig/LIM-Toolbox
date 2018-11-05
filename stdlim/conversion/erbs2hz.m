function [ f ] = erbs2hz( n )
%ERBS2HZ report top frequency given number of ERB bands
%
%[ f ] = ERBS2HZ( n )
%
%   ERBS returns the frequency f that underlies a given number of 
%   equivalent rectangular bandwidths
%
%   Reference: Moore, Brian CJ, and Brian R. Glasberg. "Suggested formulae 
%              for calculating auditory?filter bandwidths and excitation
%              patterns." The journal of the acoustical society of
%              America 74.3 (1983): 750-753.
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also HZ2ERBS, ERB2HZ, HZ2ERB, GETFREQCONVERTERS, RESCALEFREQ

% 	f = 228.8329519451507 * ( exp( 0.107597434252050*n ) - 1 );    % From linear approx
%   f = (676170.4 ./ (47.06538 - exp(0.08950404*n) ) ) - 14678.49; % From polynomial approx

%   From polynomial approx, but with less error:
    f = -(733924500 * (-1 + exp((25000*n)./279317))) ./...
         (-2353269 + 50000 * exp((25000*n)./279317)); 

end

% ------------------------------------------------------------------------
%
% erbs2hez.m: give top frequency given number of ERB bands
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