function [ IMG ] = stft2img( STFT, dbLow, dbHigh )
%[ IMG ] = stft2img( STFT )
%[ IMG ] = stft2img( STFT, dbLow )
%[ IMG ] = stft2img( STFT, dbLow, dbHigh )
%	Takes the STFT output of a spectrogram function and returns a matrix of
%	the same size in the range 0-1, where 0 is the lowest level and 1 is
%	the highest. Levels have a logarithmic scale.
%   dbLow sets the level corresponding to 0, dbHigh sets the level 1.
%   Both are expressed in dBfs.

    if nargin < 2
        [IMG,dbLow] = amp2db(abs(STFT));
    else
        IMG = amp2db(abs(STFT),dbLow);
    end
    IMG = IMG-dbLow;
    if nargin < 3, dbHigh = max(IMG(:)); end
    IMG = IMG / dbHigh;

end

