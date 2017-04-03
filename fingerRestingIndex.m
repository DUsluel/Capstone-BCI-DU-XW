function [ restIndice ] = fingerRestingIndex( movement,moveIndice )
    % Opposite of fingerMovingIndex
    for n = 1:size(moveIndice,2)
        movement(moveIndice(:,n)) = 0;
    end
    resting = (movement~=0);
    tw = 4; l = 1:length(movement);
    lrest = l'.*resting;
    restIndice= lrest(lrest~=0); 
end

