function [ x ] = conform( x, ol, n )
%CONFORM Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 3, n = false; end

    x = mean(x,2);
    
    if n, x = x./max(abs(x)); end
    
    il = numel(x);
    if il < ol
        x = repmat(x,ceil(ol/il),1);
    end
    x = wkeep(x,ol);
    
    
end

