function [ ] = plotdm( D, varargin )
%PLOTDM plots BMS distributions and mask with given parameters
%
%PLOTDM( D )
%PLOTDM( D, pos, H )
%PLOTDM( ___ , 'name', 'value' )
%
%   Plots columns present in D as distributions
%   if pos and H are not empty, also plots a mask centered in pos, with
%   lobes at pos-H(1) and pos+H(2) (or pos+-H if H is a scalar)
%
%Optional parameters are:
%
%   'type': {'rect, 'gauss'} (def 'rect') inherited from angleMask
%   'saturation': real >= 0 (def 0) inherited from angleMask
%   'background': m-by-n real matrix (def []) grayscale image to be used as
%                 background, usually an angles/frequency distribution
%   'rotate': {'on', 'off'} (def 'off') centers plot over pi/4 such to have
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
% See also ANALYZEMIXTURE, PLOTBS, ANGLEMASK


    [pos, H, maskType, satur, BG, rot] = parseargs(varargin{:});

    res = 180;
    top = 10;
    if ~isempty(D)
        res = size(D,1);
        top = max(D(:));
        top = ceil(top / 10) * 10;
    end
    [~,cen] = getBinEdges(res,[-pi/2,pi/2]);
    
    msk = [];
    if ~isempty(pos)
        msk = angleMask(cen(:),pos,H,'type',maskType,'saturation',satur);
    end

    xtk  = linspace(-pi/2,pi/2,9);
    xlb  = {'-^\pi/_2','','-^\pi/_4','','0.0','','^\pi/_4','','^\pi/_2'};
    limx = [-pi/2,pi/2];
    
    if strcmpi(rot,'on')
        cen  = cen + pi/4;
        xtk  = xtk + pi/4;
        limx = limx + pi/4;
        off  = -round(res/4);
        bgof = -round(size(BG,2)/4);
        xlb  = {'-^\pi/_4','','0.0','','^\pi/_4','','^\pi/_2','','^3/_4 \pi'};
        msk  = circshift(msk,[off,0]);
        D    = circshift(D,  [off,0]);
        BG   = circshift(BG, [0,bgof]);
    end
    
    bgy = linspace(0,top,size(BG,1));
    bgx = linspace(cen(1),cen(end),size(BG,2));
    imagesc(bgx,bgy,BG);
    colormap (1-gray); axis xy;
    hold on;
    
    for dd = 1:size(D,2)
        plot(cen,D(:,dd),'linewidth',1.2);
    end
    
    if ~isempty(pos)
        plot([pos,pos],[0,top],':g','linewidth',1.2);
        plot(cen,msk*top,'r','linewidth',1.2);
    end
    
    hold off
    xlim(limx);
    set(gca,'xtick',xtk);
    set(gca,'xticklabel',xlb);
    xlabel('\sigma'); ylabel('Contribution to |X|');
    grid on

end

function [pt, H, maskType, satur, BG, rot] = parseargs(varargin)
% This is the input arguments parser
    p = inputParser;
    
    defmask = 'rect';
    valmask = {'rect', 'gauss'};
    chkmask = @(x) any(validatestring(x,valmask));

    defsatur = 0;
    chksatur = @(x) x>=0;
    
    defBG = [];
    chkBG = @(x) ismatrix(x) && isreal(x);

    defrot = 'off';
    valrot = {'on', 'off'};
    chkrot = @(x) any(validatestring(x,valrot));
    
    
    addOptional(p,'p',[],@(x) isscalar(x));
    addOptional(p,'H',[],@(x) numel(x)<3);
    addParameter(p,'type',defmask,chkmask);
    addParameter(p,'saturation',defsatur,chksatur);
    addParameter(p,'background',defBG,chkBG);
    addParameter(p,'rotate',defrot,chkrot);
    
    parse(p,varargin{:})
    
    pt = p.Results.p;
    H = p.Results.H;
    maskType = p.Results.type;
    satur = p.Results.saturation;
    BG = p.Results.background;
    rot = p.Results.rotate;
end

% ------------------------------------------------------------------------
%
% plotdm.m: plots BMS distributions and mask
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