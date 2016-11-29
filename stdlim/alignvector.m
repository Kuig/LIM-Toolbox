function [ A, lag ] = alignvector( A, B, maxlag )
%[ A, lag ] = alignvector( A, B, maxlag )
%   shifts array A to maximize cross correlation with B
%   maxlag sets the maximum offset

    z = A/rms(A);
    B = B/rms(B);
    
    [r,l] = xcorr(B,z,maxlag);
    [~,n] = max(r);
    lag = l(n);

    A = circshift(A,lag);

end