function [x,A,B] = loadsample(dataPath, flist, len, skipThres)
% This script is called by the main test script to get a mixture from the dataset

    nfiles    = length(flist);
    searchingSample = true;
    while searchingSample
        filesToMix = randperm(nfiles,2);
        A = flist(filesToMix(1)).name;
        B = flist(filesToMix(2)).name;

        slen = ceil(len);

        tmp = audioread([dataPath,A]);
        x(:,1) = conform(tmp,slen);
        tmp = audioread([dataPath,B]);
        x(:,2) = conform(tmp,slen);
        
        rmsAB = rms(x);
        searchingSample = any(rmsAB<skipThres);
    end
end