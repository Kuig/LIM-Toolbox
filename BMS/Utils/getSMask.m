function [ mask ] = getSMask( s, p, H )
%[ M ] = getSMask( s, p, H )
%   Binary mask of points around p
%   (use plotDMask() as a tool to choose p & H)
%   s = Bivariate Spectrum angles
%   p = stereophonic position to sample
%   H = upper and lower range (uses [H,H] if scalar, ignored if p=[])

    if isscalar(H), H = [H,H]; end
    
    p   = mod((p)+pi/2,pi)-pi/2;
    low = mod((p-H(1))+pi/2,pi)-pi/2;
    hig = mod((p+H(2))+pi/2,pi)-pi/2;

    if low > hig
        mask = (s > low) | (s < hig);
    else
        mask = (s > low) & (s < hig);
    end
    
end

