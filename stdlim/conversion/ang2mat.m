function [ A ] = ang2mat( angles, doFix )
%ANG2MAT Convert given angles (in radians) to a rotation matrix
%
%[ A ] = ang2mat( angles, doFix )
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also PANPOT, MSMATRIX, FIXANGLES

    if nargin < 2, doFix = 0; end

    angles = angles(:).';
    
     A = [cos(angles);...
          sin(angles)];

    if doFix, A = fixangles(A); end
  
end

% ------------------------------------------------------------------------
%
% ang2mat.m: Convert given angles in rad to rotation matrix
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