function [] = endplot (BEerrs, timing, len, nOfIters, nOfTest, sr, savePlots)
% This script is called by the main test script to plot final results

    figure
    BEdiff = diff(BEerrs,1,2);
    histogram(BEdiff);
    grid on; 
    ylabel('Tasks count');
    xlabel('\Delta MER (dB)');
    xlim([-60,60]);
    title('Distribution of the difference between FastICA and BMS-ICA mean MER');
            fig=gcf;
            set(findall(fig,'-property','FontName'),'FontName','Consolas')
            set(findall(fig,'-property','FontSize'),'FontSize',12)
            set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
            set(gca,'Linewidth',1.2);

    if savePlots, print('DMER_H.pdf','-dpdf'); end


    figure
    boxplot(timing(:)./[len;len],[zeros(nOfTest,1);ones(nOfTest,1)]); hold on;
    plot(1,0.078,'^r','MarkerFaceColor','r'); hold off;
    grid on; 
    set(gca,'xticklabel',{'FastICA','BMS-ICA'});
    ylabel('Computing time (sec)');
    title(['Average time needed to process ', num2str(sr), ' samples']);
    set(gca,'ylim',[0, 0.08]);
            fig=gcf;
            set(findall(fig,'-property','FontName'),'FontName','Consolas')
            set(findall(fig,'-property','FontSize'),'FontSize',12)
            set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
            set(gca,'Linewidth',1.2);

    if savePlots, print('Time_BP.pdf','-dpdf'); end


    figure
    empt = diff(timing,1,2)>0;
    bns = [5:15, inf];
    histogram(nOfIters,bns); hold on
    histogram(nOfIters(empt),bns); hold off
    grid on; 
    ylabel('Tasks count'); xlabel('Iterations');
    title('Distribution of FastICA iterations');
    set(gca,'xtick',[bns(1:end-1), bns(end)+1]);
    legend('BMS-ICA is faster','FadtICA is faster');
            fig=gcf;
            set(findall(fig,'-property','FontName'),'FontName','Consolas')
            set(findall(fig,'-property','FontSize'),'FontSize',12)
            set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
            set(gca,'Linewidth',1.2);

    if savePlots, print('Iters_H.pdf','-dpdf'); end

    figure;
    boxplot(BEerrs(:),[zeros(nOfTest,1);ones(nOfTest,1)]); hold on
    plot (mean(BEerrs,'omitnan'),'.m'); hold off
    grid on; 
    set(gca,'xticklabel',{'FastICA','BMS-ICA'});
    ylabel('MER (dB)');
    title('Average MER');
            fig=gcf;
            set(findall(fig,'-property','FontName'),'FontName','Consolas')
            set(findall(fig,'-property','FontSize'),'FontSize',12)
            set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
            set(gca,'Linewidth',1.2);

    if savePlots, print('MER_BP.pdf','-dpdf'); end
end