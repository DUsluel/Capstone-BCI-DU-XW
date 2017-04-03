clear;close all;clc;
% BCL Competition Data Set 4/sub1 
load('sub1_comp.mat');
%Plotting Finger Movements
fingers = cellstr(['thumb '; 'index '; 'middle'; 'ring  '; 'little']); %Plot of 37ms and normalized Finger Positions
figure
for n = 1:5
    subplot(5,1,n);plot(train_dg(:,n));ylabel(fingers(n));
end
%% Checking the frequency profile of data
Fs = 1000;
e1Train = train_data(:,1);%obtaining single electrode data
%tn = (0:length(e1Train)-1)/Fs;
tn = linspace(0,399,400000)';
%assuming measurment in uV
%e1Train = e1Train/10^6;
figure; plot(tn(1:10000), e1Train(1:10000));title('First 10 seconds of ECoG');
xlabel('time (s)');

%% fourier transform
fe1Train = fft(e1Train);
fSpec = linspace(0,1000,200000)';%frequency spectrum   
invF = 1./fSpec;%expected frequency profile

invF(1) = (1/(fSpec(2)/2))*100;%removing infinity
figure;plot(fSpec,abs(fe1Train(1:200000)));
figure;semilogy(fSpec,invF);%axis([-100 1100 -1000 41*10^4]);


%% Bandpass Filtering Trial
%% Butterworth
butter = designfilt('bandpassiir','StopbandFrequency1',3,'PassbandFrequency1',4,'PassbandFrequency2',250,...
    'StopbandFrequency2',255,'StopbandAttenuation1',80,'StopbandAttenuation2',60,'SampleRate',1000);
[butH,butW] = freqz(butter,20000);
figure;plot(butW/pi,20*log10(abs(butH)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)');title('Butterworth');
fvtool(butter);
%% Chebyshevs 1
cheby1 = designfilt('bandpassiir','DesignMethod','cheby1','StopbandFrequency1',3,'PassbandFrequency1',4,'PassbandFrequency2',250,...
    'StopbandFrequency2',255,'StopbandAttenuation1',80,'StopbandAttenuation2',60,'SampleRate',1000);
[che1H,che1W] = freqz(cheby1,20000);
figure;plot(che1W/pi,20*log10(abs(che1H)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)');title('Chebyshevs I');
fvtool(cheby1);
%% Chebyshevs 2
cheby2 = designfilt('bandpassiir','DesignMethod','cheby2','StopbandFrequency1',3,'PassbandFrequency1',4,'PassbandFrequency2',250,...
    'StopbandFrequency2',255,'StopbandAttenuation1',80,'StopbandAttenuation2',60,'SampleRate',1000);
[che2H,che2W] = freqz(cheby2,20000);
figure;plot(che2W/pi,20*log10(abs(che2H)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)');title('Chebyshevs 2');
fvtool(cheby2);
%% Elliptic
ellip = designfilt('bandpassiir','DesignMethod','ellip','StopbandFrequency1',3,'PassbandFrequency1',4,'PassbandFrequency2',250,...
    'StopbandFrequency2',255,'StopbandAttenuation1',80,'StopbandAttenuation2',60,'SampleRate',1000);
[elpH,elpW] = freqz(ellip,20000);
figure;plot(elpW/pi,20*log10(abs(elpH)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)');title('Elliptic');
fvtool(ellip);
%% Notch/bandstop IIR
notch50 = designfilt('bandstopiir','FilterOrder',20,'HalfPowerFrequency1',49.6,...
    'HalfPowerFrequency2',50.4,'SampleRate',1000);
[nocH,nocW] = freqz(notch50,20000);
figure;plot(nocW/pi,20*log10(abs(nocH)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)');title('Notch 50');
fvtool(notch50);
%% High-Low Pass
hPass = designfilt('highpassiir','FilterOrder',8,'PassBandFrequency',4,'SampleRate',1000);
[hpH,hpW] = freqz(hPass,20000);figure;plot(hpW/pi,20*log10(abs(hpH)));%axis([-450 10 0 1.1]);
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)');title('High Pass');
lPass = designfilt('lowpassiir','FilterOrder',8,'PassBandFrequency',250,'SampleRate',1000);
[lpH,lpW] = freqz(lPass,20000);figure;plot(lpW/pi,20*log10(abs(lpH)));%axis([-750 10 0 1.1]);
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)');title('Low Pass');
fvtool(hPass);fvtool(lPass);

%% Filtering results
%% Butterworth
filtbutt = filter(butter,e1Train);
filtfiltbutt = filtfilt(butter,e1Train);
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtbutt(1:10000));
xlabel('time(sec)');title('Butterworth IIR filter using "filter"');legend('original signal','Butterworth filtered');
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtfiltbutt(1:10000)');%filtfilt zero-phase filtering gives unexpected result
xlabel('time(sec)');title('Butterworth IIR filter using "filtfilt"');
% Compare Frequency Spectrum
fFilterbutt = fft(filtbutt);
figure;plot(fSpec,abs(fe1Train(1:200000))',fSpec,abs(fFilterbutt(1:200000))');
xlabel('Frequency(Hz)');title('Butterworth IIR filter using "filter"-Frequency Domain');
legend('original signal','Butterworth filtered');
%% Cheby 1
filtchby1 = filter(cheby1,e1Train);
filtfiltchby1 = filtfilt(cheby1,e1Train);
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtchby1(1:10000));
xlabel('time(sec)');title('Chebyshev1 IIR filter using "filter"');legend('original signal','Chebyshev1 filtered');
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtfiltchby1(1:10000)');%filtfilt zero-phase filtering gives unexpected result
xlabel('time(sec)');title('Chebyshev1 IIR filter using "filtfilt"');
% Compare Frequency Spectrum
fFilterchby1 = fft(filtchby1);
figure;plot(fSpec,abs(fe1Train(1:200000))',fSpec,abs(fFilterchby1(1:200000))');
xlabel('Frequency(Hz)');title('Chebyshev1 IIR filter using "filter"-Frequency Domain');
legend('original signal','Chebyshev1 filtered');
%% Cheby 2
filtchby2 = filter(cheby2,e1Train);
filtfiltchby2 = filtfilt(cheby2,e1Train);
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtchby2(1:10000));
xlabel('time(sec)');title('Chebyshev2 IIR filter using "filter"');legend('original signal','Chebyshev2 filtered');
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtfiltchby2(1:10000)');%filtfilt zero-phase filtering gives unexpected result
xlabel('time(sec)');title('Chebyshev2 IIR filter using "filtfilt"');
% Compare Frequency Spectrum
fFilterchby2 = fft(filtchby2);
figure;plot(fSpec,abs(fe1Train(1:200000))',fSpec,abs(fFilterchby2(1:200000))');
xlabel('Frequency(Hz)');title('Chebyshev2 IIR filter using "filter"-Frequency Domain');
legend('original signal','Chebyshev2 filtered');

