function [ Y, lN ] = linspec2log( X, F, method, res, Nmin, Nmax)
%[ Y, lN ] = linspec2log( X, F )
%[ Y, lN ] = linspec2log( X, F, method )
%[ Y, lN ] = linspec2log( X, F, method, res )
%[ Y, lN ] = linspec2log( X, F, method, res, Nmin )
%[ Y, lN ] = linspec2log( X, F, method, res, Nmin, Nmax)
%
%   DEPRECATED
%
%   X is the array or m-by-p matrix of the spectrum
%   F is the frequency column array of lenght m
%   method is the interpolation mentod, default is 'pchip'
%   res is the output resolution, default is m (same as F)
%   Nmin is the first note number of the output array, default to min(F)
%   Nmax is the first note number of the output array, default to max(F)
%   lN output is the new frequency axis expressed in note numbers (440->69)
%
%[ Y, N ] = linspec2log( X, [], 'map', I, L, H )
%
%   Uses matrix method and returns matrix N such that X = N*Y

    if nargin < 3, method = 'pchip'; end

    warning('linspec2log is deprecated and will be removed');
    
    switch method
        case 'map'
            if nargin < 6, Nmax = size(X,1); end
            if nargin < 5, Nmin = 3; end
            if nargin < 4, res = Nmax; end
            [M,lN] = logfmap(res,Nmin,Nmax);
            Y = M*X; % X = lN*Y
        otherwise
            if (F(1)<=0)
                warning ('Found F <= 0 during log.freq. conversion!');
                F = F(2:end);
                X = X(2:end,:,:);
            end
            N = linf2logf(F);
            if nargin < 4, res = size(F,1); end
            if nargin < 5, Nmin = min(N(isfinite(N))); end
            if nargin < 6, Nmax = max(N(isfinite(N))); end
            lN = linspace(Nmin,Nmax,res).';
            Y = interp1(N,X,lN,method);
    end
end


function [M,N,G] = logfmap(I,L,H)
% [M,N] = logfmap(I,L,H)
%     Return a maxtrix for premultiplying spectrograms to map
%     the rows into a log frequency space.
%     Output map covers bins L to H of input
%     L must be larger than 1, since the lowest bin of the FFT
%     (corresponding to 0 Hz) cannot be represented on a 
%     log frequency axis.  Including bins close to 1 makes 
%     the number of output rows exponentially larger.
%     N returns the recovery matrix such that N*M is approximately I
%     (for dimensions L to H).
%     
% 2004-05-21 dpwe@ee.columbia.edu

    % Convert base-1 indexing to base-0
    L = L-1;
    H = H-1;

    ratio = (H-1)/H;
    opr = round(log(L/H)/log(ratio));
    ibin = L*exp((0:(opr-1))*-log(ratio));

    M = zeros(opr,I);

    for i = 1:opr
      % Where do we sample this output bin?
      % Idea is to make them 1:1 at top, and progressively denser below
      % i.e. i = max -> bin = topbin, i = max-1 -> bin = topbin-1, 
      % but general form is bin = A exp (i/B)
      tt = pi*((0:(I-1))-ibin(i));
      M(i,:) = (sin(tt)+eps)./(tt+eps);
    end

    % Normalize rows, but only if they are boosted by the operation
    %G = 1./max(1,diag(M'*M))';
    
    %% Fixup gain in bottom bins
    G = ones(1,I);
    G(1:(H+1)) = (0:H)./H;

    % Inverse is just transpose plus scaling
    N = (M.*repmat(G,opr,1))';

end
