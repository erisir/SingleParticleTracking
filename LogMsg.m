function [] = LogMsg(handles,str)
%LOGSYSTEMMESSAGE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
set(handles.System_Msg,'String',str);
drawnow;
end

