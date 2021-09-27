function [outputArg] = RemoveOdd(inputArg)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
inputArg(inputArg==0) =[];
inputArg(isnan(inputArg)) = [];
outputArg = inputArg;
end

