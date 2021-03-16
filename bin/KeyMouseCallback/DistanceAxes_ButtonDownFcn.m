function DistanceAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to DistanceAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
gTraces.LastSelectedList = 'Distance_Section_List' ;
button = eventdata.Button;
if button ==1
    set(handles.Distance_Section_List,'Value',1);
end
if button ==3
    set(handles.Distance_Section_List,'Value',2);
end
time = eventdata.IntersectionPoint(1);
time = round(time);
SetFittingsegment(handles,time);
range= xlim(handles.DistanceAxes);
set(handles.Slider_Section_Select,'min',range(1));
set(handles.Slider_Section_Select,'max',range(2));
set(handles.Slider_Section_Select,'Value',time);
%set(handles.DistanceAxes,'KeyPressFcn',{@DistanceAxes_KeyDownFcn,handles});
