function [ edges, centers ] = getBinEdges( bin, lim )
%GETBINEDGES returns edges and bin centers
%
%[ edges, centers ] = GETBINEDGES( bin, lim )
%
%   bin: number of bins (default: 180)
%   lim: limits in the form [min, max] (default: [-pi/2, pi/2])
%
%   edges:   bins edges list
%   centers: bins centers list
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also HISTW

    if nargin < 1, bin = 180; end
    if nargin < 2, lim = [ -pi/2, pi/2 ]; end

    lim = sort(lim);
    
    % calc bin edges
    edges = linspace( lim(1), lim(end), bin+1 );
    
    if nargout > 1
        % convert edges to centers
        centers = edges(1:end-1) + ( lim(end) - lim(1) ) / (2 * bin);
    end
    
end

% ------------------------------------------------------------------------
%
% getBinEdges.m: returns edges and bin centers
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