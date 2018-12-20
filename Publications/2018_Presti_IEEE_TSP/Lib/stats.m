function stats(scores, timing, nOfIters, nOfTest)
% This script is called by the main test script to report experiment stats

    clc
    empt = diff(timing,1,2)>0;

    fprintf('FastICA empirically faster %d times (%.2f%%)\n',sum(empt),100*sum(empt)/nOfTest);
    fprintf('Mean and SD of number of iterations: %.2f (%.2f)\n\n',mean(nOfIters(empt)),std(nOfIters(empt)));

    dnc = sum(isnan(scores(:,1)));
    dnb = sum(isnan(scores(:,2)));
    fprintf('FastICA did not converged %d times over %d tests (%.2f%%)\n',dnc,nOfTest,100*dnc/nOfTest);
    fprintf('ICA-BMS only found 1 source %d times over %d tests (%.2f%%)\n\n',dnb,nOfTest,100*dnb/nOfTest);

    scorediff = diff(scores,1,2);
    smean = mean(scorediff,'omitnan');
    ssd = std(scorediff,'omitnan');
    switch sign(smean)
        case -1
            winner = '(FastICA seems better)';
        case +1
            winner = '(BMS seems better)';
        otherwise
            winner = '';
    end
    disp(['Mean of MER difference: ',num2str(smean),' dB ', winner]);
    disp(['SD of MER difference: ',num2str(ssd),' dB']);
    
    % t-test
    [h, p] = ttest(scores(1,:),scores(2,:));
    if h
        disp('MER scores may be significantly different!');
    else
        disp('MER scores are not significantly different');
    end
    disp(['p-value: ',num2str(p)]);
    fprintf('\n');

    % Mann–Whitney U test
    Tdiff = diff(timing,1,2);
    Tmedian = median(Tdiff,'omitnan');
    switch sign(Tmedian)
        case -1
            winner = '(BMS seems faster)';
        case +1
            winner = '(FastICA seems faster)';
        otherwise
            winner = '';
    end
    [p, h] = ranksum(timing(:,1),timing(:,2));
    disp(['Median of timing difference: ',num2str(Tmedian),' s ', winner]);
    if h
        disp('Speed is significantly different!');
    else
        disp('Speed is not significantly different');
    end
    disp(['p-value: ',num2str(p)]);
    fprintf('\n');

end
