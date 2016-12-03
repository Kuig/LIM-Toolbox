function [ D ] = SEAD( F, P, A, w, cOut )
%[ D ] = SEAD( F, P, A, w, cOut )
%   Returns Signal Energy Angular Distribution of image F around point P
%   Output have the same size of A
%   F = Input image
%   P = Point coordinates in the form [x, y] (i.e. [row, col])
%   A = List of angles to sample
%   w = Kernel function in form of a vector of weights
%   cOut = if 1, returns a complex number, if false just returns SEAD
%          real magnitude for each sampling angle in A (def. 1)

    A = A(:);
    w = w(:);
    
    if nargin < 5, cOut = 1; end;
    
    l = size(A,1);
    r = size(w,1);

    Fc = mcrop(F,P(2),P(1),r);
    
    if cOut == 1
        D = complex(zeros(l,1));
        if any(Fc(:))
            for ii = 1:l
                L = getLine(Fc,A(ii),0);
                L = fwkeep(L,r);
                D(ii) = sum( L .* w .* exp(1i * A(ii)) );
            end;
        end;
    else
        D = zeros(l,1);
        if any(Fc(:))
            for ii = 1:l
                L = getLine(Fc,A(ii),0);
                L = fwkeep(L,r);
                D(ii) = sum( L .* w );
            end;
        end;
    end;
        
end

