function stats(scores, timing, nOfTest)
% This script is called by the main test script to report experiment stats

    clc

    statsPair([scores(:,1),scores(:,3)], [timing(:,1),timing(:,3)], nOfTest, 'SOBI');
    statsPair([scores(:,2),scores(:,3)], [timing(:,2),timing(:,3)], nOfTest, 'FastICA');

end

function statsPair(scores, timing, nOfTest, icaAlg)
    scorediff = diff(scores,1,2);
    smean = mean(scorediff,'omitnan');
    ssd = std(scorediff,'omitnan');
    switch sign(smean)
        case -1
            winner = ['(',icaAlg,' seems better)'];
        case +1
            winner = '(BMS seems better)';
        otherwise
            winner = '';
    end
    disp(['Mean of MER difference: ',num2str(smean),' dB ', winner]);
    disp(['SD of MER difference: ',num2str(ssd),' dB']);
    
    % t-test
    [h, p] = ttest(scores(:,1),scores(:,2));
    if h
        disp('MER scores may be significantly different!');
    else
        disp('MER scores are not significantly different');
    end
    disp(['p-value: ',num2str(p)]);
    fprintf('\n');

    empt = diff(timing,1,2)>0;

    fprintf(['\n',icaAlg,' empirically faster %d times (%.2f%%)\n'],sum(empt),100*sum(empt)/nOfTest);
    
    % Mann–Whitney U test
    Tdiff = diff(timing,1,2);
    Tmedian = median(Tdiff,'omitnan');
    switch sign(Tmedian)
        case -1
            winner = '(BMS seems faster)';
        case +1
            winner = ['(',icaAlg,' seems faster)'];
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
