function [ X ] = getTD( X, hop, len, w )
%[ X ] = getTD( X, hop, len, w )
%   Returns time domain representation of ST-FFT X
%   Multipies each frame by window w and overlaps frames into a single
%   vector of length len

    X = invSTFT(X);
    X = bsxfun(@times,X,w);

%   if BUFFER is called without initial delay or if getSTFT is replaced
%   with SPECTROGRAM, OVERLAP function in stdlim will not work properly

    X = overlap(X,hop,len,w.^2); % Why is this squared?

end

function [ buffered ] = invSTFT( STFT )
%[ buffered ] = invSTFT( STFT )
%   inverse STFT with padding

    windowsize = 2*(size(STFT,1)-1);
    pad = windowsize - size(STFT,1);
    
    STFT(2:end-1,:) = STFT(2:end-1,:) / 2; 
    STFT = STFT * windowsize;
    STFT = padarray(STFT,[pad,0],'post');
    buffered = ifft(STFT,'symmetric');
    
end