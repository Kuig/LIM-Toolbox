function [ F ] = logf2linf( N, Fref, Nref, EDO )
%[ F ] = logf2linf( N )
%[ F ] = logf2linf( N, Fref )
%[ F ] = logf2linf( N, Fref, Nref )
%[ F ] = logf2linf( N, Fref, Nref, EDO )
%   Convert note number N to frequency values F based on:
%   Fref - reference frequency (default: 440)
%   Nref - N value corresponding to Fref (default: 69)
%   EDO - Equal division of the octave (default: 12)

    if nargin < 4, EDO = 12; end
    if nargin < 3, Nref = 69; end
    if nargin < 2, Fref = 440; end

    F = ( 2.^( (N-Nref)./EDO ) ) * Fref;

end