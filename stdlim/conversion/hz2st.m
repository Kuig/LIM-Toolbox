function [ N ] = hz2st( F, Fref, Nref, EDO )
%HZ2ST convert Hz to note numbers
%
%[ N ] = HZ2ST( F )
%[ N ] = HZ2ST( F, Fref )
%[ N ] = HZ2ST( F, Fref, Nref )
%[ N ] = HZ2ST( F, Fref, Nref, EDO )
%
%   Convert frequency values F to note number N based on:
%   Fref: reference frequency (default: 440)
%   Nref: N value corresponding to Fref (default: 69)
%   EDO:  Equal division of the octave (default: 12)
%
%   Note that [ N ] = HZ2ST( F, Fref, 0 ); returns the difference in
%   semitones between F and Fref.
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also ST2HZ, GETFREQCONVERTERS, RESCALEFREQ, AMP2DB, DB2AMP

    if nargin < 4, EDO = 12; end
    if nargin < 3, Nref = 69; end
    if nargin < 2, Fref = 440; end

    if any(F<0), warning ('Found F < 0 during log.freq. conversion!'); end

    N = EDO * log2(F./Fref) + Nref;

end

% ------------------------------------------------------------------------
%
% hz2st.m: convert Hz to note numbers
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