function [ V ] = NLVMean( T,r )
%[ V ] = NLVMean( T,r )
%   Mean of vectors using Non-Linear Vector Summation
%   Averages all elements of array resulting from T.*exp(i*r) using
%   Non-Linear Vector Summation
    
    Sr = numel(r);
    V = sum( T .* exp(2i .* r) )/Sr;
    V = abs(V) .* exp(1i .* angle(V) / 2);

end

