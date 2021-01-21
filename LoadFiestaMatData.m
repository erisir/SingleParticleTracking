function [molecules,Config] = LoadFiestaMatData(file_path)
%LOADMATDATA load the traces data from the *.mat file which generate by
%Fiesta, it contains all the info by we only use the .Molecule data which
%is composed by xpos,ypos,z, distance etc.
%   Detailed explanation goes here
rawdata = load(file_path);
molecules = rawdata.Molecule;
try
Config.Threshold = rawdata.Config.Threshold.Value;
Config.FirstFrame = rawdata.Config.FirstTFrame;
Config.LastFrame = rawdata.Config.LastFrame;
Config.ExpusureTimems = rawdata.Config.Time;
Config.pixelSize = rawdata.Config.PixSize;
catch
Config.Threshold = 200;
Config.FirstFrame = 36;
Config.LastFrame = 1000;
Config.ExpusureTimems = 1037;
Config.pixelSize = 65.98;
end
end

