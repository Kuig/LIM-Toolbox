function [ data, Fs, bits ] = wavread( filename, param )
% [ y, Fs, bits ] = wavread('filename')
% [...] = wavread('filename',N)
% [...] = wavread('filename',[N1 N2])
% [ size ] = wavread('filename','size')
% audioread wrapper for wavread backward compatibility

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
			end;
		end;
    end;
end