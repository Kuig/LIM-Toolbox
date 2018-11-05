function [ dB, fBound ] = amp2db( A, fBound )
%AMP2DB Convert amplitude values to dBfs
%
%[ Y ] = amp2db( X )
%[ Y ] = amp2db( X, fBound )
%[ Y, fBound ] = amp2db( X )
%
%   Convert amplitude values A to dBfs
%   f is the floor bound expressed in dB, default f is the lowest 
%   non-infinite value present after conversion.
%   calling Y = amp2db(X,-inf); is the same as Y = 20 * log10(X);
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also DB2AMP, RESCALEAMP

    if any(A<0), warning('Negative elements in amp matrix'); end
    dB = 20 * log10(A);
    if nargin < 2
        fBound = dB(isfinite(dB(:)));
        fBound = min(fBound(:));
    end
    if ~isempty(fBound), dB = max(dB,fBound); end
    
end

% ------------------------------------------------------------------------
%
% amp2db.m: Convert amplitude values to dBfs
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