function [] = endplot (BEerrs, timing, len, nOfTest, sr, savePlots)
% This script is called by the main test script to plot final results

    figure
    boxplot(timing(:)./[len;len;len],[zeros(nOfTest,1);ones(nOfTest,1);ones(nOfTest,1)*2]); hold on;
    hold off;
    grid on; 
    set(gca,'xticklabel',{'SOBI','FastICA','BMS-ICA'});
    ylabel('Computing time (sec)');
    title(['Average time needed to process ', num2str(sr), ' samples']);
            fig=gcf;
            set(findall(fig,'-property','FontName'),'FontName','Consolas')
            set(findall(fig,'-property','FontSize'),'FontSize',12)
            set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
            set(gca,'Linewidth',1.2);

    if savePlots, print('Time_BP.pdf','-dpdf'); end

    figure;
    boxplot(BEerrs(:),[zeros(nOfTest,1);ones(nOfTest,1);ones(nOfTest,1)*2]); hold on
    plot (mean(BEerrs,'omitnan'),'.m'); hold off
    grid on; 
    set(gca,'xticklabel',{'SOBI','FastICA','BMS-ICA'});
    ylabel('MER (dB)');
    title('Average MER');
            fig=gcf;
            set(findall(fig,'-property','FontName'),'FontName','Consolas')
            set(findall(fig,'-property','FontSize'),'FontSize',12)
            set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
            set(gca,'Linewidth',1.2);

    if savePlots, print('MER_BP.pdf','-dpdf'); end
end