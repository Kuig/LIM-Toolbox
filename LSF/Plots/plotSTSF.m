function [ h ] = plotSTSF( stsf, stft, F, T, scale, logFreq, dbFloor )
%[ h ] = plotSTSF( stsf, stft, F, T, scale, logFreq, dbFloor )
%   Plots colour-coded Spectro Temporal Structure Filed stsf of stft
%   F,T = Frequency and Time axes
%   scale = saturation range [min, max], default is range of abs(P(:))
%           to set default scale, [] can be used
%   logFreq = if 1 uses log frequency axis (def. 1)
%   dbFloor = lowest amplitude to display (in dBfs) (def. -96)

    S = abs(stsf);
    if (nargin < 5) || isempty(scale)
        scale(1) = min( S(:) );
        scale(2) = range( S(:) );
    end;
    
    if nargin < 6, logFreq = 1; end;
    if nargin < 7, dbFloor = -96; end;
    
    H = mod((angle(stsf)+pi/2)/pi,1);
    S = S-scale(1);
    S = S/scale(2);
    S = min(S,1);
    S = max(S,0);
    V = stft2img(stft,dbFloor);
    PIC = cat(3, H,S,V);
    PIC = hsv2rgb(PIC);

	if logFreq == 1,
        [PIC,F] = linspec2log(PIC(2:end,:,:),F(2:end));
        PIC = max(PIC,0);
	end
    
    h = image(T,F,PIC);
    title('Spectro-Temporal Structure Field');
    axis xy
    
end

