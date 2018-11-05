function [ X, F, T, x ] = getFD( x, Fs, hop, w )
%GETFD Given a signal in time domain returns the frequency domain
%
%[ X, F, T ] = GETFD( x )
%[ X, F, T ] = GETFD( x, Fs )
%
%   returns FFT(x(:)) with all the postprocessing involved
%   if not specified Fs = 1;
%
%[ X, F, T, x ] = GETFD( x, Fs, hop, w )
%
%   returns the STFT of x with all the postprocessing involved. Output x is
%   the buffered version of X.
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also GETTD, GETFREQCONVERTERS, RESCALEFREQ, GETFBANK, BUFFER

    if nargin < 2, Fs = 1; end

    if nargin < 3
        x = x(:);
        wsize = size(x,1);
        F = linspace(0,Fs/2,1+wsize/2)';
        T = 0;
        X = fft(x);
        X = X(1:floor(end/2)+1,:);
        X = X/wsize;
        X(2:end-1,:) = X(2:end-1,:) * 2; 
    else
        wsize = max(size(w));
        olap = wsize-hop;
        x = buffer(x,wsize,olap);
        x = bsxfun(@times,x,w);
        [X, F, T] = getSTFT(x,olap,Fs);    
    end

end

function [STFT, F, T] = getSTFT(buffered,overlap,Fs)
%[STFT, F, T] = getSTFT(buffered, overlap, Fs)
%   returns the FFT of a set of frames, with time and frequency axes
%   if BUFFER is called without initial delay or if getSTFT is replaced
%   with SPECTROGRAM, OVERLAP function in stdlim will not work properly

    windowSize = size(buffered,1);
    nFrames = size(buffered,2);
    frameHop = windowSize-overlap;
    lastFrameIndex = (nFrames * frameHop) - windowSize;

    T = (-overlap : frameHop : lastFrameIndex) / Fs;
    F = linspace(0,Fs/2,1+windowSize/2)';
    
    STFT = fft(buffered);
    STFT = STFT(1:end/2+1,:);
    STFT = STFT/windowSize;
    STFT(2:end-1,:) = STFT(2:end-1,:) * 2; 
        
end

% ------------------------------------------------------------------------
%
% getFD.m: Given a signal in time domain returns the frequency domain
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