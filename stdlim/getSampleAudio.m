function [ out ] = getSampleAudio( dur, Fs )
%[ out ] = getSampleAudio( dur, Fs )
%   Generates random stereo audio
%   dur is duration in seconds
%   Fs is the sample frequency
%
%   (this function will change in the future)

    % Setup
    len = dur * Fs;
    T = linspace(0,dur,len);
    baseNote = 50 + round(rand+40);
    
    % Percussion
    div = 3; reg = 0.6; dcy = 250; ord = 5;
    perc = percussions(T, div, reg/2, dcy, ord);
    perc = perc + percussions(T, div, reg/2, dcy*4, ord);
    perc = perc/rms(perc);
    
    % Bells
    div = 5; reg = 0.05; dcy = 0.1 * Fs;
    scale = [0, 7, 12, 16]+baseNote;
    bell = zeros(len,1);
    for b = 1:length(scale)
        freq = logf2linf(scale(b));
        bell = bell + bells(T, div, reg, dcy, freq);
    end
    bell = bell/rms(bell);

    % Pads
    scale = [0, -5, 4, 7, 12]+baseNote-24;
    dcy = 2.5 * Fs;
    timing = 1+round(rand(length(scale))*(len-dcy-1));
    pads = zeros(len,1);
    for b = 1:length(scale)
        freq = logf2linf(scale(b));
        env = zeros(len,1);
        env(timing(b):timing(b)+dcy-1) = hann(dcy);
        pads = pads + env .* sin(2*pi*freq*T).';
    end
    pads = pads/rms(pads);
    
    % Noise
    noise = randn(len,2) * db2amp(-56);
    
    % Mix
    out = 0.8 * panpot(perc, getPan) +...
          0.5 * panpot(bell, getPan) +...
          1.0 * panpot(pads, getPan) +...
          0.9 * noise;
    out = out/max(abs(out(:)));
    
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
    end;
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
    p = (randn * pi/6);
end