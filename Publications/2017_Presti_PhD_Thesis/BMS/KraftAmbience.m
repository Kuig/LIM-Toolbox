function [ M, S ] = KraftAmbience( L, R, c, phasehandling )
%KRAFTAMBIENCE separate ambience from direct signal
%
%[ M, S ] = KRAFTAMBIENCE( L, R, c, phasehandling )
%
%   L, R: STFT of input channels
%   c:    correlation clarity exponent (def. 1)
%   phasehandling: if set to 0 output STFT inherits phase from input mix
%
%   M, S: STFT of direct signal and ambience respectively
%
%   for c = 0 and phasehandling = 0 implements Kraft 2015
%
%   Reference: Kraft, Sebastian, and Udo Zölzer. "Stereo signal separation
%              and upmixing by mid-side decomposition in the
%              frequency-domain." 18th International Conference on Digital
%              Audio Effects (DAFx). 2015.
%
%              Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%(C)2017 G.Presti (LIM) - GPL license at the end of file
% See also PSC

    if nargin < 4, phasehandling = 1; end
    if nargin < 3, c = 1; end

    [M, S] = PSC(L,R);
    
    if c > 0
        clarity = abs(CCorr(L,R)).^c;
    else
        clarity = 1;
    end
    
    M = M .* clarity;
    S = S + M .* ( 1 - clarity );
    
    if phasehandling == 0
        % replicate phase behaviour of Kraft 2015
        phase = angle(L+R);
        M = ( abs(M) .* exp(1i*phase) );
        phase = angle(L-R);
        S = ( abs(S) .* exp(1i*phase) );
    end
    
end

% ------------------------------------------------------------------------
%
% lim_toolbox_test.m: test if all lim-toolbox functions can be executed
% Copyright (C) 2017 - Laboratorio di Informatica Musicale
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