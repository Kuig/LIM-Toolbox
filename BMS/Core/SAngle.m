function [ s ] = SAngle( X1, X2 )
%[ s ] = SAngle( X1, X2 )
%   Get the angle s of the Bivariate Spectrum

    if any (size(X1) ~= size(X2)),
        error('X1 and X2 must be of same size');
    end;

    if ~ismatrix(X1),
        error('X1 and X2 must be vectors or matrixes');
    end;

    s = 0.5 .* atan2 ( 2.*(imag(X1).*imag(X2) + real(X1).*real(X2)), abs(X1).^2-abs(X2).^2 );

end

