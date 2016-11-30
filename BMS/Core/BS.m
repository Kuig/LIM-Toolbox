function [ X, s, C ] = BS( X1, X2 )
%[ X, s, C ] = BS( X1, X2 )
%   Gets the Bivariate Spectrum as the Principal Spectral Content X, the
%   angles s and correlation C

    s = SAngle(X1,X2);
    X = BMS(X1,X2,s);
    C = CCorr(X1,X2);
    
end

