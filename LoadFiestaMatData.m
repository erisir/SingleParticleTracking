function [molecules] = LoadFiestaMatData(file_path)
%LOADMATDATA load the traces data from the *.mat file which generate by
%Fiesta, it contains all the info by we only use the .Molecule data which
%is composed by xpos,ypos,z, distance etc.
%   Detailed explanation goes here
rawdata = load(file_path);
molecules = rawdata.Molecule;
end

