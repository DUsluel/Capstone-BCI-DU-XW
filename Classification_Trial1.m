clear;close all;clc;
% BCL Competition Data Set 4/sub1 
load('sub1_comp.mat');
% %Plotting Finger Movements
% fingers = cellstr(['thumb '; 'index '; 'middle'; 'ring  '; 'little']); %Plot of 37ms and normalized Finger Positions
% figure
% for n = 1:5
%     subplot(5,1,n);plot(train_dg(:,n));ylabel(fingers(n));
% end
%% Filtering 
% Filtering the signal from the first electrode with a Chebyshev2 Bandpass 
% filter with a 4-250Hz pass-band and a 60Hz Notching filter
Fs = 1000; tn = linspace(0,399.999,400000)';
e1 = train_data(:,1);
% [e1Band,e1FBand] = FilteringT(e1,tn,Fs,'cheb2',01);%Bandpass Filtering with plots
% [e1Band_Notch, e1FBand_Notch] = FilteringT(e1Band,tn,Fs,'notch',01);%Notch Filtering with plots
[e1Notch,e1FNotch] = FilteringT(e1,tn,Fs,'notch',01);%Notch Filtering with plots
[e1Notch_Band, e1FNotch_Band] = FilteringT(e1Notch,tn,Fs,'cheb2',01);%Bandpass Filtering with plots
%% Removing Finger Delay (37ms)
fingers_nodel = [train_dg(37:end,:); train_dg((end-35):end,:)];
%% Obtaining the moving and resting regions of the hand
fing1 = fingers_nodel(:,1);fing2 = fingers_nodel(:,2);
movingIndices1 = fingerMovingIndex(fing1,Fs,1);
movingIndices2 = fingerMovingIndex(fing2,Fs,1);
fing1_move = fingers_nodel(movingIndices1);
fing1_moveAvg = mean(fing1_move,2);


% %% s
% load('sub1_comp.mat');
% fingers_nodel = [train_dg(37:end,:); train_dg((end-35):end,:)];
% fing1 = fingers_nodel(:,1);
% 
% derv = [0; abs(diff(fing1))];
% dt = 1; %time window size in seconds
% plot(derv); hold on;
% 
% movwindow = 3001;
% pad = [zeros((movwindow-1)/2,1); derv; zeros((movwindow-1)/2,1)];
% movAvg = zeros(size(fing1));
% for i = 1:length(fing1)
%     movAvg(i,1) = mean(pad(i:i+movwindow-1));
% end
% plot(fing1);hold on; plot(movAvg.*100);