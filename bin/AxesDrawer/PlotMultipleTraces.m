function PlotMultipleTraces(handles,index,number)
%PLOTMULTIPLETRACES  
%    
    global gTraces;
    rows = 2;
    cloumn = ceil(number/rows);
 
    if index<1
        index = 1;
    end
    if index  >gTraces.CurrentShowNums
        index =gTraces.CurrentShowNums;
    end
    
    if isfield(gTraces,'axes')
        try
             plot(gTraces.axes(1),0,0);%might have closed by user
        catch
            figure('KeyPressFcn',{@GcaKeyDownFcnSelectTraces,handles,number});
            for i=1:number
                axies(i) = subplot(rows,cloumn,i);        
            end   
            gTraces.axes = axies;
        end
       
    else
        figure('KeyPressFcn',{@GcaKeyDownFcnSelectTraces,handles,number});
        for i=1:number
            axies(i) = subplot(rows,cloumn,i);        
        end   
        gTraces.axes = axies;
    end
    axies = gTraces.axes; 
    if index >gTraces.CurrentShowNums -number+1
        number = gTraces.CurrentShowNums - index+1;
    end
 
    for i=1:number
        TracesId = gTraces.CurrentShowIndex(index);
        series = GetTimeSeriesByTraceId(TracesId);
        dataQuality =  gTraces.Metadata(TracesId).DataQuality;
        setCatalog =  gTraces.Metadata(TracesId).SetCatalog;
        
        time=series.time;
        displacement = series.displacement;
        
        plot(axies(i),time,displacement,'k.');
        hold(axies(i),'on');
        switch dataQuality
            case char('Perfect')
                plot(axies(i),time,displacement,'g-');
            case char('Good')
                plot(axies(i),time,displacement,'b-');
            case char('Bad')
                plot(axies(i),time,displacement,'r-');
            otherwise
                plot(axies(i),time,displacement,'k-');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%debug
        if 1==0
        mv = max(displacement);
        mvid = find(displacement==mv);
        center = mvid/2;
       %plot(axies(i),time(mvid),-1*mv,'.');
        smdata = smooth(displacement,10);
        data = diff(smdata);
        dataOffset = data;
        plot(axies(i),time(2:end),dataOffset,'r');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        hold(axies(i),'off');
        set(axies(i),'ButtonDownFcn', {@GcaMouseDownFcnSelectTraces,handles,index});    
        
        str = string(num2str(index))+"-"+string(setCatalog)+"-"+string(dataQuality);    
        title(axies(i),str);% prepare display title

        index = index+1;
    end
    set(handles.Current_Trace_Id,'String',int2str(index));
end

