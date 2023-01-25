function [ y ] = fwkeep( x, len )
%[ y ] = fwkeep( x, len )
%   Keeps len elements of x, discarding leading and trailing elements
%   similar to matlab function wkeep, but tailored on LSF task

    l = length(x);
    d = (l-len)/2;
    first = max(1+floor(d),1);
    last  = min(l-ceil(d),l);
    cl = last-first+1;
    if (cl == len)
        y = x(first:last);
    else
        y = zeros(len,1);
        y(1:cl) = x(first:last);
    end;
    
end