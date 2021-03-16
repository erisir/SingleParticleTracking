function describe = ReadFromWorkspace(describe,workspaceVar)
%READFROMWORKSPACE 此处显示有关此函数的摘要
%   此处显示详细说明
    saveTmp = evalin('base',workspaceVar);
    describe.width = [describe.width ,  saveTmp.width];
    describe.intensity = [describe.intensity ,  saveTmp.intensity];
    describe.totalBindDuration = [describe.totalBindDuration ,saveTmp.totalBindDuration ];
    describe.dwellTimeBeforeMovement = [describe.dwellTimeBeforeMovement ,saveTmp.dwellTimeBeforeMovement ];
    describe.dwellTimeAfterMovement = [describe.dwellTimeAfterMovement , saveTmp.dwellTimeAfterMovement ];
    describe.movingDuration1 = [describe.movingDuration1 , saveTmp.movingDuration1];
    describe.movingDuration2 = [describe.movingDuration2 , saveTmp.movingDuration2];
    describe.movingVelocity1 = [describe.movingVelocity1 , saveTmp.movingVelocity1];
    describe.movingVelocity2 = [describe.movingVelocity2 , saveTmp.movingVelocity2];
    describe.runLength1 = [describe.runLength1 , saveTmp.runLength1];
    describe.runLength2 = [describe.runLength2 , saveTmp.runLength2];     
    %describe.metadata = [describe.metadata , saveTmp.metadata];
    describe.meanfitError = [describe.meanfitError , saveTmp.meanfitError];
end

