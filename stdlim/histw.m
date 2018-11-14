function [ h, edges ] = histw( x, w, bin, dims, func )
%HISTW generates weighted histograms
%
%[ h, edges ] = HISTW( x )
%[ h, edges ] = HISTW( x, w )
%[ h, edges ] = HISTW( x, w, bin )
%[ h, edges ] = HISTW( x, w, bin, dims )
%[ h, edges ] = HISTW( x, w, bin, dims, func )
% 
%   h contains the @func of w which corresponding x are in between edges
%   all input arguments are defaulted to behave like a common histogram
%
%   bin:  scalar (number of bins) or array (edges list)
%   dims: array of dimensions along which histw should work (default: 1:ndims(x))
%   func: accumulation function (default: @(X,di) sum(X,di,'omitnan'))
%
%   h: if numel(dims) == 1, h is a matrix containing histograms of each
%      column or row depending on the content of dims
%      if numel(dims) > 1, h is a cell array containing more than one of
%      the aforesaid histograms matrixes
%   edges: edges list
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also HISTC, HISTCOUNTS, DISCRETIZE, GETBINEDGES

    if nargin < 5, func = @(X,di) sum(X,di,'omitnan'); end
    if nargin < 4, dims = 1:ndims(x); end
    if nargin < 3, bin = 10; end
    if nargin < 2, w = ones(size(x)); end

    [bin, edges, dims] = validateInput(x, w, bin, dims);

    if exist('discretize','file') == 2
        id = discretize(x, edges);         % Introduced in Matlab R2015a
    elseif exist('histcounts','file') == 2
        [~, ~, id] = histcounts(x, edges); % Introduced in Matlab R2014b
    else
        [~, id] = histc(x, edges);         % DEPRECATED
    end

    nd = ndims(x)+1;
    mnd = min(id(:));
    mxd = max(id(:));
    
    h = cell(numel(dims),1);
    
    for d = 1:numel(dims), h{d} = zeros(bin,size(x,nd-dims(d))); end
    
    for b = mnd:mxd
        msk = id==b;
        tw  = w.*msk;    
        for d = 1:numel(dims)
            h{d}(b,:) = func(tw,dims(d));
        end
    end

    if any(dims==2)
        h{dims==2} = h{dims==2}.';
    end
    if numel(dims) == 1, h = h{1}; end
    
end

function [bin, edges, dims] = validateInput(x, w, bin, dims)

    if ~ismatrix(x), error('Histw can only handle n-by-m matrix'); end % I may drop this
    
    if any(size(x) ~= size(w)), error('x and w must be of the same size'); end
    
    if any(dims>ndims(x)), error('''dims'' contains a dimension which is not present in x'); end
    
    if (iscolumn(x) && any(dims == 2)) || (isrow(x) && any(dims == 1))  % I may drop also this
        % warning('Dim argument ignored...');  
        dims = iscolumn(x) + 2*isrow(x); 
    end
    
    if isscalar(bin)
        edges = getBinEdges(bin, [ min(x(:)), max(x(:)) ]);
    else
        edges = bin(:);
        bin = size(edges,1)-1;
    end
    
end

% ------------------------------------------------------------------------
%
% histw.m: weighted histogram
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