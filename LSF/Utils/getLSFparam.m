function [ A, w ] = getLSFparam( radius, alphaRes )
%[ A, w ] = getLSFparam( radius, alphaRes )
%   Returns parameters to be fed into LSF
%   radius is the radius in pixels, alphaRes is the number of angles to
%   sample (between -pi/2 and pi/2)

    diameter = radius * 2 + 1;
    w = gausswin(diameter,1);
    w(ceil(diameter/2)) = 0;
    w = w/sum(w);

    A = linspace(-pi/2,pi/2,alphaRes+1); 
    A = A(1:end-1);
    A = A(:);

end

