function [ V ] = LSF( IMG, A, w )
%[ V ] = LSF( IMG, A, w )
%   Linear Structure Field of IMG sampled along a list of angles A with
%   weights kernel w (uses canonical method)
%[ V ] = LSF( IMG, 'NLVConv', h )
%   Linear Structure Field of IMG using Non-Linear Vector Convolution
%   method: h is the complex kernel to use.

    if ischar(A)
        V = NLVConv(IMG,w);
    else
        S = size(IMG);
        N = numel(IMG);
        V = complex(zeros(S));
        for n = 1:N
            r = mod(n-1, S(1)) + 1;
            c = (n - r)/S(1) + 1;
            D = SEAD( IMG, [c,r], A, w, 0 );
            V(r,c) = NLVMean(D,A);
        end;
    end
    
end
