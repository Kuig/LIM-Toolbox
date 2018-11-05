function [ b, a ] = getSampleFilter( order )
%GETSAMPLEFILTER Returns random filter coefficients of a stable filter of given order.
%
%[ b, a ] = GETSAMPLEFILTER( order )
%
%   Pole frequencies are ditributed uniformly in the log-frequency space
%   Zero frequencies are ditributed uniformly in the linear-frequency space
%   Pole distance from origin is unlikely 0 and more likely at 0.99 (but always < 1)
%   Zero distance from origin follow a gaussian distribution around 1
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also GETSAMPLEAUDIO

    pf = pi * st2hz(30 + rand(1,order) * 100) / 22050;
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

% ------------------------------------------------------------------------
%
% getSampleFilter.m: random filter coefficients of a stable filter
% Copyright (C) 2014 - Giorgio Presti - Laboratorio di Informatica Musicale
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>
%
% ------------------------------------------------------------------------

