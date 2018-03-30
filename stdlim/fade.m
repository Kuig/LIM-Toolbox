function x = fade(x, direction, len, slope)
%x = fade(x, direction, len, slope)
% direction can be 'in', 'out', 'inout'

    if nargin < 4, slope = 0.5; end
    if len > size(x,1), error('Error using fade(): fade longer than signal'); end
    switch lower(direction)
        case 'in'
            env = (linspace(0,1,len).').^slope;
            x(1:len,:) = bsxfun(@times, x(1:len,:), env);
        case 'out'
            env = (linspace(1,0,len).').^slope;
            x(1+end-len:end,:) = bsxfun(@times, x(1+end-len:end,:), env);
        case 'inout'
            x = fade(x, 'in', len, slope);
            x = fade(x, 'out', len, slope);
        otherwise
            error('Error using fade(): direction can be ''in'', ''out'' or ''inout''');
    end

end