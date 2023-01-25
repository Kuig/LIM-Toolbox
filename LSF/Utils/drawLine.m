function [I] = drawLine (I, theta, q, C, mixFun, debug)
%[I] = drawLine (I, theta, q, C, mixFun, debug)
%   drawLine returns matrix I where all points P lying over the line
%   defined by theta and q are processed with mixFun(P,C). If debug is 1 a
%   plot is shown.

    switch nargin
        case [1, 2]
            error('Not enough input arguments');
        case 3
            C = 1;
            mixFun = @(unused, C) C;
            debug = 0;
        case 4
            mixFun = @(unused, C) C;
            debug = 0;
        case 5
            debug = 0;
        case 6
        otherwise
            error('Too many arguments!');
    end;

    % Check swap
    M = tan(theta);
    swap = abs(M) > 1;

    % Setup
    H = size(I,1);
    W = size(I,2);
    Xo = floor((W+1)/2);
    Yo = floor((H+1)/2);
    x = (1 : W) - Xo;
    y = (1 : H) - Yo;

    if swap
%         fx = M * x + q;
        fx = (q - x * cos(theta)) / sin(theta);
        Rx  = round(x + Xo);
        Rfx = round(fx+ Yo);
        msk = (Rfx>0) & (Rfx<=H);
        P = Rfx(msk) + (Rx(msk) - 1).*H;
    else
%         fy = (y - q)/M;
        fy = (q - y * sin(theta)) / cos(theta);
        Ry  = round(y + Yo);
        Rfy = round(fy+ Xo);
        msk = (Rfy>0) & (Rfy<=W);
        P = Ry(msk) + (Rfy(msk) - 1).*H;
    end;
    I(P) = mixFun(I(P),C);  

    % Plot
    if debug == 1
        imagesc(x,y,abs(I)); hold on
        axis xy
        axis image
        grid on
        colormap(gray);
        if ~swap
            plot(fy(msk),y(msk),'r'); hold off
        else
            plot(x(msk),fx(msk),'r'); hold off
        end;
        drawnow;
    end;
end