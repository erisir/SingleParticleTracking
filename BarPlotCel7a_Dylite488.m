%median,median;mean,mean,mean,mean,ean,mean
%Dylite experiment from 20200519_[0,2,10,20nM]Cel7a_NaOH_ABCellulose_Good£¬20210313_2nMCel7aDylite£¬20210319_[2,5nM]Cel7aDylite-AF
Qdot2nMwoAF = [3.24,38.6,20.3,165.7,89,65.9,84,3.4];%Zach's paper

Qdot2nMwAF = [4.38,27.86,13.35,52.49,59.04,20.94,30.24,4.13];
Qdot2nMwAF_GO = [3.77,46.42,22,57.50,40.39,13.76,10,10];
Dylite2nMwoAF = [9.29,102.97,14.1,46.01,52.28,21.4,29.23,5.27];

Dylite5nMwAF = [9.33,67.34,8.05,18.30,24.34,10.9,7.49,5.66];

Dylite5nMwAFRepeat = [8.61,69.61,8.45,16.67,26.04,9.92,6.46,7.3];

allQdot = [Qdot2nMwoAF;Qdot2nMwAF;Qdot2nMwAF_GO]';
all = [Qdot2nMwoAF;Qdot2nMwAF;Dylite2nMwoAF;Dylite5nMwAF;Dylite5nMwAFRepeat]';
cmp = [all(:,1:3),mean(all(:,4:5),2)];
%h = bar([cmp(2:2,:);cmp(2:2,:)]);
%h = bar(cmp(3:7,:));
bar(allQdot(1:7,:))
legend(["Qdot-woAF";"Qdot-wAF-All";"dylite-wAF-GO"]);
%legend(["Qdot-woAF";"Qdot-wAF";"dylite-woAF";"dylite-wAF"]);