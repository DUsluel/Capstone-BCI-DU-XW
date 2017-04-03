function [SINFin, FSin, t, Fs] = sinCreater(hz1, hz2, hz3, Fs)
    %This function creates a signal containing three sine waves added
    %together at different frequencies. The deswired frequencies and the
    %sampling rate are given as the input. The output contains the final
    %signal, the fourier transform of the signal, the time matrix which
    %always consists of 1001 elements and the sampling frequency.
    close all;
    dt = 1/Fs;
    sT = ((10^3)+1)*dt;
    t = (0:dt:sT-dt);
    magList = [10 100 200 500 1000];
    for n = 1:3
        r = 0;
        while (r<=9 || r >= 1001)
            r = rand*magList(randi([1 5]));
        end
        amp(n) = r;
    end
    % Sign waves
    s1 = amp(1)*sin(2*pi*hz1*t);
    s2 = amp(2)*sin(2*pi*hz2*t);
    s3 = amp(3)*sin(2*pi*hz3*t);
    %Adding sign waves
    SINFin = s1+s2+s3;
    figure;plot(t,SINFin);xlabel('time (in seconds)');
    title('Signal versus Time');
    % Fourier Analysis
    FSin = fft(SINFin);
    FSpec = linspace(0,Fs,length(t));
    figure;plot(FSpec, abs(FSin));xlabel('Frequency');
    title('Signal versus Frequency');
end
 