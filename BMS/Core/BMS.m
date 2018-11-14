function [ X ] = BMS( X1, X2, alpha )
%BMS samples the Bivariate Mixture Space at angles in alpha
%
%[ X ] = BMS( X1, X2, alpha )
%
%   X1 and X2 can be vectors or matrixes, alpha is in the format
%   alpha(f,t,s) (not all dimensions are required)
%
%   If alpha is a scalar, the mixture is sampled at the corresponding
%   position. This is a trivial case, the same result can be achieved by a 
%   linear transformation in time domain.
%
%   If alpha is a column vector, all frequencies are sampled independently
%   at the corresponding positions ('frequency' or 'line' mode)
%
%   If alpha is a row vector, all frames are sampled independently at the
%   corresponding positions ('time' or 'column' mode)
%
%   If alpha is a f-by-t matrix, all bins are sampled independently at the
%   corresponding positions ('time-frequency' or 'R2' mode, this is the
%   typcal use)
%
%   If ndims(alpha)==3, all bins are sampled independently at the
%   corresponding positions and X will have size(alpha,3) pages
%  ('volume' mode)
%
%   Reference: Presti, G. "Signal transformations for improving information
%              representation, feature extraction and source separation."
%              PhD Thesis (2017).
%
%(C)2009 G.Presti (LIM) - GPL license at the end of file
% See also BS, CCORR, SANGLE, PSC

    [X1, X2, alpha, a_case] = validateInput(X1,X2,alpha);
    
    switch a_case
        case {'freq', 'time', 'vol'}
            X = bsxfun(@times, X1, cos(alpha)) + bsxfun(@times, X2, sin(alpha));
        case 'timefreq'
            X = X1 .* cos(alpha) + X2 .* sin(alpha);
        otherwise
            error('How did you get here?!');
    end
end

function [X1, X2, alpha, a_case] = validateInput(X1,X2,alpha)

    if any (size(X1) ~= size(X2))
        error('X1 and X2 must be of same size');
    end
    
    if ~ismatrix(X1)
        error('X1 and X2 must be vectors or matrixes');
    end
    
    if isrow(X1)
        X1 = X1(:);
        X2 = X2(:);
    end

    if isscalar(alpha)
        alpha = ones(size(X1,1),1) * alpha;
    end
    
    if iscolumn(alpha)
        if size(X1,1) ~= size(alpha,1)
            error('X1, X2 and alpha must have same rows for ''frequency'' mode');
        end
        a_case = 'freq';
    end

    if isrow(alpha)
        if size(X1,2) ~= size(alpha,2)
            error('X1, X2 and alpha must have same columns for ''time'' mode');
        end
        a_case = 'time';
    end

    if ~isvector(alpha)
        if ismatrix(alpha)
            if any(size(X1) ~= size(alpha))
                error('X1, X2 and alpha must be the same size for ''time-frequency'' mode');
            end
            a_case = 'timefreq';
        else
            if (size(X1,1) ~= size(alpha,1) || size(X1,2) ~= size(alpha,2))
                error('X1, X2 and alpha(:,:,1) must be the same size for ''volume'' mode');
            end
            a_case = 'vol';
        end
    end
end

% ------------------------------------------------------------------------
%
% BMS.m: samples the Bivariate Mixture Space at angles in alpha
% Copyright (C) 2009 - Giorgio Presti - Laboratorio di Informatica Musicale
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