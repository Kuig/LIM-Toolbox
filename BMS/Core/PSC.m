function [ X, Y ] = PSC( X1, X2 )
%[ X ] = PSC( X1, X2 )
%   Get the Principal Spectral Content X of the Bivariate Mixture Space
%[ X, Y ] = PSC( X1, X2 )
%   Get the Principal Spectral Content X of the Bivariate Mixture Space
%   together with its orthogonal components Y

    X = BMS(X1,X2,SAngle(X1,X2));

    if nargout > 1
        Y = BMS(X1,X2,SAngle(X1,X2)-(pi/2));
    end;

end

