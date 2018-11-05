function [ o, a ] = fixangles( t )
%FIXANGLES takes a transformation matrix and gives back a rotation marix
%
% [ o, a ] = FIXANGLES( t )
%
%    Takes 2 2d vectors t (size 2x2) and returns 2d vectors o (size 2x2)
%    with unity norm and a direction which is the same as the one of t but
%    folded into the range +/- pi/2. The function also returns the output
%    angles a as a 2 elements vector (size 1x2)
%
%    This function is used to fix ICA mixing matrix, such that mixing matrix
%    is transformed into proper bases with no gain change and with consistent
%    phase behaviour.
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also PANPOT, MSMATRIX, ANG2MAT


    nc = size(t,2);
    o = zeros(size(t));
    a = zeros(1,nc);

    if size(t,1) ~= 2, error('This version only supports 2-by-n matrixes'); end
    
    for c = 1:nc
        o(:,c) = t(:,c);
        a(c) = atan2(t(2,c),t(1,c));
        if btwn(a(c),pi/2,pi) || btwn(a(c),-pi,-pi/2) || a(c)==pi
            o(:,c) = -t(:,c);
            a(c) = atan2(o(2,c),o(1,c));
        end
    end
    
    if exist('vecnorm') == 2 
        o = o ./ vecnorm(o); % Introduced in R2017b
    else
        for c = 1:size(o,2)
            o(:,c) = o(:,c) ./ norm(o(:,c));
        end
    end

end

function [ y ] = btwn( x,a,b )
%[ y ] = btwn( x,a,b )
%   is "a < x <= b" ?
    if b<a
        a = a + b;
        b = a - b;
        a = a - b;
    end
    y = (x>a && x<=b);
end

% ------------------------------------------------------------------------
%
% fixangles.m: takes a transformation matrix and gives a rotation marix
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