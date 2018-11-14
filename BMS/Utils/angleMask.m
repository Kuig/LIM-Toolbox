function [ M ] = angleMask( s, p, H, varargin )
%ANGLEMASK returns a mask based on given angles
%
%[ M ] = ANGLEMASK( s, p, H )
%[ _ ] = ANGLEMASK( _, 'name', 'value' )
%
%   Mask of points around p, use plotdm() as a tool to choose p & H
%   s: bivariate Spectrum angles or any set of angles between +/- pi/2
%   p: reference angle to be masked
%   H: mask span, behaviour depends on mask type
%
%Optional parameters are:
%
%   'type': {'rect, 'gauss'} (def 'rect') - choose between binary or soft
%           masking. In case of 'rect', H = [l,u] defines lower (l) and 
%           upper (u) mask tolerance (uses p +/- H if scalar).
%           In case of 'gauss', H sets the bell width (uses mean(H) in case
%           of a vector)
%   'saturation': real >= 0 (def 0) - Typically between 0 and 1, is the
%           amount of mask saturation, a smooth gaussian for saturation = 0
%           or an almost rectangular window for saturation = 1
%
%   Reference: Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also SANGLE, GETMIXTUREHISTS, PLOTDM

    [maskType, satur] = parseargs(varargin{:});
    
    s = mod( s - p + pi/2, pi ) - pi/2;
    
    switch lower(maskType)
        case 'rect'
            if isscalar(H), H = [H,H]; end
            low = mod((-H(1))+pi/2,pi)-pi/2;
            hig = mod(( H(2))+pi/2,pi)-pi/2;
            if low > hig
                M = (s > low) | (s < hig);
            else
                M = (s > low) & (s < hig);
            end
        case 'gauss'
            H = mean(H);
            M = gauss(s,H);
            if satur ~= 0
                M = sat(M,satur);
            end
        otherwise
            error('Unknown mask type');
    end

    
end

function y = gauss(x,w)
    % gaussian function of x with a width of w
    y = exp( -(x.^2) / ( ( (1/sqrt(log(2))) * w ) .^2 ) );

end

function y = sat(x,s)
    % saturate x by a factor s (scalar float ideally between 0 and 1)
    g = max(0,exp(s*10 - 2) - exp(-2));
    y = 0.5 + atan((x-0.5) * 2 * g) / (2*atan(g));
    
end

function [maskType, satur] = parseargs(varargin)
% This is the input arguments parser
    p = inputParser;
    
    defmask = 'rect';
    valmask = {'rect', 'gauss'};
    chkmask = @(x) any(validatestring(x,valmask));

    defsatur = 0;
    chksatur = @(x) x>=0;

    addParameter(p,'type',defmask,chkmask);
    addParameter(p,'saturation',defsatur,chksatur);
    
    parse(p,varargin{:})
    
    maskType = p.Results.type;
    satur = p.Results.saturation;
end

% ------------------------------------------------------------------------
%
% angleMask.m: returns a mask based on given angles
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