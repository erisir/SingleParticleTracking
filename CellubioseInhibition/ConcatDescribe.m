function describe = ConcatDescribe(describe,newDescribe)
    describe.width = [describe.width ,  newDescribe.width];
    describe.intensity = [describe.intensity ,  newDescribe.intensity];
    describe.totalBindDuration = [describe.totalBindDuration ,newDescribe.totalBindDuration ];
    describe.dwellTimeBeforeMovement = [describe.dwellTimeBeforeMovement ,newDescribe.dwellTimeBeforeMovement ];
    describe.dwellTimeAfterMovement = [describe.dwellTimeAfterMovement , newDescribe.dwellTimeAfterMovement ];
    describe.movingDuration1 = [describe.movingDuration1 , newDescribe.movingDuration1];
    describe.movingDuration2 = [describe.movingDuration2 , newDescribe.movingDuration2];
    describe.movingVelocity1 = [describe.movingVelocity1 , newDescribe.movingVelocity1];
    describe.movingVelocity2 = [describe.movingVelocity2 , newDescribe.movingVelocity2];
    describe.runLength1 = [describe.runLength1 , newDescribe.runLength1];
    describe.runLength2 = [describe.runLength2 , newDescribe.runLength2];     
    %describe.metadata = [describe.metadata , saveTmp.metadata];
    describe.meanfitError = [describe.meanfitError , newDescribe.meanfitError];
end