ConcentrationList = ["Control";"0.5mM";"1mM";"2mM";"4mM";"8mM";"16mM"];
Concentration = [0,0.5,1,2,4,8,16];
NConcentration = size(Concentration,2);  
paramettersStr =["Velocity(nm/s)";"Run length(nm)";"Processive Moving Duration(s)";"Processive Total BindDuration(s)";...
    "Static Total BindDuration(s)";"Processive Stuck Before Move Duration(s)";"Processive Stuck After Move Duration(s)";"Processive particle Fit Error(nm)"]; 
parametters = cell(8,NConcentration);

staticParticleDescribe =  [];
processiveParticleDescribe = [];
stuckAndMoveParticleDescribe = [];
moveAndStuckParticleDescribe =  [];
    
for ConcentrationId = 1:7
    if isempty(RawData{ConcentrationId})
        continue;
    end
    folderNums = size(RawData{ConcentrationId}.Config,2);
    for folderId = 1:folderNums
        
        Molecules = RawData{ConcentrationId}.Molecule{folderId};
        Metadatas = RawData{ConcentrationId}.Metadata{folderId};       
        exposure = RawData{ConcentrationId}.Config{folderId}.ExpusureTimems;       
        FrameTrasferTimems = RawData{ConcentrationId}.Config{folderId}.FrameTrasferTimems;
        
        time_per_frames = (exposure+FrameTrasferTimems)/1000;
            
        moleculeNums = size(Molecules,2);
        
        staticParticleId = [];
        processiveParticleId = [];
        stuckAndMoveParticleId = [];
        moveAndStuckParticleId = [];

        for traceId = 1:moleculeNums
            metadata=Metadatas(traceId);
            type = metadata.SetCatalog;      
            if  strcmp(type,'Temp')  %static
                staticParticleId = [staticParticleId,traceId];
            end        
            if ~strcmp(type,'All') && ~strcmp(type,'Stepping') && ~strcmp(type,'Diffusion') && ~strcmp(type,'Temp') % processive 
              processiveParticleId = [processiveParticleId,traceId];
            end
            if strcmp(type,'Stuck_Go') || strcmp(type,'Stuck_Go_Stuck')  % stuck-move
                stuckAndMoveParticleId = [stuckAndMoveParticleId,traceId];
            end
            if strcmp(type,'Go_Stuck') || strcmp(type,'Go_Stuck_Go')     % move-stuck
                moveAndStuckParticleId = [moveAndStuckParticleId,traceId];
            end
        end
        if folderId ==1
            staticParticleDescribe = GetDescribe(Molecules,Metadatas,staticParticleId,time_per_frames); 
            processiveParticleDescribe =GetDescribe(Molecules,Metadatas,processiveParticleId,time_per_frames);
            stuckAndMoveParticleDescribe =GetDescribe(Molecules,Metadatas,stuckAndMoveParticleId,time_per_frames);
            moveAndStuckParticleDescribe = GetDescribe(Molecules,Metadatas,moveAndStuckParticleId,time_per_frames);
        else          
            staticParticleDescribeTemp = GetDescribe(Molecules,Metadatas,staticParticleId,time_per_frames); 
            processiveParticleDescribeTemp =GetDescribe(Molecules,Metadatas,processiveParticleId,time_per_frames);
            stuckAndMoveParticleDescribeTemp =GetDescribe(Molecules,Metadatas,stuckAndMoveParticleId,time_per_frames);
            moveAndStuckParticleDescribeTemp = GetDescribe(Molecules,Metadatas,moveAndStuckParticleId,time_per_frames);
            
            staticParticleDescribe = ConcatDescribe(staticParticleDescribe,staticParticleDescribeTemp);
            processiveParticleDescribe = ConcatDescribe(processiveParticleDescribe,processiveParticleDescribeTemp);
            stuckAndMoveParticleDescribe = ConcatDescribe(stuckAndMoveParticleDescribe,stuckAndMoveParticleDescribeTemp);
            moveAndStuckParticleDescribe = ConcatDescribe(moveAndStuckParticleDescribe,moveAndStuckParticleDescribeTemp);
        end
    end%folder id
    fitData = cell(1,8);
    fitData{1}.data = processiveParticleDescribe.movingVelocity1;
    fitData{1}.method = 'gauss1';
    fitData{1}.range = [0,1,40];
    fitData{2}.data = processiveParticleDescribe.runLength1;
    fitData{2}.method = 'gauss1';
    fitData{2}.range =[0,3,200];
    fitData{3}.data = processiveParticleDescribe.movingDuration1;
    fitData{3}.method = 'exp1';
    fitData{3}.range =[5,4,100];
    fitData{4}.data = processiveParticleDescribe.totalBindDuration;
    fitData{4}.method = 'exp1';
    fitData{4}.range =[10,10,500];
    fitData{5}.data = staticParticleDescribe.totalBindDuration;
    fitData{5}.method = 'exp2';
    fitData{5}.range =[20,10,1000];
    fitData{6}.data = stuckAndMoveParticleDescribe.dwellTimeBeforeMovement;
    fitData{6}.method = 'exp1';
    fitData{6}.range =[10,10,500];
    fitData{7}.data = moveAndStuckParticleDescribe.dwellTimeAfterMovement;
    fitData{7}.method = 'exp1';
    fitData{7}.range =[10,10,500];
    fitData{8}.data = staticParticleDescribe.meanfitError;
    fitData{8}.method = 'gauss1';
    fitData{8}.range =[1,0.3,10];
    
    figure('NumberTitle', 'off', 'Name', ConcentrationList(ConcentrationId));
    for i = 1:8
        subplot(2,4,i);
        parametters{i,ConcentrationId} = HistAndFit(fitData{i}.data, fitData{i}.method ,fitData{i}.range,paramettersStr(i));
    end
    
end%concentration
    
    
    
    