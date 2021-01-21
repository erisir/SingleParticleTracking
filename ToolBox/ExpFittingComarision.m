%FitExp2AndPlot(dwell,10,5,1000,'Duration (sec)','Static for overall time (counts)');
%dwellBeforeJump = [dwellBeforeJump1,dwellBeforeJump2];
%dwellBeforeMove = [dwellBeforeMove1,dwellBeforeMove2];
%dwellBeforeStuck = [dwellBeforeStuck1,dwellBeforeStuck2];
%dwellOverAllMove = [dwellOverAllMove1,dwellOverAllMove2];
%dwellThatMove = [dwellThatMove1,dwellThatMove2];
%FitExp2AndPlot(dwell,10,5,1000,'Duration (sec)','Static for overall time (counts)',30);
%FitExp1AndPlot(dwellBeforeMove,10,5,1000,'Duration (sec)','Static before move (counts)',3);
figure;
subplot(2,6,1)
FitExp1AndPlot(bindDurationOfStuck1_1stHalf,10,10,1000,'Duration (sec)','Static over All 1st Half Exp1(counts)');%%%%%

subplot(2,6,7)
FitExp1AndPlot(bindDurationOfStuck1_2edHalf,10,10,1000,'Duration (sec)','Static over All 2ed Half Exp1(counts)');

subplot(2,6,2)
FitExp1AndPlot(bindDurationOfMoving_All1_1stHalf,10,10,1000,'Duration (sec)','Move over All 1st Half Exp1 (counts)');%%%%%
subplot(2,6,8)
FitExp1AndPlot(bindDurationOfMoving_All1_2edHalf,10,10,1000,'Duration (sec)','Move over All 2ed Half Exp2 (counts)');
subplot(2,6,3)
FitExp1AndPlot(bindDurationOfMoving_Moving1_1stHalf,10,2,150,'Duration (sec)','Moving fraction 1st Half Exp1 (counts)');%%%%%
subplot(2,6,9)
FitExp1AndPlot(bindDurationOfMoving_Moving1_2edHalf,10,2,150,'Duration (sec)','Moving fraction 2ed Half Exp2 (counts)');
subplot(2,6,4)
FitExp1AndPlot(bindDurationAll1_1stHalf,10,10,1000,'Duration (sec)','All Qdot over All 1st Half Exp1 (counts)');%%%%
subplot(2,6,10)
FitExp1AndPlot(bindDurationAll1_2edHalf,10,10,1000,'Duration (sec)','All Qdot over All 2ed Half Exp1 (counts)');
subplot(2,6,5)
FitExp1AndPlot(bindDurationOfStuckBeforeMove1_1stHalf,10,10,1000,'Duration (sec)','Static before move  1st Half Exp1 (counts)');%%%%%
subplot(2,6,11)
FitExp1AndPlot(bindDurationOfStuckBeforeMove1_2edHalf,10,10,1000,'Duration (sec)','Static before move 2ed Half Exp2 (counts)');
subplot(2,6,6)
FitExp1AndPlot(bindDurationOfMovingBeforeStuck1_1stHalf,10,5,200,'Duration (sec)','Move before Static  1st Half Exp1 (counts)');%%%%%
subplot(2,6,12)
FitExp1AndPlot(bindDurationOfMovingBeforeStuck1_2edHalf,10,2,150,'Duration (sec)','Move before Static  2ed Half Exp2 (counts)');