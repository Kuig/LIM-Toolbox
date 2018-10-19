function [ N ] = linf2logf( F, Fref, Nref, EDO )
%[ N ] = linf2logf( F )
%[ N ] = linf2logf( F, Fref )
%[ N ] = linf2logf( F, Fref, Nref )
%[ N ] = linf2logf( F, Fref, Nref, EDO )
%   Convert frequency values F to note number N based on:
%   Fref - reference frequency (default: 440)
%   Nref - N value corresponding to Fref (default: 69)
%   EDO - Equal division of the octave (default: 12)
%
%   Note that [ N ] = linf2logf( F, Fref, 0 ); returns the difference in
%   semitones between F and Fref.

    if nargin < 4, EDO = 12; end
    if nargin < 3, Nref = 69; end
    if nargin < 2, Fref = 440; end

    if any(F<0), warning ('Found F < 0 during log.freq. conversion!'); end

    N = EDO * log2(F./Fref) + Nref;

end