function [ S ] = ADRess( L, R, p, H )
%ADRESS ADRess algorithm implemented as BMS masking
%
%[ S ] = ADRESS( L, R, p, H )
%
%   L, R: STFT of input channels
%   p:    stereophonic position to sample
%   H:    position tolerance
%   S:    extracted source STFT
%
%   Reference: Barry, Dan, and Robert Lawlor. "Sound source separation:
%              Azimuth discrimination and resynthesis." 7th International
%              Conference on Digital Audio Effects (DAFx-04). 2004.
%
%              Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also BS, ANGLEMASK, PLOTDM, KRAFTAMBIENCE, FOCUS

    [M, s, ~] = BS(L,R);
    
    mask = angleMask( s, p, H );

    % replicate phase behaviour of ADRess
    if (p > -pi/4) && (p < pi/4)
        phase = angle(L);
    else
        phase = angle(R);
    end
    
    S = ( abs(M).*exp(1i*phase) );
    S = S .* mask;
    
end

% ------------------------------------------------------------------------
%
% ADRess.m: ADRess algorithm implemented as BMS masking
% Copyright (C) 2014 - Laboratorio di Informatica Musicale
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