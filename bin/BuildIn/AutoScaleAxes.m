function   AutoScaleAxes(handles,hObject)
%AUTOSCALEAXES  
%    
    global gTraces;
    gTraces.LastSelectedList = hObject.Tag;
    contents = cellstr(get(hObject,'String'));
    value = str2num(contents{get(hObject,'Value')});
    
    switch hObject.Tag
        case 'Distance_Section_List'
            res= xlim(handles.DistanceAxes);
        case 'PathLength_Section_List'
            res= xlim(handles.PathLengthAxes);
        case 'Intensity_Section_List'
            res= xlim(handles.IntensityAxes);
        otherwise
    end
    
    set(handles.Slider_Section_Select,'min',res(1));
    set(handles.Slider_Section_Select,'max',res(2));
    set(handles.Slider_Section_Select,'Value',value);
    set(handles.Slider_Section_Select,'SliderStep',[1/(res(2)-res(1)),5/(res(2)-res(1))]);

end

