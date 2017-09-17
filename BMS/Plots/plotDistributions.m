function [ hbs,hd,hf,ht ] = plotDistributions( X,s,C,D,Dt,Df,F,T,a,logFreq,gamma )
%[ hs,hd,h2,h1 ] = plotDistributions( X1, X2, F, T, res )
%   Plots Bivariate Spectrum and distributions
%   X1,X2 = spectra of signals to compare
%   F,T = Frequency and time axes
%   res = angle distribution resolution
%   returns figures' handles
%[ hs,hd,h2,h1 ] = plotDistributions( X,s,C,D,Dt,Df,F,T,a,logFreq,gamma )
%   Plots Bivariate Spectrum and distributions (use with precomputed data)
%   X,s,C = Bivariate Spectrum from BS()
%   D,Df,Dt = Principal Spectral Content distributions from PSCDist()
%   F,T,a = Frequency, time and angle axes
%   logFreq = if 1, plots logarithmic frequency axes (def. 1)
%   gamma = render gamma. If < 1 darkens image, if > 1 brightens (def. 0.4)

    if nargin < 10, logFreq = 1; end
    if nargin < 11, gamma = 0.4; end
    if nargin < 6
        X1 = X; X2 = s; F = C; T = D; res = Dt;
        [X,s,C]=BS(X1,X2);
        [D,Df,Dt,a] = PSCDist(X,s,C,res);
    end
    
    if logFreq, yl = [35,130]; else yl = [F(1),F(end)]; end

    hbs = subplot(3,3,[2,3,5,6]);
        plotBS(X,s,C,F,T);
        zoom xon, ylim(yl);

    
    sh = -round(size(a,2)/4);
    D = circshift(D,[0,sh]);
    Dt = circshift(Dt,[sh,0]);
    Df = circshift(Df,[0,sh]);

    xtk = linspace(-pi/2,pi/2,9)+pi/4;
    xlb = {'-\pi/4','','0.0','','\pi/4','','\pm\pi/2','','-\pi/4'};
    
    hd = subplot(3,3,7);
        plotDMask( D, [], [], 1 );
        ylabel('');
        xlabel('');
        grid on, xlim([-pi/2,pi/2]);
   
    hf = subplot(3,3,[1,4]);
        if logFreq
            [Df,N] = linspec2log(Df(2:end,:,:),F(2:end));
        else
            N = F;
        end
        Df = max(Df,0);
        imagesc(a+pi/4,N,Df.^gamma);
        ylim(yl);
        set(gca,'xtick',xtk);
        set(gca,'xticklabel',xlb);
        colormap(1-gray);
        axis xy, grid on;

    ht = subplot(3,3,[8,9]);
        imagesc(T,a+pi/4,Dt.^gamma);
        axis xy, grid on;
        set(gca,'ytick',xtk);
        set(gca,'yticklabel',xlb);
        colormap(1-gray);
end

