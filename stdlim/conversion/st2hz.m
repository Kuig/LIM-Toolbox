function [ F ] = st2hz( N, Fref, Nref, EDO )
%ST2HZ converts note number to frequency values
%
%[ F ] = ST2HZ( N )
%[ F ] = ST2HZ( N, Fref )
%[ F ] = ST2HZ( N, Fref, Nref )
%[ F ] = ST2HZ( N, Fref, Nref, EDO )
%
%   Convert note number N to frequency values F
%
%   Fref: reference frequency (default: 440)
%   Nref: N value corresponding to Fref (default: 69)
%   EDO:  Equal division of the octave (default: 12)
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also HZ2ST, GETFREQCONVERTERS, RESCALEFREQ, AMP2DB, DB2AMP

    if nargin < 4, EDO = 12; end
    if nargin < 3, Nref = 69; end
    if nargin < 2, Fref = 440; end

    F = ( 2.^( (N-Nref)./EDO ) ) * Fref;

end

% ------------------------------------------------------------------------
%
% st2hz.m: Convert note number to frequency values
% Copyright (C) 2014 - Giorgio Presti - Laboratorio di Informatica Musicale
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