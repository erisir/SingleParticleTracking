function [] = LogMsg(handles,str)
%LOGSYSTEMMESSAGE 此处显示有关此函数的摘要
%   此处显示详细说明
set(handles.System_Msg,'String',str);
drawnow;
end

