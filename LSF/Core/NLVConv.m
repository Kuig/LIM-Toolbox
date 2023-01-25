function [ C ] = NLVConv( A, B )
%[ C ] = NLVConv( A, B )
%   Non-Linear Vector Convolution
%   Convolve A*B using Non-Linear Vector Summation
%   Output have the same size of the largest input

    if numel(B) > numel(A),
        T = B; B = A; A = T;
        clear T
    end;

    ims = size(A);
    n   = numel(A);
    s   = size(B);
    s2 = floor(s/2);

    C = zeros(ims+s);
    for idx = 1:n
        r = mod(idx-1, ims(1)) + 1;
        c = (idx - r)/ims(1) + 1;

        r1 = r;
        r2 = r1 + s(1) - 1;
        c1 = c;
        c2 = c1 + s(2) - 1;

        rs = r1:r2;
        cs = c1:c2;

        C(rs,cs) = NLVS(C(rs,cs), B.*A(r,c));
    end;

    C = C(s2(1)+1:end-s2(1)-1,s2(2)+1:end-s2(2)-1);

end

