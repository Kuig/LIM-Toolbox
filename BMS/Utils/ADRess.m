function [ S ] = ADRess( L, R, p, H )
%[ S ] = ADRess( L, R, p, H )
%   ADRess algorithm implemented as BMS masking
%   L, R = STFT of input channels
%   p = stereophonic position to sample
%   H = position tolerance
%   S = extracted source STFT
%   Based on "Sound source separation: Azimuth discriminiation and
%   resynthesis" by Barry, Dan, Bob Lawlor, and Eugene Coyle (2004)

    [M, s, ~] = BS(L,R);
    
    mask = getSMask( s, p, H );

    if (p > -pi/4) && (p < pi/4)
        phase = angle(L);
    else
        phase = angle(R);
    end;
    
    S = ( abs(M).*exp(1i*phase) );
    S = S .* mask;
    
end

