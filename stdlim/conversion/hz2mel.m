function [ mel ] = hz2mel( f )
%HZ2MEL convert Hz to mels
%
%[ mel ] = HZ2MEL( f )
%
%    Reference: O'shaughnessy, Douglas. Speech communication: human and
%               machine. Universities press, 1987.
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also MEL2HZ, GETFREQCONVERTERS, RESCALEFREQ

    mel = 2595 * log10( 1 + f/700 );

end

% ------------------------------------------------------------------------
%
% hz2mel.m: convert Hz to mels
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