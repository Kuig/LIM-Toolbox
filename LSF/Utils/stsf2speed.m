function [ SF ] = stsf2speed( P, R, speedLim, F )
%[ SF ] = STSF2speed( P, R, speedLim, F )
%   P is the Spectro Temporal Structure Field
%   R is frequency and time resolution [fRes,tRes] expressed in Hz and sec
%   speedLim is the maximum absolute speed, use [] to set none
%   F is the frequency axis: if provided, output is in semitones per second

    if nargin < 3, speedLim = []; end;

    fRes = R(1);
    tRes = R(2);
    
    if nargin < 4
        hzSec = fRes/tRes;
        SF = (imag(P)./real(P))*hzSec;
    else
        nRes = 12.*log2((F+fRes)./F);
        nnMSec = nRes./tRes;
        SF = bsxfun(@times,(imag(P)./real(P)),nnMSec);
    end;

    if ~isempty(speedLim)
        SF(isnan(SF))=inf;
        SF = max(SF,-speedLim);
        SF = min(SF,speedLim);
    end;

    
end

