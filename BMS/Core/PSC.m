function [ X, Y ] = PSC( X1, X2 )
%PSC gets the Principal Spectral Components of given mixtures
%
%[ X ] = PSC( X1, X2 )
%
%   X: Principal Spectral Components X of mixtures X1 and X2
%
%[ X, Y ] = PSC( X1, X2 )
%
%   Y: Orthogonal componenst (residuals) of X
%
%   Reference: Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also BS, BMS, CCORR, SANGLE

    s = SAngle(X1,X2);
    X = BMS(X1,X2,s);

    if nargout > 1
        Y = BMS(X1,X2,s-(pi/2));
    end

end

% ------------------------------------------------------------------------
%
% PSC.m: gets the Principal Spectral Components of given mixtures
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