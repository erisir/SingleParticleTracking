 function [molecules,Config] = LoadFiestaMatData(file_path)
%LOADMATDATA load the traces data from the *.mat file which generate by
%Fiesta, it contains all the info by we only use the .Molecule data which
%is composed by xpos,ypos,z, distance etc.
%   Detailed explanation goes here
    rawdata = load(file_path);
    molecules = rawdata.Molecule;
    if isfield(rawdata,'Config')
        tempConfig = rawdata.Config;
        if ~isfield(tempConfig,'Threshold')
            Config.Threshold = 200;
        else
            Config.Threshold = tempConfig.Threshold.Value;
        end
        if ~isfield(tempConfig,'FirstTFrame')
            Config.FirstFrame = 11;
        else
            Config.FirstFrame = tempConfig.FirstTFrame;
        end
        if ~isfield(tempConfig,'LastFrame')
            Config.LastFrame = 700;
        else
            Config.LastFrame = tempConfig.LastFrame;
            
        end
        if ~isfield(tempConfig,'Time')
             Config.ExpusureTimems = 1037;
        else
            Config.ExpusureTimems = tempConfig.Time;
        end
        if ~isfield(tempConfig,'PixSize')
            Config.pixelSize = 65.98;
        else
             Config.pixelSize = tempConfig.PixSize;
        end
    else
        Config.Threshold = 200;
        Config.FirstFrame = 36;
        Config.LastFrame = 1000;
        Config.ExpusureTimems = 1037;
        Config.pixelSize = 65.98;
    end
    Config.Catalogs = ["All";"Stuck_Go";"Go_Stuck";"Stuck_Go_Stuck";"Go_Stuck_Go";"NonLinear";"Stepping";"BackForward";"Diffusion";"Temp"];
    Config.StackSize = Config.LastFrame - Config.FirstFrame+1;

end

