function [ IMG ] = rescaleamp( STFT, dbLow, dbHigh )
%RESCALEAMP rescale values to dB, then takes result into range 0-1
%
%[ IMG ] = RESCALEAMP( STFT )
%[ IMG ] = RESCALEAMP( STFT, dbLow )
%[ IMG ] = RESCALEAMP( STFT, dbLow, dbHigh )
%
%   Takes the STFT output of a spectrogram function and returns a matrix of
%   the same size in the range 0-1, where 0 is the lowest level and 1 is
%   the highest. Levels have a logarithmic scale.
%   dbLow sets the level corresponding to 0, dbHigh sets the level 1.
%   Both are expressed in dBfs.
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also RESCALEFREQ, AMP2DB, DB2AMP, IMAGE

    if nargin < 2
        [IMG,dbLow] = amp2db(abs(STFT));
    else
        IMG = amp2db(abs(STFT),dbLow);
    end
    IMG = IMG-dbLow;
    if nargin < 3
        dbHigh = max(IMG(:)); 
    else
        IMG = min(IMG,(dbHigh-dbLow));
    end
    IMG = IMG / dbHigh;

end

% ------------------------------------------------------------------------
%
% rescaleamp.m: rescale values to dB, then takes result into range 0-1
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