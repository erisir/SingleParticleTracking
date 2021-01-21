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
            
            TracesId = gTraces.CurrentShowIndex(index);% prepare display title
            dataQuality =  gTraces.Metadata(TracesId).DataQuality;
            setCatalog =  gTraces.Metadata(TracesId).SetCatalog;
            
            plot(axies(i+1),frameIndicator,distance,'k.');
            hold(axies(i+1),'on');
            switch dataQuality
                case char('Perfect')
                    p=plot(axies(i+1),frameIndicator,distance,'g-');
                case char('Good')
                    p=plot(axies(i+1),frameIndicator,distance,'b-');
                case char('bad')
                    p=plot(axies(i+1),frameIndicator,distance,'r-');
                otherwise
                    p=plot(axies(i+1),frameIndicator,distance,'k-');
            end
            hold(axies(i+1),'off');
           % set(p,'ButtonDownFcn', {@GcaMouseDownFcnSelectTraces,handles,index});    
            set(axies(i+1),'ButtonDownFcn', {@GcaMouseDownFcnSelectTraces,handles,index});    
           

            if strcmp(class(dataQuality), 'string')
                dataQuality = dataQuality.char;
            end
            str = [num2str(index),'-',setCatalog,'.',dataQuality];
            str = lower(strrep(str,'_','.'));        
            title(axies(i+1),str);% prepare display title
 
            index = index+1;
        end
        set(handles.Current_Trace_Id,'String',int2str(index));
    end
    if keyValue == "leftarrow"
        index = str2double(get(handles.Current_Trace_Id,'String'))-40;
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
            TracesId = gTraces.CurrentShowIndex(index);% prepare display title
            dataQuality =  gTraces.Metadata(TracesId).DataQuality;
            setCatalog =  gTraces.Metadata(TracesId).SetCatalog;
            plot(axies(i+1),frameIndicator,distance,'k.');
            hold(axies(i+1),'on');
             switch dataQuality
                case char('perfect')
                    p=plot(axies(i+1),frameIndicator,distance,'g-');
                case char('Good')
                    p=plot(axies(i+1),frameIndicator,distance,'b-');
                case char('bad')
                    p=plot(axies(i+1),frameIndicator,distance,'r-');
                otherwise
                    p=plot(axies(i+1),frameIndicator,distance,'k-');
            end
            hold(axies(i+1),'off');
            %set(p,'ButtonDownFcn', {@GcaMouseDownFcnSelectTraces,index});    
            set(axies(i+1),'ButtonDownFcn', {@GcaMouseDownFcnSelectTraces,handles,index});    

            
            if strcmp(class(dataQuality), 'string')
                dataQuality = dataQuality.char;
            end
            str = [num2str(index),'-',setCatalog,'.',dataQuality];
            str = lower(strrep(str,'_','.'));        
            title(axies(i+1),str);% prepare display title
            
            index = index+1;
        end
        set(handles.Current_Trace_Id,'String',int2str(index));
    end
 
end

