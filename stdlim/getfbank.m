function [fbank, cent] = getfbank(F, bw, scale, wfunc)

    if nargin < 2, bw = 100; end
    if nargin < 3, scale = 'mel'; end
    if nargin < 4, wfunc = @triang; end

    first_el = 1;
    switch lower(scale)
        case {'mel','mels'}
            f2x = @f2mel; x2f = @mel2f;
        case {'bark','barks'}
            f2x = @f2bark; x2f = @bark2f;
        case {'st','semitone','semitones'}
            f2x = @linf2logf; x2f = @logf2linf;
            if F(1) <= 0, first_el = 2; end
        case 'hz'
            f2x = @(x) x; x2f = @(x) x;
        otherwise
            error(['Unsupported scale type: ', scale]);
    end
    
    low  = f2x(F(first_el));
    high = f2x(F(end));
    nband = ceil((high-low)/bw-1);
    
    cent = low + linspace(1,nband,nband).*bw;
    inferiori = x2f(cent-bw);
    superiori = x2f(cent+bw);
    
    n = length(F);
    fbank=zeros(nband,n);
    for b=1:nband 
        il=findx(F, inferiori(b));
        ih=findx(F, superiori(b));
        fbank(b,il:ih)=wfunc(ih-il+1);
    end
    
end

function indx = findx(X, val)
    X = abs(X-val); 
    [~, indx] = min(X); 
end