function [ M, S ] = msmatrix( L, R )
%MSMATRIX Mid-Side encoder and decoder
%
%[ MS ] = MSMATRIX( LR )
%[ MS ] = MSMATRIX( L, R )
%[ M, S ] = MSMATRIX( LR )
%[ M, S ] = MSMATRIX( L, R )
%
%   Mid-Side encoder and decoder, supports different kind of
%   representations (input and output as column vectors or n-by-2 matrix)
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also ANG2MAT, FADE, PANPOT

    cases = (nargin-1) + 2*(nargout-1);
    sqrt2 = sqrt(2);
    switch cases
        case 0
            if size(L,2) ~= 2, error('Input matrix must have 2 columns'); end
            M(:,1) = (L(:,1)+L(:,2))/sqrt2;
            M(:,2) = (L(:,1)-L(:,2))/sqrt2;
        case 1
            if (size(L,2) ~= 1) || (size(R,2) ~= 1), error('Input matrixes must have 1 column'); end
            M(:,1) = (L+R)/sqrt2;
            M(:,2) = (L-R)/sqrt2;
        case 2
            if size(L,2) ~= 2, error('Input matrix must have 2 columns'); end
            M = (L(:,1)+L(:,2))/sqrt2;
            S = (L(:,1)-L(:,2))/sqrt2;
        case 3
            if (size(L,2) ~= 1) || (size(R,2) ~= 1), error('Input matrixes must have 1 column'); end
            M = (L+R)/sqrt2;
            S = (L-R)/sqrt2;
        otherwise
            error('Wrong combination of input and output arguments');
    end
end

% ------------------------------------------------------------------------
%
% msmatrix.m: Mid-Side encoder and decoder
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
