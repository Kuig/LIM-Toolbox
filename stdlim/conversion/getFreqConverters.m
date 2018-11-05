function [ f2x, x2f, fe ] = getFreqConverters( tgt, F )
%GETFREQCONVERTERS returns functions to convert Hz to a given scale
%
%[ f2x, x2f, fe ] = GETFREQCONVERTERS( tgt )
%[ f2x, x2f, fe ] = GETFREQCONVERTERS( tgt, F )
%
%    tgt: 'mel', 'bark', 'erbs', 'semitone', 'hz', 'log'
%    F: Frequency axis, used to check for log() argument (default [0, 1]);
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also HZ2ST, ST2HZ, HZ2ERBS, ERBS2HZ, HZ2ERB, ERB2HZ, HZ2BARK, BARK2HZ, HZ2MEL, MEL2HZ, GETFBANK, RESCALEFREQ

    if nargin < 2, F = [0,1]; end
    fe = 1;
    switch lower(tgt)
        case {'mel','mels'}
            f2x = @hz2mel; x2f = @mel2hz;
        case {'bark','barks'}
            f2x = @hz2bark; x2f = @bark2hz;
        case {'st','semitone','semitones'}
            f2x = @hz2st; x2f = @st2hz;
            if F(1) <= 0, fe = 2; end
        case {'erb', 'erbs'}
            f2x = @hz2erbs; x2f = @erbs2hz;
        case 'log'
            f2x = @(x) log(x); x2f = @(x) exp(x);
            if F(1) <= 0, fe = 2; end
        case 'hz'
            f2x = @(x) x; x2f = @(x) x;
        otherwise
            error(['Unsupported scale type: ', scale]);
    end
end

% ------------------------------------------------------------------------
%
% getFreqConverters.m: returns functions to convert Hz to a given scale
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