%% Ellip
filtellip = filter(ellip,e1Train);
filtfiltellip = filtfilt(ellip,e1Train);
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtellip(1:10000));
xlabel('time(sec)');title('Elliptic IIR filter using "filter"');legend('original signal','Elliptic filtered');
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtfiltellip(1:10000)');%filtfilt zero-phase filtering gives unexpected result
xlabel('time(sec)');title('Elliptic IIR filter using "filtfilt"');
% Compare Frequency Spectrum
fFilterellip = fft(filtellip);
figure;plot(fSpec,abs(fe1Train(1:200000))',fSpec,abs(fFilterellip(1:200000))');
xlabel('Frequency(Hz)');title('Elliptic IIR filter using "filter"-Frequency Domain');
legend('original signal','Elliptic filtered');

%% Notch
filtnoc = filter(notch50,e1Train);
filtfiltnoc = filtfilt(notch50,e1Train);
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtnoc(1:10000));
xlabel('time(sec)');title('Notch IIR filter using "filter"');legend('original signal','Notch filtered');
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtfiltnoc(1:10000)');
xlabel('time(sec)');title('Notch IIR filter using "filtfilt"');
% Compare Frequency Spectrum
fFilternoc = fft(filtnoc);
figure;plot(fSpec,abs(fe1Train(1:200000))',fSpec,abs(fFilternoc(1:200000))');
xlabel('Frequency(Hz)');title('Notch IIR filter using "filter"-Frequency Domain');
legend('original signal','Notch filtered');

%% High-Low Pass
filtHP = filter(lPass,filter(hPass,e1Train));
filtfiltHP = filtfilt(lPass,filtfilt(hPass,e1Train));
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtHP(1:10000));
xlabel('time(sec)');title('High-Low Pass IIR filter using "filter"');legend('original signal','Notch filtered');
figure;plot(tn(1:10000),e1Train(1:10000),tn(1:10000),filtfiltHP(1:10000)');
xlabel('time(sec)');title('High-Low Pass IIR filter using "filtfilt"');
% Compare Frequency Spectrum
fFilterHP = fft(filtHP);
figure;plot(fSpec,abs(fe1Train(1:200000))',fSpec,abs(fFilterHP(1:200000))');
xlabel('Frequency(Hz)');title('High-Low Pass IIR filter using "filter"-Frequency Domain');
legend('original signal','High-Low Pass filtered');