function [ X ] = getTD( X, hop, len, w )
%GETTD given a FT, returns a time domain signal
%
%[ X ] = GETTD( X )
%
%   Returns time domain representation of complex FFT vector X
%
%[ X ] = GETTD( X, hop, len, w )
%
%   Returns time domain representation of ST-FFT X
%   Multipies each frame by window w and overlaps frames into a single
%   vector of length len
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also GETFD, GETFREQCONVERTERS, RESCALEFREQ, GETFBANK, OVERLAP

    if (nargin == 1) && (size(X,2)~=1), error('Use n-by-1 input or proper hop/len/w arguments'); end

    X = invSTFT(X);

    if nargin ~= 1
        if length(w)~=size(X,1), error('Window size different from frame size'); end
        
        X = bsxfun(@times,X,w);

    %   if BUFFER is called without initial delay or if getSTFT is replaced
    %   with SPECTROGRAM, OVERLAP function in stdlim will not work properly

        X = overlap(X,hop,len,w.^2); % w.^2 -> frame masked twice
    end
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

% ------------------------------------------------------------------------
%
% getTD.m: given a FT returns a time domain signal
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