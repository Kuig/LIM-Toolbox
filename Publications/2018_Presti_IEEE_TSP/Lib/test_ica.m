function [BEerrs, timing, ia, nOfIters] = test_ica(y, mixMatrix)
% This script is called by the main test script to test FastICA

    tic
    try
        [~, Mfi, ~, nOfIters] = fastica_IC (y.','verbose', 'off');
    catch
        Mfi = [];
        nOfIters = [1000,0];
    end
    timing = toc;
    nOfIters = sum(nOfIters);
    if numel(Mfi)<3
        ia = [NaN, NaN];
        BEerrs = NaN;
    else
        [Mfi, ia] = fixangles(Mfi);
        [MER, ~] = bss_eval_mix(Mfi,mixMatrix);
        BEerrs = mean(MER);
    end
end