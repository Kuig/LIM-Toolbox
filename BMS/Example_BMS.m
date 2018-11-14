
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

% Trivial resampling of the input mixtures
% (creates a rotating effect)
a = linspace(-pi,pi,numel(T));
newL = BMS(L, R, a );
newR = BMS(L, R, a + pi/4 );

% Back to time domain
y = zeros(len,2);
y(:,1) = getTD(newL, hop, len, w);
y(:,2) = getTD(newR, hop, len, w);

% Listen to result (ideally with hedphones)
sound(y,Fs);

% Plot input and output Bivariate Spectra
subplot(2,1,1)
    [X,s,C] = BS(L,R);
    plotBS(X,s,C,F,T,'yscale','mel');
    grid on; ylabel('mels'); xlabel('Time');
    title('Input');
    
subplot(2,1,2)
    [X,s,C] = BS(newL,newR);
    plotBS(X,s,C,F,T,'yscale','mel');
    grid on, ylabel('mels'); xlabel('Time');
    title('Output');
    