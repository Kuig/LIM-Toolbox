function [ X, s, C ] = BS( X1, X2 )
%BS calculates Principal Spectral Components and Relational Content
%
%[ X, s, C ] = BS( X1, X2 )
%[ X, R ] = BS( X1, X2 )
%
%   X: Principal Spectral Components of each corresponding X1 and X2 bin
%   s: Peaking BMS angles for each corresponding X1 and X2 bin
%   C: Correlation of each corresponding X1 and X2 bin
%   R: Relational content (complex sigma of each corresponding X1 and X2 bin) 
%
%   Reference: Presti, G. "The Bivariate Mixture Space: A Compact Spectral
%              Representation of Bivariate Signals", JAES Volume 71
%              Issue 7/8 pp. 481-491; July 2023
%              doi:10.17743/jaes.2022.0090
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also BMS, CCORR, SANGLE, PSC

    s = SAngle(X1,X2);
    X = BMS(X1,X2,s);
    if nargout > 2
        C = CCorr(X1,X2);
    else
        s = abs(s) .* exp(1i * (angle(X1)-angle(X2)));
    end
    
end

% ------------------------------------------------------------------------
%
% BS.m: calculates Principal Spectral Components and Relational Content
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