function [x,A,B] = gensample(len, sr, skipThres)
% This script is called by the main test script to get a random mixture

    src = { 'perc', 'bell', 'pads', 'noise' };
    
    searchingSample = true;
    while searchingSample
        uid = randperm(3,2);

        [ ~, U ] = getSampleAudio( len, sr, 1, src );

        A = src{uid(1)};
        B = src{uid(2)};

        x(:,1) = 2 * U(:,uid(1)) + U(:,4);
        x(:,2) = 2 * U(:,uid(2)) + U(:,4);
        
        rmsAB = rms(x);
        searchingSample = any(rmsAB<skipThres) || any(isnan(rmsAB));
    end
end