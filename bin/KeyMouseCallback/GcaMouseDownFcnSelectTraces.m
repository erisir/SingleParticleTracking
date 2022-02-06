function [] = GcaMouseDownFcnSelectTraces(object, eventdata,handles,index)
%GCAWINDOWMOUSEDOWNFCN  
%    
    global gTraces;
    button = eventdata.Button;

    pos = eventdata.IntersectionPoint;
    TracesId = gTraces.CurrentShowIndex(index);
    plotstr = 'og';
    if button ==1         
        if gTraces.Metadata(TracesId).DataQuality == "All"% select good/bad from all;
            gTraces.Metadata(TracesId).DataQuality = "Good";
            plotstr = 'ok';
        end
    end
    if button ==3    %right click
        if gTraces.Metadata(TracesId).DataQuality == "All"
            gTraces.Metadata(TracesId).DataQuality = "Bad";
            plotstr = 'or';
        end
    end
    
    hold(object,'on');
    plot(pos(1),pos(2),plotstr);
    hold(object,'off'); 

end

