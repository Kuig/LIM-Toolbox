function [ IMG, F ] = plotBS( M, s, C, F, T, varargin )
%PLOTBS plot the BS-Enhanced spectrogram or get the corresponding RGB image
%
% PLOTBS( M, s, C, F, T )
% PLOTBS( ___, 'name', 'value' )
%[ IMG, F ] = PLOTBS( ___ )
%
%   Use this function to plot the BS-Enhanced spectrogram or simply get the
%   corresponding RGB image IMG.
%
%   M:          Principal Spectral Content
%   s:          BMS Angles
%   C:          BMS Correlation
%   F, T:       Frequency and time axes
%
% Optional parameters are:
%
%  'dbfloor': real < 0 (def -96) - lowest amplitude to display (in dBfs)
%  'clarity': real >= 0 (def 1) - Exponent of C for saturation correction
%  'yscale' : {'mel', 'bark', 'erbs', 'semitone', 'hz', 'log'} (def 'hz')
%  'gamma'  : real >= 0 (def 1) - render gamma: > 1 darkens, < 1 brightens
%
%   IMG: RGB image
%   F:   New frequency axis (according to fscale)
%
%   Reference: Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%              Presti, Giorgio, Goffredo Haus, and Davide Andrea Mauro.
%              "Visualization and manipulation of stereophonic audio
%              signals by means of IID and IPD." joint ICMC|SMC|2014 (2014).
%
%(C)2009 G.Presti (LIM) - GPL license at the end of file
% See also BS, ANALYZEMIXTURE, IMAGE

    [ dbFloor, clarityExp, yscale, gamma ] = parseargs(varargin{:});

    H = mod((s+pi/2)/pi-0.25,1);
    S = abs(C).^clarityExp;
    V = rescaleamp( M, dbFloor );
    IMG = cat(3, H,S,V);
    IMG = hsv2rgb(IMG);

    if ~strcmpi(yscale,'hz')
        [IMG,F] = rescalefreq(IMG,F,yscale,'int');
        IMG = max(IMG,0);
    end

    if nargout < 1
        image(T,F,IMG.^gamma);
        axis xy;
    end

end

function [ dbFloor, clarityExp, yscale, gamma ] = parseargs(varargin)
% This is the input arguments parser
    p = inputParser;
    
    deffloor = -96;
    chkfloor = @(x) isscalar(x);
    
    defclarity = 1;
    chkclarity = @(x) isscalar(x);

    defScale = 'hz';
    valScale = {'mel', 'bark', 'erbs', 'erb', 'semitone', 'st', 'hz', 'log'};
    chkScale = @(x) any(validatestring(x,valScale));
    
    defGamma = 1;
    chkGamma = @(x) isscalar(x);

    addParameter(p,'dbfloor',deffloor,chkfloor);
    addParameter(p,'clarity',defclarity,chkclarity);
    addParameter(p,'yscale',defScale,chkScale);
    addParameter(p,'gamma',defGamma,chkGamma);
    
    parse(p,varargin{:})
    
    dbFloor = p.Results.dbfloor;
    clarityExp = p.Results.clarity;
    yscale = p.Results.yscale;
    gamma = p.Results.gamma;

end

% ------------------------------------------------------------------------
%
% plotBS.m: samples the Bivariate Mixture Space at angles in alpha
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