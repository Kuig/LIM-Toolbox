function [ b, a ] = getSampleFilter( order )
%[ b, a ] = getSampleFilter( order )
%   returns random filter coefficients of a stable filter of known order.
%   
%   Pole frequencies are ditributed uniformly in the log-frequency space
%   Zero frequencies are ditributed uniformly in the linear-frequency space
%   Pole magnitudes distribution is low at 0 and high at 0.99
%   Zero magnitudes follow a gaussian distribution around 1
%
%   (A finer control of distributions will be implemented)

    pf = pi * logf2linf(30 + rand(1,order) * 100) / 22050;
%     zf = pi * logf2linf(30 + rand(1,order) * 100) / 22050;
    zf = pi * (45 + rand(1,order) * 15000) / 22050;
    pa = (rand(1,order).^0.5)*0.99;
    za = 1+randn(1,order);
    pZ = pa .* exp(1i * pf);
    zZ = za .* exp(1i * zf);
    pZ = [pZ conj(pZ)];
    zZ = [zZ conj(zZ)];
    a = poly(pZ);
    b = poly(zZ);
    b=b/sum(b);
    a=a/sum(a);
end

