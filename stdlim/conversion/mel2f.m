function f = mel2f(mel)
    f=700*( ( 10.^(mel/2595) )-1 );
end

