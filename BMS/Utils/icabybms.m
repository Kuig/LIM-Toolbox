function [ ica, W, A, ma, Dp, a ] = icabybms( x, varargin )
%ICABYBMS independent component analysis of a bivariate signal
%
%[ ica, W, A, ma, Dp, a ] = ICABYBMS( x )
%[ ica, W, A, ma, Dp, a ] = ICABYBMS( _, 'name', 'value' )
%
% This function returns the ICA of a bivariate signal x of size Nx2,
% together with mixing and unmixing matrices (W and A), mixing angles (ma),
% and angles distribution (Dp and bins centers a).
%
% Optional parameters are:
%
%   'whitening' : {'on', 'off'} (def 'on') - Use whitening?
%   'WSpeedUp'  : {'on', 'off'} (def 'on') - Exploit whitening to speed up peak finding
%   'resolution': int > 0 or 'auto' (def 180) - Distribution bins number
%   'corrWeight': real >= 0 (def 1) - Gamma parameter
%   'smoothing' : real >= 0 (def 0) - Smoothing radius in radians
%   'ampExp'    : real >= 0 (def 1) - Magnitude exponent
%   'refineMode': {'peak', 'mean', 'top5', 'none'} (def 'top5') - See step 7
%
% The function works as follow:
%   1. Whiten input signal
%   2. Takes the FFT of the two channels
%   3. Compute the Bivariate Spectrum
%   4. Compute the angles C-Weighted Distribution
%   5. Smooth the distribution
%   6. Find distribution peaks
%   7. Look inside peaking distribution bins to find actual signal peaks
%   8. Compute mixing and unmixing matrix from the angles found
%   9. Unmix the signal
%
%   Reference: TBA
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also WHITENING
    
    % Parsing input arguments
    [reso, refineMode, cWeight, smth, ascale, whit,wsu] = parseargs(varargin{:});

    % Choose appropriate resolution for angles distribution if needed
    if strcmpi(reso,'auto')
        reso = 180;
        if strcmpi(whit, 'off')
            ag = guessangle(x,60,30);
            reso = ceil(pi/ag);
        end
    end
    
    % Whiten signal
    if strcmpi(whit,'on')
        [data, ~, dwm] = whitening(x);
        if isnan(dwm)
            warning('Having troubles whitening (eigenvalues smaller than tolerance or complex whitened signal), whitening will be turned off');
            whit = 'off';
        end
    else
        data = x;
    end
    
    % FFT
    [L, ~, ~] = getFD(data(:,1),1);
    [R, ~, ~] = getFD(data(:,2),1);

    % Bivariate spectrum
    s = SAngle(L,R);
    X = abs(BMS(L,R,s));
    
    % Amplitude tweaking
    if ascale ~= 1, X = X.^ascale; end
    
    % Correlation weighting
    switch cWeight
        case 0
            weight = X;
        otherwise
            % slightly better in terms of precision
            weight = X.*abs(CCorr(L,R)).^cWeight;
    end
    
    % Calculate distribution
    [edg, a] = getBinEdges(reso,[-pi/2, pi/2]);
    Dp = histw(s(:),weight(:),edg);
    
    % Smooth the distribution
    if smth > 0
        Dp = smooth(a, Dp, smth, 'moving');
    end
    
    % Find distribution peak(s)
    if strcmpi(whit,'off') || strcmpi(wsu,'off')
        [~, mi] = findpeaks(Dp,'SortStr','descend','NPeaks',2);
    else
        [~, mi] = max(Dp);
    end
    ma = a(mi);
    
    % Look inside peaking distribution bin to find actual peak
    s = s(:); weight = weight(:);
    for c = 1:numel(ma)
        msk = (s>(ma(c)-pi/reso)) & (s<(ma(c)+pi/reso));
        switch lower(refineMode)
            case 'mean'
                ma(c) = sum(s(msk).*weight(msk))./sum(weight(msk));
            case 'peak'
                [~,idx] = max(weight(msk));
                tmp = s(msk);
                ma(c) = tmp(idx);
            case 'top5'
                tmpS = s(msk);
                tmpW = weight(msk);
                msk = tmpW > prctile(tmpW,95);
                nw = tmpW(msk);
                ma(c) = sum(tmpS(msk).*nw)./sum(nw);
            case 'none'
            otherwise
                error(['Unhandled mode ' refineMode]);
        end
    end

    % Calculate mixing matrix from the angles found
    if strcmpi(whit,'on')
        if strcmpi(wsu,'on')
            ma(2) =  ma(1)+pi/2;
        end
        W = dwm*[cos(ma);sin(ma)]; % Matrice di mix
        [W,ma] = fixangles(W);
    else
        W = [cos(ma);sin(ma)]; % Matrice di mix
    end
    
    % Unmixing matrix as the inverse of the mixing matrix
    if size(W,1)==size(W,2)
        A = inv(W); % Matrice di demix
        ica = (A * x.').'; % Demixing
    else
        A = NaN;
        ica = x;
        warning('ICA by BMS failed to find more than one source, try with other settings or check your input');
    end
    
    
end

function [reso, refineMode, cWeight, smth, ascale, whit, wsu] = parseargs(varargin)
% This is the input arguments parser
    p = inputParser;
    
    defReso = 180;
    chkReso = @(x) strcmpi(x,'auto') | (isscalar(x)&(x(1)>0));
    
    defRefM = 'top5';
    valRefM = {'peak', 'mean', 'top5', 'none'};
    chkRefM = @(x) any(validatestring(x,valRefM));

    defScale = 1;
    chkScale = @(x) x>=0;
    
    defCWei = 1;
    chkCWei = @(x) x>=0;
    
    defSmth = 0;
    chkSmth = @(x) x>=0;
    
    defWit = 'on';
    valWit = {'on', 'off'};
    chkWit = @(x) any(validatestring(x,valWit));

    defwsu = 'on';
    valwsu = {'on', 'off'};
    chkwsu = @(x) any(validatestring(x,valwsu));
    
    addParameter(p,'resolution',defReso,chkReso);
    addParameter(p,'refineMode',defRefM,chkRefM);
    addParameter(p,'corrWeight',defCWei,chkCWei);
    addParameter(p,'smoothing',defSmth,chkSmth);
    addParameter(p,'ampExp',defScale,chkScale);
    addParameter(p,'whitening',defWit,chkWit);
    addParameter(p,'WSpeedUp',defwsu,chkwsu);
    
    parse(p,varargin{:})
    
    reso = p.Results.resolution;
    refineMode = p.Results.refineMode;
    cWeight = p.Results.corrWeight;
    smth = p.Results.smoothing;
    ascale = p.Results.ampExp;
    whit = p.Results.whitening;
    wsu = p.Results.WSpeedUp;
end

function [ ang ] = guessangle( y, numSamples, threshold, bounds )
% [ ang ] = guessangle( y, numSamples, threshold, bounds )
%
% This is an euristic function that returns an angle which is almost always
% smaller than the angular distance between two latent sources
%
% y is a 2 columns signal, numSamples is the absolute number of samples
% above the threshold to be considered (default 60), threshold is the
% percentile valure used to select the peaks of the signal (default 30),
% bounds is a 2 elements vector containing minimum and maximum angles
% returned by the function (default [0.05/180*pi, 12/180*pi])
%
% The angle guess is made by finding the regression line of a decimated
% version of y and then using the 95% confidence interval of the slope as
% an estimate of the angular distance of the latent sources

    if nargin < 2, numSamples = 60; end
    if nargin < 3, threshold  = 30; end
    if nargin < 4, bounds  = [0.05/180*pi, 12/180*pi]; end

    numSamples = max(10,ceil(numSamples*100/threshold));
    [ys(:,1),idx] = datasample(y(:,1),numSamples);
    ys(:,2) = y(idx,2);
    mon = mean(ys,2);
    msk = mon > prctile(abs(mon),threshold);
    
    try
        [b,S] = polyfit(ys(msk,1), ys(msk,2), 1);
        p = polyparci(b,S);
    catch
        warning('Cannot guess angle, choosing maximum resolution');
        p = [0,0;0,0];
    end
    
    ang = atan(p(:,1));
    ang = pi/2-abs(abs(ang(1) - ang(2))-pi/2);
    ang = max(ang,bounds(1));
    ang = min(ang,bounds(2));
    
end

% ------------------------------------------------------------------------
%
% icabybms.m: independent component analysis of a bivariate signal
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