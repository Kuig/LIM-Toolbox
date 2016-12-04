function [ h ] = plotLSF( P, IMG, scale )
%[ h ] = plotLSF( P, IMG, scale )
%   Plots colour-coded Linear Structure Filed P of image IMG
%   scale = saturation range [min, max], default is range of abs(P(:))

    S = abs(P);
    if nargin < 3
        scale(1) = min( S(:) );
        scale(2) = range( S(:) );
    end;

    H = mod((angle(P)+pi/2)/pi,1);
    S = S-scale(1);
    S = S/scale(2);
    S = min(S,1);
    S = max(S,0);
    V = IMG;
    PIC = cat(3, H,S,V);
    PIC = hsv2rgb(PIC);

    h = image(PIC);
    title('Linear Structure Field');
    axis xy
    
%     cleg = hsv2rgb([(((linspace(-pi/2,pi/2,64)+pi/2)/pi))', ones(64,2)]);
%     colormap(cleg), hcb=colorbar;
%     set(hcb,'YTick',linspace(0,1,9));
%     set(hcb,'YTickLabel',{'-\pi/2','','-\pi/4','','0','','\pi/4','','\pi/2'});

end

