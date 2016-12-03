function [ Y ] = mcrop( X, r, c, s )
%[ Y ] = mcrop( X, r, c, s )
%   Crops a matrix X to a s-by-s square matrix around row r and colum c
%   If r or c are on the edges of X, elements of Y outside X are set to 0

    m = size(X,1);
    n = size(X,2);

    if ((r > m) || (r < 1) || (c > n) || (c < 1))
        error('Index out of bound')
    end;

    s2 = floor(s/2);

    r = r - s2 - 1;
    c = c - s2 - 1;

    skipchek = ~(r<0 || r>m-s-1 || c<0 || c>n-s-1);

    Y = zeros(s);
    for R = 1:s
        for C = 1:s
            if skipchek 
                Y(R,C) = X(r+R, c+C);
            else
                Xr = r + R;
                Xc = c + C;
                if ((Xr>0)&&(Xr<=m)&&(Xc>0)&&(Xc<=n))
                    Y(R,C) = X(Xr,Xc);
                else
                    Y(R,C) = 0;
                end;
            end;
        end;
    end;

end
