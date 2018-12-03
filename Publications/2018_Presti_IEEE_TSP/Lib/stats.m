function stats(BEerrs, timing, nOfIters, nOfTest)
% This script is called by the main test script to report experiment stats

    clc
    empt = diff(timing,1,2)>0;

    fprintf('FastICA empirically faster %d times (%.2f%%)\n',sum(empt),100*sum(empt)/nOfTest);
    fprintf('Mean and SD of number of iterations: %.2f (%.2f)\n\n',mean(nOfIters(empt)),std(nOfIters(empt)));

    dnc = sum(isnan(BEerrs(:,1)));
    dnb = sum(isnan(BEerrs(:,2)));
    fprintf('FastICA did not converged %d times over %d tests (%.2f%%)\n',dnc,nOfTest,100*dnc/nOfTest);
    fprintf('ICA-BMS only found 1 source %d times over %d tests (%.2f%%)\n\n',dnb,nOfTest,100*dnb/nOfTest);

    BEdiff = diff(BEerrs,1,2);
    BEerrsmean = mean(BEdiff,'omitnan');
    BEerrssd = std(BEdiff,'omitnan');
    disp(['Mean of mix error difference: ',num2str(BEerrsmean),' dB']);
    disp(['SD of mix error difference: ',num2str(BEerrssd),' dB']);
    
    % t-test
    [h, p] = ttest(BEerrs(1,:),BEerrs(2,:));
    if h
        disp('Errors are significantly different!');
    else
        disp('Errors are not significantly different');
    end
    disp(['p-value: ',num2str(p)]);
    fprintf('\n');

    % Mann–Whitney U test
    Tdiff = diff(timing,1,2);
    Tmedian = median(Tdiff,'omitnan');
    [p, h] = ranksum(timing(:,1),timing(:,2));
    disp(['Median of timing difference: ',num2str(Tmedian),' s']);
    if h
        disp('Speed is significantly different!');
    else
        disp('Speed is not significantly different');
    end
    disp(['p-value: ',num2str(p)]);
    fprintf('\n');

end
