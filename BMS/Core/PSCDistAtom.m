function [ D, dist, alpha ] = PSCDistAtom( s, W, dir, res, fun )
%[ D, dist, alpha ] = PSCDistAtom( s, W, dir, res, fun )
%   Get Principal Spectral Content weighted distribution in the BMS
%   s = PSC angles
%   W = weights
%   dir = direction: 1 = time, 2 = frequency (def. 2)
%   res = resoltion (def. 201)
%   fun = summing function (def @(X,dim) sum(X,dim,'omitnan') )
%   D = overall distribution
%   dist = distribution over time or frequency
%   alpha = angle axes

    if nargin < 5, fun = @(X,d) sum(X,d,'omitnan'); end
    if nargin < 4, res = 201; end
    if nargin < 3, dir = 2; end
    
    alpha = linspace(-pi/2,pi/2,res);
    dist = histw(s, W, alpha, dir, fun);
    D = fun(dist,3-dir).';
    alpha = alpha(1:end-1)+pi/res;

end

