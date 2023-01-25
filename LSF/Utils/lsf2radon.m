function [ R, rh ] = lsf2radon( IMG, IMGlsf, A )
%[ R, rh ] = lsf2radon( IMG, IMGlsf, A )
%   Approximate the Radon transform from the Linear Structure Field
%   IMG = input image
%   IMGlsf = Linear Structure Field of IMG
%   A = angles to sample
%   R = Radon transform approximation
%   rh = rho axis of R

    x = 1:size(IMG,2);
    y = 1:size(IMG,1);

    xc = x(floor(end/2)+1);
    yc = y(floor(end/2)+1);

    [x,y] = meshgrid(x-xc,y-yc);

    theta = angle(IMGlsf);
    rho = sqrt(x.^2 + y.^2) .* sin (theta - atan2(y,x));

    rh = sqrt(sum(size(IMG).^2));
    rh = -floor(rh/2):ceil(rh/2);

    W = abs(IMGlsf).*IMG;

    rh = rh(:);
    rho = rho(:);
    theta = theta(:);
    W = W(:);
    IMG = IMG(:);

    R = zeros(length(rh)-1,length(A)-1);

    reso = 50;
    stp = 100/reso;
    
    for pc = 1:reso
        m = (W >= prctile(W,(pc-1)*stp)) & (W < prctile(W,pc*stp)); 
        w = mean([IMG(m);0],'omitnan');
        R = R + w * histcounts2(rho(m),theta(m),rh,A);
    end;
    
%     flipud(R);
    
end

