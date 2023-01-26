function [BEerrs, timing, ia] = test_ica(y, mixMatrix)
% This script is called by the main test script to test FastICA
    
    tic
    try
        [~, Mfi, ~] = fastica (y.','verbose', 'off');
    catch
        Mfi = [];
    end
    timing = toc;
    if numel(Mfi)<3
        ia = [NaN, NaN];
        BEerrs = NaN;
    else
        [Mfi, ia] = fixangles(Mfi);
        [MER, ~] = bss_eval_mix(Mfi,mixMatrix);
        BEerrs = mean(MER);
    end
end