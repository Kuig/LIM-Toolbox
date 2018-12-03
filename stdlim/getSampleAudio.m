function [ out, sources, pans ] = getSampleAudio( dur, Fs, ch, src )
%GETSAMPLEAUDIO Generates random audio (percussion and pitched sounds)
%
%[ out ] = GETSAMPLEAUDIO( dur )
%[ out ] = GETSAMPLEAUDIO( dur, Fs )
%[ out ] = GETSAMPLEAUDIO( dur, Fs, ch )
%[ out ] = GETSAMPLEAUDIO( dur, Fs, ch, src )
%[ out, sources, pans ] = GETSAMPLEAUDIO( ... )
%
%   Generates random audio (with percussion and pitched sounds)
%
%   dur: duration in seconds
%   Fs:  sample frequency (default: 44100);
%   ch:  number of output channels (1 or 2, default: 2)
%   src: cell array containing one or more track names (default: all)
%        src = { 'perc', 'bell', 'pads', 'noise' }
%
%
%   out:     mixed audio
%   sources: original sources in a n-by-4 or n-by-5 matrix. n is the length
%            in samples. columns are respectively: percussions, bells,
%            pads, and single or dual channel noise (based on ch).
%            Tracks not present in src only contains silence.
%   pans:    pan angles for percussions, bells, and pads (even if not
%            present in src!)   
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also GETSAMPLEFILTER

    if nargin < 2, Fs = 44100; end
    if nargin < 3, ch = 2; end
    if nargin < 4, src = { 'perc', 'bell', 'pads', 'noise' }; end

    % Setup
    len = ceil(dur * Fs);
    T = linspace(0,dur,len);
    baseNote = 50 + round(rand+40);
    
    % Percussion
    perc = zeros(len,1);
    if any(ismember('perc',src))
        div = 3; reg = 0.6; dcy = 250; ord = 5;
        perc = percussions(T, div, reg/2, dcy, ord);
        perc = perc + percussions(T, div, reg/2, dcy*4, ord);
        perc = 0.8 * perc/rms(perc);
    end
    
    % Bells
    bell = zeros(len,1);
    if any(ismember('bell',src))
        div = 5; reg = 0.05; dcy = 0.1 * Fs;
        scale = [0, 7, 12, 16]+baseNote;
        bell = zeros(len,1);
        for b = 1:length(scale)
            freq = st2hz(scale(b));
            bell = bell + bells(T, div, reg, dcy, freq);
        end
        bell = 0.5 * bell/rms(bell);
    end
        
    % Pads
    pads = zeros(len,1);
    if any(ismember('pads',src))
        scale = [0, -5, 4, 7, 12]+baseNote-24;
        dcy = ceil(2.5 * Fs);
        dcy = min(dcy,len-1);
        timing = 1+round(rand(length(scale))*(len-dcy-1));
        pads = zeros(len,1);
        for b = 1:length(scale)
            freq = st2hz(scale(b));
            env = zeros(len,1);
            env(timing(b):timing(b)+dcy-1) = hann(dcy);
            pads = pads + env .* sin(2*pi*freq*T).';
        end
        pads = 1.0 * pads/rms(pads);
    end
    
    % Noise
    noise = zeros(len,1);
    if any(ismember('noise',src))
        noise = 0.9 * randn(len,ch) * db2amp(-56);
    end
    
    pans = [getPan, getPan, getPan];
    
    % Mix
    if ch == 2
        out = panpot(perc, pans(1)) +...
              panpot(bell, pans(2)) +...
              panpot(pads, pans(3)) +...
              noise;
    else
        out = perc + bell + pads + noise;
    end
    
    peak = max(abs(out(:)));
    out = out/peak;
    
    if nargout > 1, sources = [perc, bell, pads, noise]/peak; end
    
end

function y = percussions(T, divisions, regularity, decay, forder)
    accents = getAccentP(T, divisions);
    sequence = getSequence(accents, regularity);
    env = relfilt(sequence,decay);
    y = (rand(length(T),1)-0.5) .* env;
    [b,a] = getSampleFilter(forder);
    y = filter(b,a,y);
end

function y = bells(T, divisions, regularity, decay, freq)
    accents = getAccentP(T, divisions);
    accents(T>T(end)-0.5) = 0;
    sequence = getSequence(accents, regularity);
    env = relfilt(sequence,decay);
    y = sin(2*pi*freq*T).' .* env;
    [b,a] = getSampleFilter(4);
    y = filter(b,a,y);

end

function P = getAccentP(T, td)
    T = T*100000;
    P = zeros(length(T),1);
    for d = 2.^-(0:td)
        m = mod(T,d*100000) < 5;
        P(m) = P(m)+1;
    end
    P = P / (td+1);
end

function S = getSequence(A, p)
    S = A.^(0.5) .* (rand(length(A),1) < (A.^2) * p);
end

function y = relfilt(x, rel)
    a = [1, -1/exp(1/rel)];
    y = filter(1,a,x);
end

function p = getPan()
    p = (randn * pi/6) + pi/4;
end

% ------------------------------------------------------------------------
%
% getSampleAudio.m: Generates random audio (percussion and pitched sounds)
% Copyright (C) 2014 - Giorgio Presti - Laboratorio di Informatica Musicale
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>
%
% ------------------------------------------------------------------------