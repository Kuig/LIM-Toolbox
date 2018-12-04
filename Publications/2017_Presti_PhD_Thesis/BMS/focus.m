function [ M ] = focus( L, R, p, H, c )
%FOCUS resamples and masks the BMS around a given angle
%
%[ M ] = FOCUS( L, R, p, H, c )
%
%   Resample and mask the BMS around angle p, use plotdm() as a tool to
%   choose the most suitable parameters
%
%   L, R: STFT of input channels
%   p:    angle to sample
%   H:    upper and lower range (uses [H,H] if scalar)
%   c:    correlation selection coefficient (clarity)
%         c=0: ignore
%         c>0: select correlated
%         c<0: select uncorrelated
%
%   M: extracted source STFT
%
%   This function cannot be considered an effective source separation tool,
%   it is just a demonstration of BMS applications
%
%   Reference: Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also BMS, ANGLEMASK, PLOTDM, ADRESS

    if nargin < 5, c = 0; end
    
    s = SAngle(L,R);
    
    mask = angleMask( s, p, H, 'type', 'gauss', 'saturation', 0.4 );
    
    if c ~= 0
        C = abs(CCorr(L,R)).^abs(c);
        M = BMS(L,R,p);
        if c > 0
            M = M .*    mask   + ...
                M .* (1-mask) .* (1-C);
        else
            M = M .* mask .* C;
        end
    else
        M = BMS(L,R,p).*mask;
    end
    
end

% ------------------------------------------------------------------------
%
% focus.m: resamples and masks the BMS around a given angle
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