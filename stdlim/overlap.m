function [ output ] = overlap ( frames, frameHop, len, window )
%OVERLAP overlaps columns of a matrix into a single column vector
%
%[ output ] = OVERLAP ( frames )
%[ output ] = OVERLAP ( frames, frameHop )
%[ output ] = OVERLAP ( frames, frameHop, len )
%[ output ] = OVERLAP ( frames, frameHop, len, window )
%
%   Overlaps columns of a matrix into a column vector
%   frames:   matrix to be processed
%   frameHop: hop size of each frame (default: framesize/2)
%   len:      final output length (enforced by truncation)
%   window:   windowing function applied to each frame (if any)
%
%   OVERLAP is thught to be used on the output of BUFFER function,
%   nevertheless, if BUFFER is called without initial delay or if getSTFT
%   is replaced with SPECTROGRAM, OVERLAP function will not work properly
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also BUFFER, GETTD, GETFD

    framesize = size(frames,1);
    nFrames   = size(frames,2);
    if nargin < 2, frameHop = framesize/2; end
    overlap = framesize - frameHop;
    finalLen = nFrames * frameHop + overlap + 1;
    if nargin < 3, len = finalLen-frameHop; end
    if nargin < 4
        window = ones(framesize,1); 
    end
    
    lastFrameIndex = (nFrames * frameHop) - overlap - 1;
    FrameIndex = (-overlap : frameHop : lastFrameIndex) + 1;
    offset = overlap;

    output = zeros(finalLen,1);
    AM = zeros(finalLen,1);

    for f = 1:nFrames
        a = offset + FrameIndex(f);
        b = offset + FrameIndex(f)+framesize-1;
        output(a:b) = output(a:b) + frames(:,f);
        AM(a:b) = AM(a:b) + window;
    end
    AM(AM==0) = 1;
    output = output./AM;
    output  = output (offset+1:offset+len);

    % Small fadeout to avoid exploding values when demodulating
    ws = ceil(numel(window)/4);
    output(1+end-ws:end) = output(1+end-ws:end) .* (linspace(1,0,ws).').^0.5;

end

% ------------------------------------------------------------------------
%
% overlap.m: overlaps columns of a matrix into a column vector
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