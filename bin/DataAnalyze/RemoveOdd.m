function [outputArg] = RemoveOdd(inputArg)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
inputArg(inputArg==0) =[];
inputArg(isnan(inputArg)) = [];
outputArg = inputArg;
end

