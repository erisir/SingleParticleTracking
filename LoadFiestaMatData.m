function [molecules] = LoadFiestaMatData(file_path)
%LOADMATDATA Summary of this function goes here
%   Detailed explanation goes here
rawdata = load(file_path);
molecules = rawdata.Molecule;
end

