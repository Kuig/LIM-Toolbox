function [ c ] = NLVS( a, b )
%[ c ] = NLVS( a, b )
%   Pairwise Non-Linear Vector Summation between a and b
%   Return the sum of complex numbers a and b such that differences in pi/2
%   results in 0 magnitude

      a = abs(a).*exp(2i*angle(a));
      b = abs(b).*exp(2i*angle(b));

      c = a+b;

      c = abs(c).*exp(1i*(angle(c)/2));

      
end

