function [ A ] = db2amp( dB )
%DB2AMP Convert dBfs to linear amplitude values
%
%[ A ] = DB2AMP( dB )
%
%   Convert dBfs values dB to amplitude A
%   A = 10.^(dB/20);
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also AMP2DB, RESCALEAMP

    A = 10.^(dB/20);

end

% ------------------------------------------------------------------------
%
% db2amp.m: Convert dBfs to amp value
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