function  DistanceAxes_KeyDownFcn(src, event,handles)
%DISTANCEAXES_KEYDOWNFCN �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    keyValue = event.Key;
    time = get(handles.Slider_Section_Select,'Value');
    switch keyValue 
        case "rightarrow"
           time=time+1;
        case "leftarrow"
            time = time - 1;
        otherwise
    end
    
time = round(time);
SetFittingsegment(handles,time);
range= xlim(handles.DistanceAxes);
set(handles.Slider_Section_Select,'min',range(1));
set(handles.Slider_Section_Select,'max',range(2));
set(handles.Slider_Section_Select,'Value',time);

end

