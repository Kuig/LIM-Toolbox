function [ A ] = db2amp( dB )
%[ A ] = db2amp( dB )
%   Convert dBfs values dB to amplitude A
%   A = 10.^(dB/20);

    A = 10.^(dB/20);

end