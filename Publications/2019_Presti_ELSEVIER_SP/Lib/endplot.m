function [] = endplot (BEerrs, timing, len, nOfTest, sr, savePlots)
% This script is called by the main test script to plot final results

%     figure
%     BEdiff = diff(BEerrs,1,2);
%     histogram(BEdiff);
%     grid on; 
%     ylabel('Tasks count');
%     xlabel('\Delta MER (dB)');
%     xlim([-60,60]);
%     title({'Distribution of SOBI and BMS-ICA delta mean MER','(positive scores mean better BMS performance)'});
%             fig=gcf;
%             set(findall(fig,'-property','FontName'),'FontName','Consolas')
%             set(findall(fig,'-property','FontSize'),'FontSize',12)
%             set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
%             set(gca,'Linewidth',1.2);
% 
%     if savePlots, print('DMER_H.pdf','-dpdf'); end

    figure
    boxplot(timing(:)./[len;len],[zeros(nOfTest,1);ones(nOfTest,1)]); hold on;
    hold off;
    grid on; 
    set(gca,'xticklabel',{'SOBI','BMS-ICA'});
    ylabel('Computing time (sec)');
    title(['Average time needed to process ', num2str(sr), ' samples']);
            fig=gcf;
            set(findall(fig,'-property','FontName'),'FontName','Consolas')
            set(findall(fig,'-property','FontSize'),'FontSize',12)
            set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
            set(gca,'Linewidth',1.2);

    if savePlots, print('Time_BP.pdf','-dpdf'); end

    figure;
    boxplot(BEerrs(:),[zeros(nOfTest,1);ones(nOfTest,1)]); hold on
    plot (mean(BEerrs,'omitnan'),'.m'); hold off
    grid on; 
    set(gca,'xticklabel',{'SOBI','BMS-ICA'});
    ylabel('MER (dB)');
    title('Average MER');
            fig=gcf;
            set(findall(fig,'-property','FontName'),'FontName','Consolas')
            set(findall(fig,'-property','FontSize'),'FontSize',12)
            set(findall(fig,'-property','FontWeight'),'FontWeight','Bold')
            set(gca,'Linewidth',1.2);

    if savePlots, print('MER_BP.pdf','-dpdf'); end
end