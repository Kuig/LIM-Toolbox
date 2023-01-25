function [ L, P ] = getLine ( I, theta, q )
%[ L, P ] = getLine ( I, theta, q )
%   Returns all pixels L laying on the line theta-q of image or matrix I 
%   as a single column vector. P contains the linear indexes of sampled
%   pixels

    theta = theta - pi/2;

    % Check swap
    M = tan(theta);
    swap = abs(M) > 1;

    % Setup
    H = size(I,1);
    W = size(I,2);
    Xo = floor((W+1)/2);
    Yo = floor((H+1)/2);
    x = (1-Xo : W-Xo);
    y = (1-Yo : H-Yo);

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
    L = I(P);
    L = L(:);
end