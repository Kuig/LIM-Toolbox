function [ H, S ] = analyzeMixture( X1, X2, F, T, res, varargin )
%ANALYZEMIXTURE plots Bivariate Spectrum and distributions
%
%[ H, S ] = ANALYZEMIXTURE( X1, X2, F, T, res )
%[ H, S ] = ANALYZEMIXTURE( _, 'name', 'value' )
%
%   X1,X2: spectra of signals to compare
%   F,T:   Frequency and time axes
%   res:   angle distribution resolution
%   
%   H: figure handles
%      H(1): BS-enhanced spectrogram
%      H(2): Overall distribution
%      H(3): Distribution over frequency
%      H(4): Distribution over time
%   S: a structure containing the following information
%      S.X, S.s, S.C:   bivariate Spectrum from BS()
%      S.D, S.Df, S.Dt: distributions from getMixtureHists()
%      S.edges, S.centers: distribution bin edges and centers from
%                          getBinEdges(res,[-pi/2,pi/2]);
%
% Optional parameters are:
%
%  'dbfloor': real < 0 (def -96) - lowest amplitude to display (in dBfs)
%  'clarity': real >= 0 (def 1) - Exponent of C for saturation correction
%  'yscale' : {'mel', 'bark', 'erbs', 'semitone', 'hz', 'log'} (def 'hz')
%  'gamma'  : real >= 0 (def 1) - render gamma: > 1 darkens, < 1 brightens
%  'rotate' : {'on', 'off'} (def 'on') centers plot over pi/4 such to have
%             common components of the mixture in the middle of the plot
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
% See also PLOTBS, PLOTDM, GETMIXTUREHISTS, BS, IMAGE

    [ dbFloor, clarityExp, yscale, gamma, rot ] = parseargs(varargin{:});

    [S.X,S.s,S.C] = BS( X1, X2 );
    [S.edges,S.centers] = getBinEdges(res,[-pi/2,pi/2]);
    [S.D,S.Df,S.Dt] = getMixtureHists(S.X,S.s,S.C,S.edges);
    
    xtk  = linspace(-pi/2,pi/2,9);
    xlb  = {'-^\pi/_2','','-^\pi/_4','','0.0','','^\pi/_4','','^\pi/_2'};
    cent = S.centers;
    Df   = S.Df;
    Dt   = S.Dt;
    
    if strcmpi(rot,'on')
        cent  = cent + pi/4;
        xtk  = xtk + pi/4;
        off  = -round(res/4);
        xlb  = {'-^\pi/_4','','0.0','','^\pi/_4','','^\pi/_2','','^3/_4 \pi'};
        Df   = circshift(Df, [0,off]);
        Dt   = circshift(Dt, [off,0]);
    end
    
    H(1) = subplot(3,3,[2,3,5,6]);
           plotBS(S.X,S.s,S.C,F,T,...
                  'yscale',yscale,...
                  'dbfloor',dbFloor,...
                  'clarity',clarityExp);
           zoom xon
    
    H(2) = subplot(3,3,7);
           plotdm( S.D, 'rotate', rot );
           ylabel('');
           xlabel('');
           grid on;
   
    H(3) = subplot(3,3,[1,4]);
           N = F;
           if ~strcmpi(yscale,'hz')
               [Df,N] = rescalefreq(Df,F,yscale);
           end
           Df = max(Df,0);
           imagesc(cent,N,Df.^gamma);
           set(gca,'xtick',xtk);
           set(gca,'xticklabel',xlb);
           colormap(1-gray);
           axis xy, grid on;

    H(4) = subplot(3,3,[8,9]);
           imagesc(T,cent,Dt.^gamma);
           axis xy, grid on;
           set(gca,'ytick',xtk);
           set(gca,'yticklabel',xlb);
           colormap(1-gray);
end

function [ dbFloor, clarityExp, yscale, gamma, rot ] = parseargs(varargin)
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
    
    defrot = 'on';
    valrot = {'on', 'off'};
    chkrot = @(x) any(validatestring(x,valrot));

    addParameter(p,'dbfloor',deffloor,chkfloor);
    addParameter(p,'clarity',defclarity,chkclarity);
    addParameter(p,'yscale',defScale,chkScale);
    addParameter(p,'gamma',defGamma,chkGamma);
    addParameter(p,'rotate',defrot,chkrot);
    
    parse(p,varargin{:})
    
    dbFloor = p.Results.dbfloor;
    clarityExp = p.Results.clarity;
    yscale = p.Results.yscale;
    gamma = p.Results.gamma;
    rot = p.Results.rotate;

end


% ------------------------------------------------------------------------
%
% analyzeMixture.m: plots Bivariate Spectrum and distributions
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