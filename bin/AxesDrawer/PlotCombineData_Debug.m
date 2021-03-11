    %load('D:\Desktop\CellulaseInhibition\CombineGoldData.mat');
    combineDataSet = cell(1,7);%control,0.5,1,2,4,8,16
    combineDataSet{1}.moveAndStuckParticleDescribe = {moveAndStuckParticleDescribe20200117_Control,moveAndStuckParticleDescribe20201206_Control};
    combineDataSet{2}.moveAndStuckParticleDescribe = {moveAndStuckParticleDescribe20200117_05mM,moveAndStuckParticleDescribe20200117_05mM};
    combineDataSet{3}.moveAndStuckParticleDescribe = {moveAndStuckParticleDescribe20201206_1mM,moveAndStuckParticleDescribe20200117_1mM};
    combineDataSet{4}.moveAndStuckParticleDescribe = {moveAndStuckParticleDescribe20201206_2mM,moveAndStuckParticleDescribe20200117_2mM};
    combineDataSet{5}.moveAndStuckParticleDescribe = {moveAndStuckParticleDescribe20201206_4mM,moveAndStuckParticleDescribe20200117_4mM};
    combineDataSet{6}.moveAndStuckParticleDescribe = {moveAndStuckParticleDescribe20201206_8mM,moveAndStuckParticleDescribe20200117_8mM};
    combineDataSet{7}.moveAndStuckParticleDescribe = {moveAndStuckParticleDescribe20201206_16mM,moveAndStuckParticleDescribe20200117_16mM};
    
    combineDataSet{1}.processiveParticleDescribe = {processiveParticleDescribe20200117_Control,processiveParticleDescribe20201206_Control};
    combineDataSet{2}.processiveParticleDescribe = {processiveParticleDescribe20200117_05mM,processiveParticleDescribe20200117_05mM};
    combineDataSet{3}.processiveParticleDescribe = {processiveParticleDescribe20201206_1mM,processiveParticleDescribe20200117_1mM};
    combineDataSet{4}.processiveParticleDescribe = {processiveParticleDescribe20201206_2mM,processiveParticleDescribe20200117_2mM};
    combineDataSet{5}.processiveParticleDescribe = {processiveParticleDescribe20201206_4mM,processiveParticleDescribe20200117_4mM};
    combineDataSet{6}.processiveParticleDescribe = {processiveParticleDescribe20201206_8mM,processiveParticleDescribe20200117_8mM};
    combineDataSet{7}.processiveParticleDescribe = {processiveParticleDescribe20201206_16mM,processiveParticleDescribe20200117_16mM};
    
    combineDataSet{1}.staticParticleDescribe = {staticParticleDescribe20200117_Control,staticParticleDescribe20201206_Control};
    combineDataSet{2}.staticParticleDescribe = {staticParticleDescribe20200117_05mM,staticParticleDescribe20200117_05mM};
    combineDataSet{3}.staticParticleDescribe = {staticParticleDescribe20201206_1mM,staticParticleDescribe20200117_1mM};
    combineDataSet{4}.staticParticleDescribe = {staticParticleDescribe20201206_2mM,staticParticleDescribe20200117_2mM};
    combineDataSet{5}.staticParticleDescribe = {staticParticleDescribe20201206_4mM,staticParticleDescribe20200117_4mM};
    combineDataSet{6}.staticParticleDescribe = {staticParticleDescribe20201206_8mM,staticParticleDescribe20200117_8mM};
    combineDataSet{7}.staticParticleDescribe = {staticParticleDescribe20201206_16mM,staticParticleDescribe20200117_16mM};
    
    combineDataSet{1}.stuckAndMoveParticleDescribe = {stuckAndMoveParticleDescribe20200117_Control,stuckAndMoveParticleDescribe20201206_Control};
    combineDataSet{2}.stuckAndMoveParticleDescribe = {stuckAndMoveParticleDescribe20200117_05mM,stuckAndMoveParticleDescribe20200117_05mM};
    combineDataSet{3}.stuckAndMoveParticleDescribe = {stuckAndMoveParticleDescribe20201206_1mM,stuckAndMoveParticleDescribe20200117_1mM};
    combineDataSet{4}.stuckAndMoveParticleDescribe = {stuckAndMoveParticleDescribe20201206_2mM,stuckAndMoveParticleDescribe20200117_2mM};
    combineDataSet{5}.stuckAndMoveParticleDescribe = {stuckAndMoveParticleDescribe20201206_4mM,stuckAndMoveParticleDescribe20200117_4mM};
    combineDataSet{6}.stuckAndMoveParticleDescribe = {stuckAndMoveParticleDescribe20201206_8mM,stuckAndMoveParticleDescribe20200117_8mM};
    combineDataSet{7}.stuckAndMoveParticleDescribe = {stuckAndMoveParticleDescribe20201206_16mM,stuckAndMoveParticleDescribe20200117_16mM};
    GoldData = cell(7,7);
    for i = 1:7
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


