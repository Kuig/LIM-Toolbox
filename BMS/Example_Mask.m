
% Load or generate audio sample
% [x, Fs] = audioread('SillySample.wav');
Fs = 44100; dur = 8; len = dur*Fs;
x = getSampleAudio(dur,Fs);

% Listen to sample
% sound(x,Fs);

% Get STFT
w = hann(2048); hop = 512;
[L, F, T] = getFD(x(:,1),Fs,hop,w);
[R, ~, ~] = getFD(x(:,2),Fs,hop,w);

% Compute Bivariate Spectrum
[ X, s, C ] = BS(L,R);

% Find a source by locating a peak in the BS angle distribution
[ edges, a ] = getBinEdges(200, [-pi/2, pi/2]);
[ D, Df ]    = getMixtureHists(X,s,C,edges);
[ pk, loc ]  = max(D(:,1));
sourcePosition = a(loc);
tolerance = 0.08;

% Viusalize data
background = rescalefreq(Df,F,'mel').^0.25;
subplot(3,1,2)
    plotdm( D(:,1), sourcePosition, tolerance,...
            'type', 'gauss',   'saturation', 0.4,...
            'rotate', 'on',    'background', background );
    title('Mask and distribution')

% Retrive binary mask
mask = angleMask( s, sourcePosition, tolerance, 'type', 'gauss', 'saturation', 0.4 );

% Apply mask
newL = L .* mask;
newR = R .* mask;

% Back to time domain
y(:,1) = getTD(newL, hop, len, w);
y(:,2) = getTD(newR, hop, len, w);

% Listen to result
sound(y,Fs);

% Plot input and output Bivariate Spectra
subplot(3,1,1)
    [X,s,C] = BS(L,R);
    plotBS(X,s,C,F,T,'yscale','mel');
    grid on, ylabel('mels'); xlabel('Time');
    title('Input');
    
subplot(3,1,3)
    [X,s,C] = BS(newL,newR);
    plotBS(X,s,C,F,T,'yscale','mel');
    grid on, ylabel('mels'); xlabel('Time');
    title('Output');

