function [BEerrs, timing, ba] = test_bms (y, reso, mixMatrix)
% This script is called by the main test script to test ICA by BMS

    tic
    [~, Mib, ~, ba, ~, ~] = icabybms(y,...
                                'resolution', reso,...
                                'refineMode','top5',...
                                'corrWeight',0.5,...
                                'smoothing',pi/180,...
                                'ampExp',1,...
                                'whitening','on');
    timing = toc;
    if numel(ba)<2
        ba = [NaN, NaN];
        BEerrs(tst,2) = NaN;
    else
        [MER, ~] = bss_eval_mix(Mib,mixMatrix);
        BEerrs = mean(MER);
    end
end