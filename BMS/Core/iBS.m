function [X1,X2] = iBS(X,R)
%IBS approximates the invers Bivariate Spectrum from the PSC X and RC R
%
%[ X1, X2 ] = IBS( X, R )
%
%   X: Principal Spectral Components of each corresponding X1 and X2 bin
%   R: Relational content (complex sigma of each corresponding X1 and X2 bin) 
%
%   Reference: TBA
%
%(C)2019 G.Presti (LIM) - GPL license at the end of file
% See also BMS, CCORR, SANGLE, PSC, BS

    X1 = X .* cos(R);
    X2 = X .* sin(R);
    
% Given the aboe model, the correct way to compute X and R should be:
%   X = sqrt(X1.^2 + x2.^2);
%   R = 2 * atan2( sqrt(X1.^2 + x2.^2)-X1 , X2 );
% But atan2 works only with real inputs, and X2 must be ~= 0.
% By using R computed as
%   R = abs(s) * exp(i(angle(X1)-angle(X2)));
% The mean square error of the approximation is about -90 dB

end

% ------------------------------------------------------------------------
%
% iBS.m: Approximate inverse Bivariate Spectrum
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

