function [] = GcaKeyDownFcnSelectTraces(src, event,handles)
%GCAWINDOWMOUSEDOWNFCN 此处显示有关此函数的摘要
%   此处显示详细说明
global gTraces;
keyValue = event.Key;
if keyValue == "rightarrow"
    index = str2double(get(handles.Current_Trace_Id,'String'));  
    if index<1
        index = 1;
    end
    if index >gTraces.CurrentShowNums
        index =gTraces.CurrentShowNums;
    end
    axies = gTraces.ax;

    showNums = 20;   
    if index >gTraces.CurrentShowNums -showNums
        showNums = gTraces.CurrentShowNums - index;
    end

    for i=0:showNums-1
        [frameIndicator,distance,index] = GetNextMoveTrace(gTraces,index);
        plot(axies(i+1),frameIndicator,distance,'k.');
        hold(axies(i+1),'on');
        p=plot(axies(i+1),frameIndicator,distance,'b-');
        hold(axies(i+1),'off');
        set(p,'ButtonDownFcn', {@GcaMouseDownFcnSelectTraces,index});    
        set(axies(i+1),'ButtonDownFcn', {@GcaMouseDownFcnSelectTraces,handles,index});    

        title(axies(i+1),num2str(index));
        index = index+1;
    end
    set(handles.Current_Trace_Id,'String',int2str(index));

end
 
end

