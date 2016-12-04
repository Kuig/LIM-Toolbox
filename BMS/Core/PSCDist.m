function [D, Df, Dt, alpha ] = PSCDist (X, s, C, res)
%[D, Df, Dt, alpha ] = PSCDist (X, s, C, res)
%   Get Principal Spectral Content weighted distribution in the BMS
%   X, s, C = The Bivariate Spectrum
%   res = resoltion (def. 201)
%   D(:,1) = overall angles distribution (|X| weight)
%   D(:,2) = overall angles distribution (|X|*(1-|C|) weight)
%   D(:,3) = overall angles distribution (|X|*|C| weight)
%   Df = Distribution over frequency and angle
%   Dt = Distribution over time and angle
%   alpha = angle axes (def. 101)

    if nargin < 4, res = 101; end;
    
    aM = abs(X);
    aC = abs(C);
    W1 = aM.*aC;
    
    [ ~ , Dt, ~     ] = PSCDistAtom( s, W1, 1, res);
    [ Dh, Df, alpha ] = PSCDistAtom( s, W1, 2, res);
    [ Dl, ~ , ~     ] = PSCDistAtom( s, aM.*(1-aC),1,res);
    
    Dl = Dl(:); Dh = Dh(:);
    D = [Dl + Dh, Dl, Dh];

end



