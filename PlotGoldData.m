collection = load('D:\Desktop\CellulaseInhibition\DescribeDataOf20201206And20210117_CombineDataSet.mat');
combineDataSet = collection.combineDataSet;
GoldData = cell(7,7);
for i = 1:7
    if i == 2
        combineDataSet{i}.processiveParticleDescribe{2} = combineDataSet{i}.processiveParticleDescribe{1};
        combineDataSet{i}.staticParticleDescribe{2} = combineDataSet{i}.staticParticleDescribe{1};
        combineDataSet{i}.stuckAndMoveParticleDescribe{2} = combineDataSet{i}.stuckAndMoveParticleDescribe{1};
        combineDataSet{i}.moveAndStuckParticleDescribe{2} = combineDataSet{i}.moveAndStuckParticleDescribe{1};
    end
    subplot(2,4,1);
    processiveParticleDescribe = combineDataSet{i}.processiveParticleDescribe;
    movingVelocity1 = [processiveParticleDescribe{1}.movingVelocity1,processiveParticleDescribe{2}.movingVelocity1];
    GoldData{i,1} = HistAndFit(movingVelocity1,'gauss1',[0,1,40],'Velocity(nm/s)');

    subplot(2,4,2);
    runLength1 = [processiveParticleDescribe{1}.runLength1,processiveParticleDescribe{2}.runLength1];
    GoldData{i,2} = HistAndFit(runLength1,'gauss1',[0,3,100],'Runlength(nm)');

    subplot(2,4,3);
    movingDuration1 = [processiveParticleDescribe{1}.movingDuration1,processiveParticleDescribe{2}.movingDuration1];
    GoldData{i,3} = HistAndFit(movingDuration1,'exp1',[5,5,100],'Processive Moving Duration(s)');

    subplot(2,4,4);
    totalBindDuration = [processiveParticleDescribe{1}.totalBindDuration,processiveParticleDescribe{2}.totalBindDuration];
    GoldData{i,4} = HistAndFit(totalBindDuration,'exp1',[10,10,500],'Processive Total BindDuration(s)');

    subplot(2,4,5);
    staticParticleDescribe = combineDataSet{i}.staticParticleDescribe;
    totalBindDuration = [staticParticleDescribe{1}.totalBindDuration,staticParticleDescribe{2}.totalBindDuration];
    GoldData{i,5} = HistAndFit(totalBindDuration,'exp1',[10,10,500],'Static Total BindDuration(s)');

    subplot(2,4,6);
    stuckAndMoveParticleDescribe = combineDataSet{i}.stuckAndMoveParticleDescribe;
    dwellTimeBeforeMovement = [stuckAndMoveParticleDescribe{1}.dwellTimeBeforeMovement,stuckAndMoveParticleDescribe{2}.dwellTimeBeforeMovement];
    GoldData{i,6} = HistAndFit(dwellTimeBeforeMovement,'exp1',[10,10,500],'Processive Stuck Before Move Duration(s)');

    subplot(2,4,7);
    moveAndStuckParticleDescribe = combineDataSet{i}.moveAndStuckParticleDescribe;
    dwellTimeAfterMovement = [moveAndStuckParticleDescribe{1}.dwellTimeAfterMovement,moveAndStuckParticleDescribe{2}.dwellTimeAfterMovement];
    GoldData{i,7} = HistAndFit(dwellTimeAfterMovement,'exp1',[10,10,500],'Processive Stuck After Move Duration(s)');
end
    
concentrationValue = [0,0.5,1,2,4,8,16];%mM
titleStr = ["Velocity(nm/s)";"Runlength(nm)";"Processive Moving Duration(s)";"Processive Total BindDuration(s)";"Static Total BindDuration(s)";"Processive Stuck Before Move Duration(s)";"Processive Stuck After Move Duration(s)"];
close all;
for PlotId = 1:7
    subplot(2,4,PlotId);
    MeanValue = zeros(1,7);
    MedianValue = zeros(1,7);
    FitValue = zeros(1,7);
    error= zeros(1,7);
    for concentration = 1:7

        ret = GoldData{concentration,PlotId};
       if concentration == 3
           ret.Mean = ret.Mean*2;  
           ret.Median = ret.Median*2; 
           ret.Fit = ret.Fit*2;   
           ret.MedianStd  = ret.MedianStd*2;    
           if (PlotId ==1 )||(PlotId==2)
               ret.Mean = ret.Mean/4;  
               ret.Median = ret.Median/4;
               ret.Fit = ret.Fit/4;   
               ret.MedianStd  = ret.MedianStd/4;      
           end
        end
        MeanValue(concentration) = ret.Mean;
        MedianValue(concentration) = ret.Median;
        FitValue(concentration) = ret.Fit;
        error(concentration) = ret.MedianStd;
    end
    hold on;
 
  %  hmean = plot(concentrationValue,MeanValue);
    errorbar(concentrationValue,MedianValue,error);
    hmedian = plot(concentrationValue,MedianValue);
     plot(concentrationValue,MedianValue,'*');
   % hfit = plot(concentrationValue,FitValue);
    %legend([hmean, hmedian,hfit],'mean','median','fit');
    ylimitv = ylim;
    ylim([0,ylimitv(2)]);
    ylabel(titleStr(PlotId));
    xlabel('Con.(mM)');
end