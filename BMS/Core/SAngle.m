function [ s ] = SAngle( X1, X2 )
%SANGLE peaking angles of the Bivariate Mixture Space
%
%[ s ] = SAngle( X1, X2 )
%
%   Reference: Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%(C)2009 G.Presti (LIM) - GPL license at the end of file
% See also BS, BMS, CCORR, PSC

    if any (size(X1) ~= size(X2))
        error('X1 and X2 must be of same size');
    end

    s = 0.5 .* atan2 ( 2.*(imag(X1).*imag(X2) + real(X1).*real(X2)),...
                       abs(X1).^2-abs(X2).^2 );

%     s = 0.5 .* atan2 ( 2 .* abs(X1) .* abs(X2) .* cos(angle(X1)-angle(X2)),...
%                        abs(X1).^2-abs(X2).^2 );

end

% ------------------------------------------------------------------------
%
% SAngle.m: peaking angles of the Bivariate Mixture Space
% Copyright (C) 2009 - Giorgio Presti - Laboratorio di Informatica Musicale
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
