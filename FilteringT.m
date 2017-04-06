function [Res, FRes] = FilteringT(input, time, Fs, type, fig)
%This function takes an input signal, the signals time information,
%sampling frequency, desired type of filtering (cheby2 bandpass 4-250Hz 
%or notch 60Hz), and a choice of printing two sets of figures:
%   (10 for only the filter property graphs)
%   (01 for only the filtering result graphs)
%   (11 for both)
    %% Filter Creation
    if type == 'notch'
        Filt = designfilt('bandstopiir','FilterOrder',20,'HalfPowerFrequency1',59.6,...
            'HalfPowerFrequency2',60.4,'SampleRate',Fs);
    elseif type == 'cheb2'
        Filt = designfilt('bandpassiir','DesignMethod','cheby2','StopbandFrequency1',3,'PassbandFrequency1',4,'PassbandFrequency2',250,...
            'StopbandFrequency2',255,'StopbandAttenuation1',80,'StopbandAttenuation2',60,'SampleRate',Fs);
    end
    %% Conditional Filter Parameter plotting
    if (fig == 10 || fig == 11) 
        [H,W] = freqz(Filt,20000);
        figure;plot(W/pi,20*log10(abs(H)))
        xlabel('Normalized Frequency (\times\pi rad/sample)')
        ylabel('Magnitude (dB)');title('Notch 50');
        fvtool(Filt);
    end
    %% Symmetric Padding
    if rem(length(input),2) == 0
        in1 = input((length(input)/2):-1:2);
        in2 = input((end-1):-1:(length(input)/2));
    else
        ins = sort(input);inis = find(ins == median(ins));
        in1 = input(inis:-1:2);
        in2 = input((end-1):-1:inis);
    end
    padIn = [in1' input' in2']';
    %% Filtering
    padRes = filtfilt(Filt,padIn);
    Res = padRes((length(in1)+1):(length(in1)+length(input)));%Removing padded values
    [FRes,f] = pwelch(Res,512,256,[1:250],Fs);
    %% Conditional Plotting of the result
    if (fig == 01 || fig == 11) 
        figure;plot(time,input,time,Res);xlabel('time (in seconds)');
        title(['Signal versus Time before/after filtering '  type]);
        FSpec = linspace(0,Fs,length(FRes));
        figure;plot(FSpec,abs(pwelch(input,512,256,[1:250],Fs)),FSpec, abs(FRes));xlabel('Frequency');
        title(['Signal PSD versus Frequency after filtering ' type]);
    end
end
    
    
