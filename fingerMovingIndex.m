function [move,moveIndice] = fingerMovingIndex( movement,Fs,fig,fingerNo)
    %fingermovingindex: Takes the signal of finger movements and returns the indexes
    %where the finger is moving
    %   The points where the finger is moving is returned as 1 and the points
    %   where the finger is at rest is returned as 0 in the MoveIndices array.
    mDerv = [0; abs(diff(movement))];
    t = linspace(0,(size(movement,1)/Fs)-(1/Fs),size(movement,1));
    dt = 1; %time window size in seconds
    m=1;
    for n = 1:dt*Fs:length(mDerv)
        dervAvg(:,m) = mean(mDerv(n:(n+(dt*Fs)-1)));
        m = m+1;
    end
    [peakMag,peakInd] = findpeaks(dervAvg);
    moveSelect = dervAvg(peakInd) >= mean(peakMag);
    peakInd = peakInd.*moveSelect; peakInd = peakInd(peakInd~=0);
    tw = 4; %time window around the finger movements in seconds
    for n = 1:length(peakInd)
        peakix = peakInd(n)*Fs;
        moveIndice(:,n) = peakix-Fs*(tw/2):peakix+Fs*(tw/2);
        move(:,n) = movement(peakix-Fs*(tw/2):peakix+Fs*(tw/2));
    end
    if fig == 1
        figure;
        for n = 1:length(peakInd)
            r = length(peakInd)/4;
            if (round(r)>=r)
                subplot(round(r),4,n);
            else
                subplot(ceil(r),4,n);
            end
            plot(t(moveIndice(:,n)),movement(moveIndice(:,n)));
            axis('auto');
        end; suptitle(['Finger Movements for finger' fingerNo]);
    end
end

