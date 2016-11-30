function [ybg] = plotDMask( D, p, H, rot, BG )
%plotDMask( D, p, H )
%   Plots columns present in D as distributions
%   if p and H are not empty, also plots a mask centered in p, with lobes
%   at p-H(1) and p+H(2) (or p+-H if H is a scalar)
%plotDMask( D, p, H, rot )
%   if rot = 1 centers plot over pi/4 (shared components) (def. 0)
%[ybg] = plotDMask( ___ , BG )
%   BG can be a matrix to be used as a background image
%   in case BG is used, ybg contains its y axis

    D = D.';
    if nargin < 4, rot = 0; end;

    if ~isempty(p)
        if isscalar(H), 
            Hd = H;      Hu = H;
        else
            Hd = H(1);   Hu = H(2);
        end;
        if rot, p = mod((p)-3*pi/4,pi)-pi/2;
        else    p = mod((p)+pi/2,pi)-pi/2; end;
        low = mod((p-Hd)+pi/2,pi)-pi/2;
        hig = mod((p+Hu)+pi/2,pi)-pi/2;
        mplX = sort([-pi/2,low,low,hig,hig,+pi/2]);
        mplY = [0,0,1,1,0,0];
        if low > hig, mplY = 1-mplY; end;
    end;

    xtk = linspace(-pi/2,pi/2,9);
    alpha = linspace(-pi/2,pi/2,size(D,2));

    if rot
        xlb = {'-\pi/4','','0.0','','\pi/4','','\pm\pi/2','','-\pi/4'};
        D = circshift(D,[0,round(-size(D,2)/4)]);
    else
        xlb = {'-\pi/2','','-\pi/4','','0.0','','\pi/4','','\pi/2'};
    end;    
    
    if nargin < 5
        plot(alpha,D(1,:),'linewidth',1.2);
        hold on  
    else
        if rot, BG = circshift(BG,[0,round(-size(D,2)/4)]); end;
        imagesc(alpha,0:1.011*max(D(:)),BG);
        colormap (1-gray);
        axis xy, hold on  
        plot(alpha,D(1,:),'linewidth',1.2);        
    end;
    for dd = 2:size(D,1)
        plot(alpha,D(dd,:));
    end;
    if ~isempty(p)
        plot([p,p],[0,1.01]*max(D(:)),'g','linewidth',1.2);
        plot(mplX,mplY*1.01*max(D(:)),'r','linewidth',1.2);
    end;
    hold off
    
    xlim([-pi/2,pi/2]);
    set(gca,'xtick',xtk);
    set(gca,'xticklabel',xlb);
    xlabel('\alpha'); ylabel('Contribution to |X|');
    grid on

    if (nargout > 0)||(nargin > 4)
        ybg = 0:1.011*max(D(:));
    end
    
end

