function IMG = plotBS( M, s, C, F, T, dbFloor, clarityExponent, logFreq, gamma)
%plotBS( M, s, C, F, T )
%plotBS( M, s, C, F, T, dbFloor, clarityExponent, logFreq, gamma)
%IMG = plotBS( ___ )
%   Use this function to plot the BS-Enhanced spectrogram or simply get the
%   corresponding RGB image IMG.
%   M = Principal Spectral Content
%   s = BMS Angles
%   C = BMS Correlation
%   F & T = Frequency and time axes
%   dbFloor = lowest amplitude to display (in dBfs) (def. -96)
%   clarityExponent = Exponent of C for saturation correction (def. 1)
%   logFreq = if 1 uses log frequency axis (def. 1)
%   gamma = render gamma. If > 1 darkens image, if < 1 brightens (def. 1)

        if nargin < 6, dbFloor = -96; end;
        if nargin < 7, clarityExponent = 1; end;
        if nargin < 8, logFreq = 1; end;
        if nargin < 9, gamma = 1; end;
        
        H = mod((s+pi/2)/pi-0.25,1);
        S = abs(C).^clarityExponent;
        V = stft2img( M, dbFloor );
        IMG = cat(3, H,S,V);
        IMG = hsv2rgb(IMG);
        
        if logFreq
            [IMG,F] = linspec2log(IMG(2:end,:,:),F(2:end));
            IMG = max(IMG,0);
        end;

        if nargout < 1;
            image(T,F,IMG.^gamma);
            axis xy;
        end;

end

