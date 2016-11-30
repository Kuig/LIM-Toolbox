function [M,S] = KraftAmbience(L,R,c,phasehandling)
%[M,S] = KraftAmbience(L,R,c,phasehandling);
%   Separate ambience from direct signal
%   L, R = STFT of input channels
%   c = correlation clarity exponent (def. 1)
%   phasehandling = if set to 0 output STFT inherits phase from input mix
%   M,S = STFT of direct signal and ambience respectively
%
%   for c = 0 and phasehandling = 0 implements Kraft 2015
%   Based on "Stereo signal separation and upmixing by mid-side 
%   decomposition in the frequency-domain" by Kraft Sebastian, and Udo
%   Zölzer (2015)

    if nargin < 4, phasehandling = 1; end;
    if nargin < 3, c = 1; end;

    [M, S] = PSC(L,R);
    if c > 0
        clarity = abs(CCorr(L,R)).^c;
    else
        clarity = 1;
    end;
    M = M .* clarity;
    S = S + M .* ( 1 - clarity );
    
    if phasehandling == 0
        phase = angle(L+R);
        M = ( abs(M).*exp(1i*phase) );
        phase = angle(L-R);
        S = ( abs(S).*exp(1i*phase) );
    end;
    
end