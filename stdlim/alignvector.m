function [ A, lag, s ] = alignvector( A, B, maxlag, polarity )
%ALIGNVECTOR shifts a vector to maximize correlation with a reference
%
%[ A, lag, s ] = ALIGNVECTOR( A, B )
%[ A, lag, s ] = ALIGNVECTOR( A, B, maxlag )
%[ A, lag, s ] = ALIGNVECTOR( A, B, maxlag, polarity )
%
%   Shifts column or row vector A to maximize cross correlation with B
%
%[ M, lag, s ] = ALIGNVECTOR( M )
%[ M, lag, s ] = ALIGNVECTOR( M, [], maxlag, polarity )
%
%   This can also be used by passing a 2-by-n or n-by-2 matrix M, in that
%   case, the first column or row of M is shifted to match the second
%
%   maxlag:   maximum offset (default: length(A)/2)
%   polarity: if set to true, uses absolute xcorrelation and flips A
%             polarity if needed. In this case the function also return
%             +/- 1 according to the sign of xcorr peak. Default polarity
%             value is FALSE (0).
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also XCORR, CIRCSHIFT

    [Na, Ta] = min(size(A));

    if Na>2, error('Unsupported size of A'); end
    if nargin < 3, maxlag = ceil(length(A)/2); end
    if nargin < 4, polarity = 0; end
    
    if Na == 1
        [ A, lag, s ] = AV( A, B, maxlag, polarity );
    else
        if Ta==1
            % 2 rows
            B = A(2,:); A = A(1,:);
            [ A, lag, s ] = AV( A, B, maxlag, polarity );
            A(2,:) = B;
        else
            % 2 columns
            B = A(:,2); A = A(:,1);
            [ A, lag, s ] = AV( A, B, maxlag, polarity );
            A(:,2) = B;
        end
    end
    
end

function [ A, lag, s ] = AV( A, B, maxlag, polarity ) 
    z = A/rms(A);
    B = B/rms(B);
    
    [r,l] = xcorr(B,z,maxlag);
    
    if polarity
        [~,n] = max(abs(r));
        s = sign(r(n));
    else
        [~,n] = max(r);
        s = 1;
    end
    lag = l(n);

    A = s * circshift(A,lag);
end

% ------------------------------------------------------------------------
%
% alignvector.m: shifts a vector to maximize correlation with a reference
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