function [ x ] = fade( x, direction, len, slope )
%FADE fades beginning or ending of the columns of a signal
%
%[ x ] = FADE( x, direction, len, slope )
%
%   direction: fade 'in', 'out', 'inout'
%   len:       duration of the fade in samples
%   slope:     exponent of the modulation ramp
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also PANPOT, OVERLAP

    if nargin < 4, slope = 0.5; end
    if len > size(x,1), error('Error using fade(): fade longer than signal'); end
    switch lower(direction)
        case 'in'
            env = (linspace(0,1,len).').^slope;
            x(1:len,:) = bsxfun(@times, x(1:len,:), env);
        case 'out'
            env = (linspace(1,0,len).').^slope;
            x(1+end-len:end,:) = bsxfun(@times, x(1+end-len:end,:), env);
        case 'inout'
            x = fade(x, 'in', len, slope);
            x = fade(x, 'out', len, slope);
        otherwise
            error('Error using fade(): direction can be ''in'', ''out'' or ''inout''');
    end

end

% ------------------------------------------------------------------------
%
% fade.m: fades beginning or end of the columns of a signal
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