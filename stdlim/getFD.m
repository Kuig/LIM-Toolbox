function [ X,F,T,x ] = getFD( x, Fs, hop, w )
%[ X, F, T ] = getFD( x, Fs )
%   returns FFT(x(:)) with all the postprocessing involved
%[ X, F, T, x ] = getFD( x, Fs, hop, w )
%   returns the STFT of x with all the postprocessing involved. Output x is
%   the buffered version of X.

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
    lastFrameIndex = (nFrames * frameHop) - overlap - 1;

    T = ((-overlap : frameHop : lastFrameIndex) + 1) / Fs;
    F = linspace(0,Fs/2,1+windowSize/2)';
    
    STFT = fft(buffered);
    STFT = STFT(1:end/2+1,:);
    STFT = STFT/windowSize;
    STFT(2:end-1,:) = STFT(2:end-1,:) * 2; 
        
end