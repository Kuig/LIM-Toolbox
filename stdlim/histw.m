function [ h, edges ] = histw( x, w, bin, dim, func )
%[ h, edges ] = histw( x, w, bin, dim, func )
%   h contains the @func of w which corresponding x are in between edges
%   bin can be a scalar (number of bins) or an array (edge list)
%   dim is the dimension along which histw should work
%   func is tipically @sum, but it can be also @max or other stats function
%   all input arguments are defaulted to behave like a common histogram

    if ~ismatrix(x), error('Histw can only handle n-by-m matrix'); end;
    if any(size(x) ~= size(w)), error('x and w must be of the same size'); end;
    % I think ther's some error here:
    if (iscolumn(x) && dim == 2) || (isrow(x) && dim == 1), 
        warning('Dim argument ignored...');  
        dim = 3-dim; 
    end;
    
    if nargin < 5, func = @(X,dim) sum(X,dim,'omitnan'); end;
    if nargin < 4, dim = 2; end;
    if nargin < 3, bin = 10; end;
    if nargin < 2, w = ones(size(x)); end;
    
    if isscalar(bin)
        edges = binpicker(min(x(:)),max(x(:)),bin,range(x(:))/bin);
    else
        edges = bin(:);
        bin = size(edges,1)-1;
    end;

    id = discretize(x, edges);

    mid = min(id(:));
    mad = max(id(:));
    h = zeros(bin,size(x,3-dim)); 
    
    for b = mid:mad           %% THIS S**T IS SLOW
        msk = id==b;
        tw = w.*msk;    
        h(b,:) = func(tw,dim);
    end;
    
    if dim == 2, h = h'; end;

end


function edges = binpicker(xmin,xmax,nbins,rawBinWidth)
% BINPICKER Choose histogram bins.
%   Copyright 1984-2015 The MathWorks, Inc.

if ~isempty(xmin)
    xscale = max(abs([xmin,xmax]));
    xrange = xmax - xmin;
    
    % Make sure the bin width is not effectively zero.  Otherwise it will never
    % amount to anything, which is what we knew all along.
    rawBinWidth = max(rawBinWidth, eps(xscale));
    
    % If the data are not constant, place the bins at "nice" locations
    if xrange > max(sqrt(eps(xscale)), realmin(class(xscale)))
        % Choose the bin width as a "nice" value.
        powOfTen = 10.^floor(log10(rawBinWidth)); % next lower power of 10
        relSize = rawBinWidth / powOfTen; % guaranteed in [1, 10)
        
        % Automatic rule specified
        if isempty(nbins)
            if  relSize < 1.5
                binWidth = 1*powOfTen;
            elseif relSize < 2.5
                binWidth = 2*powOfTen;
            elseif relSize < 4
                binWidth = 3*powOfTen;
            elseif relSize < 7.5
                binWidth = 5*powOfTen;
            else
                binWidth = 10*powOfTen;
            end
        
            % Put the bin edges at multiples of the bin width, covering x.  The
            % actual number of bins used may not be exactly equal to the requested
            % rule. 
            leftEdge = min(binWidth*floor(xmin ./ binWidth), xmin);
            nbinsActual = max(1, ceil((xmax-leftEdge) ./ binWidth));
            rightEdge = max(leftEdge + nbinsActual.*binWidth, xmax);
            
        % Number of bins specified
        else    
            % temporarily set a raw binWidth to a nice power of 10. 
            % binWidth will be set again to a different value if more than 
            % 1 bin.
            binWidth = powOfTen*floor(relSize);
            % Set the left edge at multiples of the raw bin width.
            % Then adjust bin width such that all bins are of the same
            % size and xmax fall into the rightmost bin.
            leftEdge = min(binWidth*floor(xmin ./ binWidth), xmin);
            if nbins > 1
                ll = (xmax-leftEdge)/nbins;  % binWidth lower bound, xmax
                                             % on right edge of last bin
                ul = (xmax-leftEdge)/(nbins-1);  % binWidth upper bound,
                                          % xmax on left edge of last bin
                p10 = 10^floor(log10(ul-ll));
                binWidth = p10*ceil(ll./p10);  % binWidth-ll < p10 <= ul-ll
                                               % Thus, binWidth < ul                 
            end
            
            nbinsActual = nbins;
            rightEdge = max(leftEdge + nbinsActual.*binWidth, xmax);         
        end
        
    else % the data are nearly constant
        % For automatic rules, use a single bin.
        if isempty(nbins)
            nbins = 1;
        end
        
        % There's no way to know what scale the caller has in mind, just create
        % something simple that covers the data.

        % Make the bins cover a unit width, or as small an integer width as
        % possible without the individual bin width being zero relative to
        % xscale.  Put the left edge on an integer or half integer below
        % xmin, with the data in the middle 50% of the bin.  Put the right
        % edge similarly above xmax.
        binRange = max(1, ceil(nbins*eps(xscale)));
        leftEdge = floor(2*(xmin-binRange./4))/2;
        rightEdge = ceil(2*(xmax+binRange./4))/2;

        binWidth = (rightEdge - leftEdge) ./ nbins;
        nbinsActual = nbins;
    end
    
    edges = [leftEdge + (0:nbinsActual-1).*binWidth, rightEdge];
else
    % empty input
    if ~isempty(nbins)
        edges = cast(0:nbins, 'like', xmin);
    else
        edges = cast([0 1], 'like', xmin);
    end
end

end

