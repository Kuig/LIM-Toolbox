function [] = testplot(results,tst,y,angles)
    clf
    ia = [results{tst,1}];
    ba = [results{tst,2}];
    bb = linspace(-1,1,512);
    [pic, picx, picy] = histcounts2(y(:,1),y(:,2),bb,bb);
    imagesc(picx,picy,pic.'.^0.5), hold on
    colormap(1-gray);
    p(1) = plot([0,cos(angles(tst,1))],[0,sin(angles(tst,1))],'o-b');
           plot([0,cos(angles(tst,2))],[0,sin(angles(tst,2))],'o-b');
    p(2) = plot([0,cos(ia(1))],[0,sin(ia(1))],'+-r');
           plot([0,cos(ia(2))],[0,sin(ia(2))],'+-r');
    p(3) = plot([0,cos(ba(1))],[0,sin(ba(1))],'*-m');
           plot([0,cos(ba(2))],[0,sin(ba(2))],'*-m');


    hold off;
    legend(p,'Ground truth','Fixed SOBI','BMS-ICA');
    lim = 1.25;
    xlim([-lim,lim]);
    ylim([-lim,lim]);
    grid on
    axis equal
    box on
    title('Example of bivariate distribution with inferred Independent Components')

    fig=gcf;
    set(findall(fig,'-property','FontName'),'FontName','Consolas')
    set(findall(fig,'-property','FontSize'),'FontSize',12)
    set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
    set(gca,'Linewidth',1.2);
    print(['.\plots\',num2str(tst),'_SP.pdf'],'-dpdf');
end