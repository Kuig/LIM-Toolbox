function [ C, D ] = msmatrix( A, B )
%[ C ] = msmatrix( A )
%   Mid-Side encoder and decoder of a 2 columns matrix A
%
%[ C, D ] = msmatrix( A, B )
%   Mid-Side encoder and decoder of 2 matrixes A and B
    
    sqrt2 = sqrt(2);
    if nargin < 2
        if size(A,2) ~= 2, error('Input matrix must have 2 columns'); end;
        C(:,1) = sum(A,2)/sqrt2;
        C(:,2) = diff(A,[],2)/sqrt2;
    else
        C = (A+B)/sqrt2;
        D = (A-B)/sqrt2;
    end
end