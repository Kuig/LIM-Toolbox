function [ C ] = CCorr( X1, X2 )
%[ C ] = CCorr( X1, X2 )
%   Gets Bivariate Mixture Space correlation C

    if any (size(X1) ~= size(X2)),
        error('X1 and X2 must be of same size');
    end;

    if ~ismatrix(X1),
        error('X1 and X2 must be vectors or matrixes');
    end;

    C = cos(angle(X1)-angle(X2));

end

