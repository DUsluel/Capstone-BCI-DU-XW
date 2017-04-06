function [moveIndice] = fingerMovingIndex_new( movement,Fs,fig )
    % fingermovingindex: Takes the signal of finger movements and returns the 
    % start and end indexes of when the finger is moving.
    
    % Decision on the period of finger movement based on derivative of 
    % movement data.
    mDerv = [0; abs(diff(movement))];

    % parameters:
    derv_threshold_min = 0.2;
    derv_threshold_decision = 1;
    test_width = 500;
    tolerance_width = 100; 
    
    new_move = 1;
    n_check = 1;
    i = 1;
    for n = 1:length(mDerv)
        if (new_move == 1) && (mDerv(n) > derv_threshold_min)
            n_start = n;
            new_move = 0;
        end
        if new_move == 0 
            if mDerv(n) > derv_threshold_min
                n_check = n;
            end
            if n-n_check > test_width
                n_end = n_check;
                if max(mDerv(n_start:n_end)) > derv_threshold_decision
                    moveIndice(:,i) = [n_start-tolerance_width n_end]; 
                    i = i+1;
                end
                new_move = 1;
            end
        end        
    end
    
    if fig == 1
        % plot finger movement periods against movement data for evaluation
        figure;
        plot(movement);hold on;
        plot(mDerv,'g');
        moveplot = zeros(length(movement),1);
        for k = 1:length(moveIndice(1,:))
            moveplot(moveIndice(1,k):moveIndice(2,k))=1;
        end
        plot(moveplot,'r');        
        
        % plot individual finger movement periods 
        figure;
        t = (0:length(movement)-1)/Fs;
        for n = 1:length(moveIndice(1,:))
            r = length(moveIndice(1,:))/4;
            if (round(r)>=r)
                subplot(round(r),4,n);
            else
                subplot(ceil(r),4,n);
            end
            interval = moveIndice(1,n):moveIndice(2,n);
            plot(t(interval),movement(interval));
            axis('auto');
        end
    end
    
end

