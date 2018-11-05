function [ Y, N ] = rescalefreq( X, F, fscale, imode, reso )
%RESCALEFREQ transform frequency axis to a given scale 
%
%[ Y, N ] = RESCALEFREQ( X, F, fscale, imode, param )
%
%   X:      m-by-p matrix of the spectrum
%   F:      frequency column array of lenght m
%   fscale: 'mel', 'bark', 'erbs', 'semitone', 'hz', 'log' (default: 'mel')
%   imode:  'filterbank' or 'interpolation' scaling method (default: 'filterbank')
%   reso:   number of output lines (default: numel(F))
%
%   Y: new spectrum matrix
%   N: new frequency axis expressed in fscale
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also GETTD, GETFD, GETFBANK, GETFREQCONVERTERS, RESCALEAMP, INTERP1

    if nargin < 3, fscale = 'mel'; end
    if nargin < 4, imode = 'fb'; end
    if nargin < 5, reso = numel(F); end
    
    switch lower(imode)
        case {'filterbank','fbank','fb'}
            [fb, N] = getfbank(F,'auto',fscale,@triang,reso);
            if ismatrix(X)
                Y = fb * X;
            else
                Y = zeros(numel(N),size(X,2),size(X,3));
                for p = 1:size(X,3)
                    Y(:,:,p) = fb * X(:,:,p);
                end
            end
        case {'interpolation','interp','int'}
            [f2x, ~, first_el] = getFreqConverters(fscale, F);
            F = F(first_el:end);
            X = X(first_el:end,:,:);
            Nf = f2x(F);
            Nmin = min(Nf(isfinite(Nf)));
            Nmax = max(Nf(isfinite(Nf)));
            N = linspace(Nmin,Nmax,reso).';
            Y = interp1(Nf,X,N,'pchip');
        otherwise
            error('Unknown rescaling method');
    end

end

% ------------------------------------------------------------------------
%
% rescalefreq.m: Transform frequency axis to a given scale 
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
