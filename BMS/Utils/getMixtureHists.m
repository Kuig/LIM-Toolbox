function [D, Df, Dt ] = getMixtureHists (X, s, C, edges)
%GETMIXTUREHISTS gets many sigma weighted-distributions of the BMS
%
%  D = GETMIXTUREHISTS (X, s, C, res)
%[ D, Df] = GETMIXTUREHISTS (X, s, C, res)
%[ D, Df, Dt ] = GETMIXTUREHISTS (X, s, C, res)
%
%   X, s, C: The Bivariate Spectrum (based on STFT)
%   edges:   Bins edges (def. 200 bind in range +/- pi/2)
%
%   D(:,1): overall angles distribution (|X| weight)
%   D(:,2): overall angles distribution (|X|*(1-|C|) weight)
%   D(:,3): overall angles distribution (|X|*|C| weight)
%   Df:     Distribution over frequency and angle (|X|*|C| weight)
%   Dt:     Distribution over time and angle (|X|*|C| weight)
%
%   Reference: Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also SANGLE, PSC, CCORR, HISTW, ANGLEMASK

    if nargin < 4
        edges = getBinEdges(200,[-pi/2,pi/2]);
    end
    
    if nargout < 3
        dims = 2;
    else
        dims = [1, 2];
    end
    
    aM = abs(X);
    aC = abs(C);
    W1 = aM.*aC;
    
    H  = histw( s, W1, edges, dims);  % hist over time and freq (correlated)
    
    if nargout < 3
        Df = H;                       % hist over freq (correlated)
    else
        Dt = H{1};                    % hist over time (correlated)
        Df = H{2};                    % hist over freq (correlated)
    end
    
    Dh = sum(Df);                               % overall hist (correlated)
    Dl = histw( s(:), aM(:).*(1-aC(:)),edges);  % overall hist (uncorrelated)
    
    Dl = Dl(:);
    Dh = Dh(:);
    D = [Dl + Dh, Dl, Dh];

end

% ------------------------------------------------------------------------
%
% getMixtureHists.m: get many sigma weighted-distribution of the BMS
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
