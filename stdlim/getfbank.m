function [ fbank, cent ] = getfbank( F, bw, scale, wfunc, nb )
%GETFBANK returns a filterbank with given properties
%
%[ fbank, cent ] = GETFBANK( F )
%[ fbank, cent ] = GETFBANK( F, bw )
%[ fbank, cent ] = GETFBANK( F, bw, scale )
%[ fbank, cent ] = GETFBANK( F, bw, scale, wfunc )
%[ fbank, cent ] = GETFBANK( F, 'auto', scale, wfunc, nb )
%
%   get a filterbank fbank such fbank*getFD(x) is a filtered version of x.
%   So far, filters overlap is fixed to 50%, keep this in mind when
%   prepearing windowing functions
%
%   F:     Frequency of FFT bins (must be sorted in increasing order
%   bw:    badwidth of each filter (expressed in 'scale', default: 'auto')
%   scale: 'mel', 'bark', 'erbs', 'semitone', 'hz', 'log' (default: 'mel')
%   wfunc: Filter window function (default: @triang)
%
%   fbank: fbank such that fbank*GETFD(x) is the filtered version of x
%   cent:  band centers expressed in 'scale'
%
%   if bw is set to 'auto', bw is automatically set to match ERB scale
%   subdivision as closely as possible based on 'scale' representation
%   (usually used with 'bark' or 'mel')
%
%   if bw is set to 'auto', and additional nb parameter is provided, bw is
%   automatically set such to have 'nb' bands
%   (usually used with 'hz' or 'semitone')
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also GETFD, GETTD, RESCALEFREQ, GETFREQCONVERTERS


    if nargin < 2, bw = 'auto'; end
    if nargin < 3, scale = 'mel'; end
    if nargin < 4, wfunc = @triang; end

    [f2x, x2f, first_el] = getFreqConverters(scale, F);
    
    low  = f2x(F(first_el));
    high = f2x(F(end));
    
    if strcmpi('auto',bw)
        if nargin < 5
            nb = getErbEqNb(F, f2x);
        end
        bw = (high-low)/(nb+1);
    end
    
    nband = ceil( (high-low)/bw - 1 );
    
    cent = low + linspace(1,nband,nband).*bw;
    inferior = x2f(cent-bw);
    superior = x2f(cent+bw);
    
    n = length(F);
    fbank=zeros(nband,n);
    for b=1:nband 
        il=findx(F, inferior(b));
        ih=findx(F, superior(b));
        fbank(b,il:ih)=wfunc(ih-il+1);
    end
    
end

function indx = findx(X, val)
    X = abs(X-val); 
    [~, indx] = min(X); 
end

function nb = getErbEqNb(F, f2x)
% Thanks Marco for the clever idea
    if F(1) <= 0
        lb = F(2);
    else
        lb = F(1);
    end
    ub = F(end);
    f = 10.^(linspace(log10(lb),log10(ub),1024));
    XERB = f2x([ f-hz2ERB(f)/2 ; f+hz2ERB(f)/2 ]);
    XERBbwdth = XERB(2,:)-XERB(1,:);
    bw = mean(XERBbwdth);
%     nb = 2*(f2x(ub)-f2x(lb))/bw - 1;
    nb = (f2x(ub)-f2x(lb))/bw - 1;
end

% ------------------------------------------------------------------------
%
% getfbank.m: returns a filterbank with given properties
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