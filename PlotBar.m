Dylite = [9.29,102.97,14.1,26.53,34.57,13.58,22.04,5.27];
Qdot = [3.24,38.6,20.3,165.7,89,65.9,84.1,3.85];
all =[Dylite;Qdot];
all = all';
bar(all)
legend(["Dylight488";"Qdot525"]);