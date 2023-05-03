function [ fbank, bcen ] = getfilterbank( F, scale, nb, bw, wType, trans )
%GETFILTERBANK returns a filterbank with given properties
%
%[ fbank, bcen ] = GETFILTERBANK( F )
%[ fbank, bcen ] = GETFILTERBANK( F, scale )
%[ fbank, bcen ] = GETFILTERBANK( F, scale, nb )
%[ fbank, bcen ] = GETFILTERBANK( F, scale, nb, bw)
%[ fbank, bcen ] = GETFILTERBANK( F, scale, nb, bw, wType )
%[ fbank, bcen ] = GETFILTERBANK( F, cf, __ )      :::::: to be implemented
%[ fbank, bcen ] = GETFILTERBANK( F, [], xf, __ )  :::::: to be implemented
%
%   get a filterbank fbank such fbank*getFD(x) is a filtered version of x.
%
%   F:     Frequency of FFT bins (must be sorted in increasing order)
%   scale: 'mel', 'bark', 'erbs', 'semitone', 'hz', 'log' (default: 'mel')
%   nb:    number of bands (default [])
%   bw:    badwidth of each filter (expressed in 'scale', default: [])
%   xf:    Crossover frequencies array (expressed in 'scale')
%   cf:    Center frequencies array (expressed in 'scale')
%   wType: Filter window function ('tri','cos','pow'; default: 'tri')
%   trans: Transition phase as ratio of bw (default: 1)
%
%   fbank: fbank such that fbank*GETFD(x) is the filtered version of x
%   bcen:  band centers expressed in 'scale'
%
%   if 'nb' and 'bw' are set to [], they are automatically set to match as 
%   closely as possible the ERB scale subdivision, based on given 'scale' 
%   representation (usually used with 'bark' or 'mel')
%
%   if just one among 'nb' or 'bw' is set to [], it is automatically set to
%   a value that results in a 50% overlapping bands given the provided
%   parameter.
%
%   if both 'nb' and 'bw' are scalar values, overlappings other than 50%
%   can be achieved.
%
%   Please note that the first and the last bands are a lowpass and a
%   highpass respectively.
%
%(C)2022 G.Presti (LIM) - GPL license at the end of file
% See also GETFD, GETTD, RESCALEFREQ, GETFREQCONVERTERS

    if nargin == 0, F = linspace(0, 22050, 1024); end

    %   scale: 'mel', 'bark', 'erbs', 'semitone', 'hz', 'log' 
    if nargin < 2, scale = 'mel'; end
    if nargin < 3, nb = []; end
    if nargin < 4, bw = []; end
    if nargin < 5, wType = 'tri'; end
    if nargin < 6, trans = 1; end

    if any(diff(F)<=0), error('F must be a monotonically increasing array'); end

    [f2x, x2f, first_el] = getFreqConverters(scale, F);

    low  = f2x(F(first_el));
    high = f2x(F(end));

    if isempty(nb)
        if isempty(bw)
            nb = getErbEqNb(F, f2x);
        else
            nb = (high-low)/bw - 1;
        end

        nb = max(1, round(nb));
    end

    bhop = (high-low)/(nb+1);

    if isempty(bw), bw = bhop; end

    %olap = bw >= bhop;
    olap = true;

    bcen = low + ((1:nb) * bhop);

    infrhz = x2f(bcen-bw);
    suprhz = x2f(bcen+bw);
    bcenhz = x2f(bcen);

    if olap
        infrhz(1) = F(1);
        suprhz(end) = F(end);
    end

    n = length(F);
    fbank=zeros(nb,n);

    wfun = @(x) x;

    switch wType
        case 'cos'
            wfun = @(x) (0.5*(1-cos(pi*x)));
        case 'pow'
            wfun = @(x) (sqrt(x));
        otherwise
    end

    m = 1/max(eps,trans);

    for b=1:nb 
        xw = [infrhz(b),bcenhz(b),suprhz(b)];
        yw = [olap && b==1, 1, olap && b==nb];
        il=findx(F, infrhz(b));
        ih=findx(F, suprhz(b));
        fintv = F(il:ih);

        if (ih-il > 1)
            fbank(b,il:ih) = interp1(xw,yw,fintv,'linear',0);
        else
            fbank(b,il:ih) = 1;
        end

        if trans ~= 1
            fbank(b,il:ih) = max(0,min(1, (fbank(b,il:ih)-0.5) * m + 0.5 ));
        end

        fbank(b,il:ih) = wfun(fbank(b,il:ih));
    end

%     plot(F, fbank)
%     plot(1:nb, sum(fbank,2));
%     ylim([0,2]);

end

%% -------------------------------------

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

function indx = findx(X, val)
    X = abs(X-val); 
    [~, indx] = min(X); 
end

% ------------------------------------------------------------------------
%
% getfilterbank.m: returns a filterbank with given properties
% Copyright (C) 2022 - Giorgio Presti - Laboratorio di Informatica Musicale
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