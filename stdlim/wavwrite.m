function wavwrite( y, Fs, N, filename )
% wavwrite(y,'filename')
% wavwrite(y,Fs,'filename')
% wavwrite(y,Fs,N,'filename')
% audiowrite wrapper for wavwrite backward compatibility

	switch nargin
		case 2
			filename = Fs;
			Fs = 8000;
			N = 16;
		case 3
			filename = N;
			N = 16;
		otherwise
	end;

	audiowrite(filename,y,Fs,'BitsPerSample',N);

end