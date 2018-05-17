function output = overlap (frames, frameHop, len, window)
% output = overlap (frames, frameHop, len, window)
%   DEPRECATED
%   This is probably the most bugged piece of software you will find in
%   this repository

% trasforma una matrice di frames in un vettore lineare
% ogni colonna è sfalsata di hop elementi (default = framesize/2)
% len indica la lunghezza finale dell'output (facoltativo)
% window è un vettore lungo quanto un frame facoltativo)
    
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

    ws = numel(window);
    output(1+end-ws:end) = output(1+end-ws:end) .* linspace(1,0,ws).';

end