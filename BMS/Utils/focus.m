function [ M ] = focus( L, R, p, H, c )
%[ M ] = focus( L, R, p, H, c )
%   Resample and mask around p
%   (use plotDMask() as a tool to choose p, H and c)
%   L, R = STFT of input channels
%   p = stereophonic position to sample
%   H = upper and lower range (uses [H,H] if scalar, ignored if p=[])
%   c = correlation selection coefficient (clarity)
%       c=0: ignore; c>0 = select correlated; c<0: select uncorrelated
%   M = extracted source STFT
%
% This function cannot be considered an effective source separation tool,
% it is just a demonstration of BMS applications

    if nargin < 5, c = 0; end;
    if isscalar(H), H = [H,H]; end;
    
    s = SAngle(L,R);
    
    mask = getSMask( s, p, H );
    
    if c ~= 0
        C = abs(CCorr(L,R)).^abs(c);
        M = BMS(L,R,p);
        if c > 0
            M = M .*    mask   + ...
                M .* (1-mask) .* (1-C);
        else
            M = M .* mask .* C;
        end;
    else
        M = BMS(L,R,p).*mask;
    end;
    
end

