
% Load or generate audio sample
% [x, Fs] = audioread('SillySample.wav');
Fs = 44100; dur = 8; len = dur*Fs;
[ x, s, pans ] = getSampleAudio(dur,Fs,2,{'perc','pads','noise'});

% Independent Component Analysis
[ y, W ] = icabybms( x );

% Plot extracted sources
t = linspace(0,dur,len); l1 = [-1,1]; ld = [0,dur];
subplot(2,6,04);
    plot(t,s(:,1)); xlim(ld); ylim(l1); grid on; title('Latent sources');
subplot(2,6,10);
    plot(t,s(:,3)); xlim(ld); ylim(l1); grid on;
subplot(2,6,05);
    plot(t,x(:,1)); xlim(ld); ylim(l1); grid on; title('Mixtures');
subplot(2,6,11);
    plot(t,x(:,2)); xlim(ld); ylim(l1); grid on;
subplot(2,6,06);
    plot(t,y(:,1)); xlim(ld); ylim(l1); grid on; title('Recovered sources');
subplot(2,6,12);
    plot(t,y(:,2)); xlim(ld); ylim(l1); grid on;

% Plot mixtures info
x = x./max(abs(x(:)));
a = ang2mat(pans([1,3]));
edg = linspace(-1,1,1024);
[pic, xx, yy] = histcounts2(x(:,1),x(:,2),edg,edg); 
subplot(2,6,[1:3,7:9]);
    imagesc(xx,yy,pic.'.^0.125), colormap(1-gray), hold on;
    p(1) = plot([0,a(1,1)],[0,a(2,1)],'o-b');  plot([0,a(1,2)],[0,a(2,2)],'o-b');
    p(2) = plot([0,W(1,1)],[0,W(2,1)],'*--m'); plot([0,W(1,2)],[0,W(2,2)],'*--m');
    xlim(l1), ylim(l1), grid on, box on, hold off;
    title('Bivariate mixture with inferred Independent Components');
    legend(p,'Ground truth','BMS-ICA'); xlabel('x_1'),ylabel('x_2')
