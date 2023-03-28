 function [molecules,Config] = LoadFiestaMatData(file_path)
%LOADMATDATA load the traces data from the *.mat file which generate by
%Fiesta, it contains all the info by we only use the .Molecule data which
%is composed by xpos,ypos,z, distance etc.
%   Detailed explanation goes here
    rawdata = load(file_path);
    molecules = rawdata.Molecule;
    %set up default config
    Config.Threshold = 200;
    Config.FirstFrame = 1;
    Config.LastFrame = 1000;
    Config.ExpusureTimems = 1000;
    Config.pixelSize = 73;
    Config.FileName = "";
    Config.StackName = "";
    Config.Model = "GaussSymmetric";
    Config.GpuAccelerate = 0;
    Config.Threshold = 100;
    Config.MaxVelocity = 100;
    Config.Position = 100;
    Config.Direction = 100;
    Config.Speed = 100;
    Config.MinLength = 100;
    Config.MaxBreak = 100;
    Config.MaxAngle = 100;
    Config.UsingDefault = 1;
    if isfield(rawdata,'Config')
        tempConfig = rawdata.Config;
        Config.UsingDefault = 0;
        if isfield(tempConfig,'Threshold')
            Config.Threshold = tempConfig.Threshold.Value;
        end
        if isfield(tempConfig,'FirstTFrame')
            Config.FirstFrame = tempConfig.FirstTFrame;
        end
        if isfield(tempConfig,'LastFrame')
            Config.LastFrame = tempConfig.LastFrame;          
        end
        if isfield(tempConfig,'Time')
            Config.ExpusureTimems = tempConfig.Time;
        end
        if isfield(tempConfig,'PixSize')
             Config.pixelSize = tempConfig.PixSize;
        end
        if isfield(tempConfig,'FileName')
             Config.FileName = tempConfig.FileName;
        end
        if isfield(tempConfig,'StackName')
             Config.StackName = tempConfig.StackName;
        end
        if isfield(tempConfig,'Model')
             Config.Model = tempConfig.Model;
        end
        if isfield(tempConfig,'PixSize')
             Config.pixelSize = tempConfig.PixSize;
        end
        
        
        if isfield(tempConfig,'OnlyTrack')
            if isfield(tempConfig.OnlyTrack,'OnlyTrack')
                Config.GpuAccelerate = tempConfig.OnlyTrack.GpuAccelerate;
            end
        end   
        if isfield(tempConfig,'Threshold')
            if isfield(tempConfig.Threshold,'Value')
                Config.Threshold = tempConfig.Threshold.Value;
            end
        end   
        if isfield(tempConfig,'ConnectMol')
            connectMol = tempConfig.ConnectMol;
            Config.MaxVelocity = connectMol.MaxVelocity;
            Config.Position = connectMol.Position;
            Config.Direction = connectMol.Direction;
            Config.Speed = connectMol.Speed;
            Config.MinLength = connectMol.MinLength;
            Config.MaxBreak = connectMol.MaxBreak;
            Config.MaxAngle = connectMol.MaxAngle;
        end       
    end
    Config.Catalogs = ["All";"Stuck_Go";"Go_Stuck";"Stuck_Go_Stuck";"Go_Stuck_Go";"NonLinear";"Stepping";"BackForward";"Diffusion";"Temp"];
    Config.StackSize = Config.LastFrame - Config.FirstFrame+1;

end

