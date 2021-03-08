function [] = LogMsg(handles,str)
%LOGSYSTEMMESSAGE  
set(handles.System_Msg,'String',str);
%drawnow;
end

