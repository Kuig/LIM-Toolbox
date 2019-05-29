function [BEerrs, timing, ia] = test_sobi(y, mixMatrix)
% This script is called by the main test script to test SOBI

    tic
    try
        [Mfi] = sobi(y.');
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