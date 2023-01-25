function [ SEL, REJ ] = pitchPercFilter( STFT, STSF, thres, g, type, rel )
%[ SEL, REJ ] = pitchPercFilter( STFT, STSF, thres, g, type, rel )
%   Segregates pitched signal from percussive signal
%   STFT = input STFT
%   STSF = Spectro Temporal Structure Field of input STFT
%   thres = angle threshold
%   g = mask exponent
%   type = if 'pitch' angles below thres are selected
%          if 'perc' angles above thres are selected
%   rel = IIR filter coefficient for mask release ( 0 <= r < 1 )
%   SEL = Output STFT
%   REJ = Rejected STFT components
%
% This function cannot be considered an effective source separation tool,
% it is just a demonstration of STSF applications

if nargin < 6, rel = 0; end;

if strcmp(type,'')
    SEL = STFT;
    REJ = [];
else
    switch type
        case {'pitched','pitch'}
            mask = (abs(angle(STSF)) < thres) .* (abs(STSF)/max(abs(STSF(:)))).^g;
        case {'percussive','perc'}
            mask = (abs(angle(STSF)) > thres) .* (abs(STSF)/max(abs(STSF(:)))).^g;
        otherwise
            error('Enter a valid source type');
    end;

    ff = size(mask,1);
    for f = 1:ff
        mask(f,:) = filter(1,[1,-rel],mask(f,:),0,2);
    end;
    
    SEL = STFT .* mask;

    if nargout > 1
        REJ = STFT .* (1-mask);
    end;
end;
    
end

