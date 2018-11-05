function [ data, Fs, bits ] = wavread( filename, param )
%WAVREAD (backward compatibility for wavread)
%
% [ y, Fs, bits ] = WAVREAD( 'filename' )
% [...] = WAVREAD( 'filename', N )
% [...] = WAVREAD( 'filename', [N1 N2] )
% [ size ] = WAVREAD( 'filename', 'size' )
%
%	audioread wrapper for wavread backward compatibility
%
%(C)2014 G.Presti (LIM) - GPL license at the end of file
% See also WAVWRITE, AUDIOWRITE, AUDIOREAD

    info  = audioinfo(filename);
    
    bits  = info.BitsPerSample;
    Fs    = info.SampleRate;
    siz   = info.TotalSamples;
    numch = info.NumChannels;
    
    if (nargin < 2)
		data = audioread(filename);
    else
        if strcmpi(param,'size')
			data = [siz, numch];
        else
            if isscalar(param)
				data = audioread(filename,[1,param]);
			else
				data = audioread(filename,param);
            end
        end
    end
end

% ------------------------------------------------------------------------
%
% wavread.m: backward compatibility for wavread
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