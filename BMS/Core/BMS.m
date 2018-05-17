function [ X ] = BMS( X1,X2,alpha )
%[ X ] = BMS( X1,X2,alpha )
%   Samples the Bivariate Mixture Space at angle alpha
%   X1 and X2 can be vectors or matrixes, alpha is in the format
%   alpha(f,t,az) (not all dimensions are required)

    if nargin < 3
        error('Please provide alpha');
    end

    [X1, X2, alpha, a_case] = validateInput(X1,X2,alpha);
    
    switch a_case
        case {'row', 'col', 'vol'}
            X = bsxfun(@times, X1, cos(alpha)) + bsxfun(@times, X2, sin(alpha));
        case 'mat'
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
            error('X1, X2 and alpha must have same rows for rows mode');
        end
        a_case = 'col';
    end

    if isrow(alpha)
        if size(X1,2) ~= size(alpha,2)
            error('X1, X2 and alpha must have same columns for columns mode');
        end
        a_case = 'row';
    end

    if ~isvector(alpha)
        if ismatrix(alpha)
            if any(size(X1) ~= size(alpha))
                error('X1, X2 and alpha must be the same size for matrix mode');
            end
            a_case = 'mat';
        else
            if (size(X1,1) ~= size(alpha,1) || size(X1,2) ~= size(alpha,2))
                error('X1, X2 and alpha(:,:,1) must be the same size for volume mode');
            end
            a_case = 'vol';
        end
    end
end
