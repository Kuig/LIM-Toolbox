function [BEerrs, timing, ba] = test_bms (y, mixMatrix, sets)
% This script is called by the main test script to test ICA by BMS

    tic
    [~, Mib, ~, ba, ~, ~] = icabybms(y,...
                                'resolution', sets.resolution,...
                                'refineMode',sets.refineMode,...
                                'corrWeight',sets.corrWeight,...
                                'smoothing',sets.smoothing,...
                                'ampExp',sets.ampExp,...
                                'whitening',sets.whitening);
                            
    timing = toc;
    if numel(ba)<2
        ba = [NaN, NaN];
        BEerrs(tst,2) = NaN;
    else
        [MER, ~] = bss_eval_mix(Mib,mixMatrix);
        BEerrs = mean(MER);
    end
end