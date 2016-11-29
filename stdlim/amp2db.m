function [ dB, fBound ] = amp2db( A, fBound )
%[ Y ] = amp2db( X )
%[ Y ] = amp2db( X, f )
%[ Y, f ] = amp2db( __ )
%   Convert amplitude values A to dBfs
%   f is the floor bound expressed in dB, default f is the lowest 
%   non-infinite value present after conversion.
%   calling Y = amp2db(X,-inf); is the same as Y = 20 * log10(X);
 
    if any(A<0), warning('Negative elements in amp matrix'); end;
    dB = 20 * log10(A);
    if nargin < 2
        fBound = dB(isfinite(dB(:)));
        fBound = min(fBound(:));
    end;    
    if ~isempty(fBound), dB = max(dB,fBound); end;
    
end
