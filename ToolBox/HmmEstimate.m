%hidden states A, B 
%trans A-A 0.95, A-B 0.05
%trans B-B 0.9, B-A 0.1

%oberavation data a,b,c
%A:  -a 0.5,-b-c 0.25
%B:  -a-b-c  0.33
trans = [0.95,0.05;
         0.10,0.90];
emis = [1/2,1/4,1/4;
   1/3,1/3,1/3 ];

[seq,states] = hmmgenerate(100,trans,emis);
hold off;
plot(seq,'r*-');
hold on;
plot(0,0);
plot(states,'go-');
[estimateTR,estimateE] = hmmestimate(seq,states)

%[estimateTR,estimateE] = hmmestimate(data,data);
close all;
figure;
t = data;
vc=t;
%fix points
%Find the five points where the mean of the signal changes most significantly.
%findchangepts(t,'MaxNumChanges',20)
%Find the five points where the root-mean-square level of the signal changes most significantly.
%findchangepts(t,'MaxNumChanges',5,'Statistic','rms')
%Find the point where the mean and standard deviation of the signal change the most.
%findchangepts(t,'Statistic','std')
%find points
%Find the points where the signal mean changes most significantly. The 'Statistic' name-value pair is optional in this case. Specify a minimum residual error improvement of 1.
findchangepts(vc,'Statistic','mean','MinThreshold',1550)
%Find the points where the root-mean-square level of the signal changes the most. Specify a minimum residual error improvement of 6.
%findchangepts(vc,'Statistic','rms','MinThreshold',1)
%findchangepts(vc,'Statistic','std','MinThreshold',1050)