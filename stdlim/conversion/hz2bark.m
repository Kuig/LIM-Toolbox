function [ bark ] = hz2bark( f )
%HZ2BARK Convert frequency to barks
%
%[ bark ] = HZ2BARK( f )
%
%    Reference: Wang, Shihua, Andrew Sekey, and Allen Gersho. "An objective
%               measure for predicting subjective quality of speech coders."
%               IEEE Journal on selected areas in communications 10.5 (1992): 819-829.
%
%(C)2018 G.Presti (LIM) - GPL license at the end of file
% See also BARK2HZ, GETFREQCONVERTERS, RESCALEFREQ

    bark = 6 * asinh(f/600);
    
end

% ------------------------------------------------------------------------
%
% hz2bark.m: Convert frequency to barks
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