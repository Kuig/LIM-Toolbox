function [ y, wm, dwm, mu ] = whitening( x, defaultnan )
% WHITENING whitens a multivariate signal
%
%[ x, wm, dwm ] = WHITENING( x )
%[ x, wm, dwm, mu ] = WHITENING( x )
%_ = WHITENING( x, defaultnan )
%
%   Columns of x are variables, while rows are observations
%   Mean is removed only if fourth output is asked.
%	If defaultnan is not specified or true, default transformations are NaN, otherwise they are identity transformations
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also COV, EIG

    epsilon = 1e-7;
    
    if nargout > 3
        mu = mean(x);
        x = x-mu;
    end

    cm  = cov(x, 1);
    [E, D] = eig (cm);
    
    if all(diag (D) < epsilon)
        y = x;
        if nargin < 2 || defaultnan
            wm = NaN;
            dwm = NaN;
        else
            wm = eye(size(cm, 1));
            dwm = eye(size(cm, 1));
        end
    else
        %wm = (eye(size(cm, 1)) .* (diag(D).^(-0.5))) * E.';
		wm  = (sqrt (D)) \ E.';
        dwm = E * sqrt (D);
        y   = (wm * x.').';
        if ~isreal(y)
            y = x;
            wm = NaN;
            dwm = NaN;
        end
    end

end

% ------------------------------------------------------------------------
%
% whitening.m: whitens multivariate signal
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
