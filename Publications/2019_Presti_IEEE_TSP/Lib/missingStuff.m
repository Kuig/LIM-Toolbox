function m = missingStuff()

    m = 0;
    try
        [ ~ ] = BMS( [0,0;0,0], [0,0;0,0], 0 );
    catch
        disp(' - LIM Toolbox not found (https://github.com/Kuig/LIM-Toolbox)');
        m = m+1;
    end
    
    try
        [ ~ ] = bss_eval_mix( [1,0;0,1], [1,0;0,1] );
    catch
        disp(' - BSS_Eval not found (http://bass-db.gforge.inria.fr/bss_eval/)');
        m = m+1;
    end

end