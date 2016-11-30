function [ Y ] = panpot( X, a )
%[ Y ] = panpot( X, a )
%   Given a signal X of size n by 1, returns a signal Y of size n by 2
%   containing a panned version of X with angle a
%   a = 0     -> mid
%   a = pi/2  -> side
%   a = pi/4  -> right
%   a = -pi/4 -> left

% To Do: add more pan laws

    Y(:,1) = X * cos(a+pi/4);
    Y(:,2) = X * sin(a+pi/4);

end

