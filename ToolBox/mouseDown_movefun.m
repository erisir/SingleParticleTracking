%set(gcf,'WindowButtonDownFcn',{@mouseDown,handles});

function mouseDown (object, eventdata,handles)
return;
set(gcf,'WindowButtonMotionFcn', {@mouseMove,handles});
C = get (gca, 'CurrentPoint');
xPos = floor(C(1,1));
yPos = floor(C(1,2));
global mouseDownPosition;
global rawImagesStack;
global meanImage;
low = mean(mean(meanImage));
mouseDownPosition= [xPos,yPos];
Slider_Threadhold_High = get(handles.Slider_Threadhold_Low,'Value');
id =  floor(get(handles.Slider_Stack_Index,'Value')); 
hold(handles.ImageWindowAxes, 'on');
plot(xPos,yPos,'go','Parent',handles.ImageWindowAxes);
hold(handles.ImageWindowAxes, 'off');
imshow(rawImagesStack((yPos-5):(yPos+5),(xPos-5):(xPos+5),id),[low,Slider_Threadhold_High] ,'Parent',handles.IRMZoomAxes);

set(gcf,'WindowButtonUpFcn',{@mouseUp,handles});

function mouseMove (object, eventdata,handles)
return;
C = get (gca, 'CurrentPoint');
xPos = floor(C(1,1));
yPos = floor(C(1,2));
global mouseDownPosition;
global rawImagesStack;
global meanImage;

originX = mouseDownPosition(1);
originY = mouseDownPosition(2);

low = mean(mean(meanImage));
Slider_Threadhold_High = get(handles.Slider_Threadhold_Low,'Value');
id =  floor(get(handles.Slider_Stack_Index,'Value')); 
imshow(rawImagesStack(:,:,id),[low,Slider_Threadhold_High] ,'Parent',handles.ImageWindowAxes);
rectangle('Position',[originX,originY,abs(xPos-originX),abs(yPos-originY)],'EdgeColor','r');

function mouseUp (object, eventdata,handles)
return;
C = get (gca, 'CurrentPoint');
xPos = floor(C(1,1));
yPos = floor(C(1,2));
global mouseUpPosition;
mouseUpPosition= [xPos,yPos];
set(gcf,'WindowButtonUpFcn','');
set(gcf,'WindowButtonMotionFcn', '');