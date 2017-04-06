function [ restIndice ] = fingerRestingIndex_new( movement,moveIndice )
    % Opposite of fingerMovingIndex
    
    rest_start = 1;
    i = 1;
    for k = 1:length(moveIndice(1,:))
        restIndice(:,i) = [rest_start moveIndice(1,k)-1];
        rest_start = moveIndice(2,k)+1;
        i = i+1;
    end

end

