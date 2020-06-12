function varargout = Main(varargin)
% MAIN MATLAB code for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 04-May-2020 16:25:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadImageStack.
function LoadImageStack_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImageStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
global filefullpath;
[file,path] = uigetfile('*.tif');
filefullpath = path+"\"+file;


global meanImage;
global maxImage;
global imgHeight; 
global imgWidth; 
global stackSize;
global rawImagesStack;
global mouseDownPosition;

rawImagesStack = FastReadTirf(filefullpath);
[imgHeight,imgWidth,stackSize]= size(rawImagesStack);
mouseDownPosition = [floor(imgHeight),floor(imgWidth)];

set(handles.StackProgress,'Min',1);
set(handles.StackProgress,'Max',stackSize);
set(handles.StackProgress,'value',1);
set(gcf,'WindowButtonDownFcn',{@mouseDown,handles});



function mouseDown (object, eventdata,handles)
set(gcf,'WindowButtonMotionFcn', {@mouseMove,handles});
C = get (gca, 'CurrentPoint');
xPos = floor(C(1,1));
yPos = floor(C(1,2));
global mouseDownPosition;
global rawImagesStack;
global meanImage;
low = mean(mean(meanImage));
mouseDownPosition= [xPos,yPos];
threadhold = get(handles.Threadhold,'Value');
id =  floor(get(handles.StackProgress,'Value')); 
hold(handles.ImageWindowAxes, 'on');
plot(xPos,yPos,'go','Parent',handles.ImageWindowAxes);
hold(handles.ImageWindowAxes, 'off');
imshow(rawImagesStack((yPos-5):(yPos+5),(xPos-5):(xPos+5),id),[low,threadhold] ,'Parent',handles.axes4);

set(gcf,'WindowButtonUpFcn',{@mouseUp,handles});

function mouseMove (object, eventdata,handles)
C = get (gca, 'CurrentPoint');
xPos = floor(C(1,1));
yPos = floor(C(1,2));
global mouseDownPosition;
global rawImagesStack;
global meanImage;

originX = mouseDownPosition(1);
originY = mouseDownPosition(2);

low = mean(mean(meanImage));
threadhold = get(handles.Threadhold,'Value');
id =  floor(get(handles.StackProgress,'Value')); 
imshow(rawImagesStack(:,:,id),[low,threadhold] ,'Parent',handles.ImageWindowAxes);
rectangle('Position',[originX,originY,abs(xPos-originX),abs(yPos-originY)],'EdgeColor','r');

function mouseUp (object, eventdata,handles)
C = get (gca, 'CurrentPoint');
xPos = floor(C(1,1));
yPos = floor(C(1,2));
global mouseUpPosition;
mouseUpPosition= [xPos,yPos];
set(gcf,'WindowButtonUpFcn','');
set(gcf,'WindowButtonMotionFcn', '');

% --- Executes on slider movement.
function Threadhold_Callback(hObject, eventdata, handles)
% hObject    handle to Threadhold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
threadhold = get(hObject,'Value');
global meanImage;
global particlePosition;
meanImage= GroupZProject(rawImagesStack,stackSize);
low = mean(mean(meanImage));
high = max(max(meanImage));
imshow(meanImage,[low,high] ,'Parent',handles.ImageWindowAxes);
set(handles.Threadhold,'Min',low);
set(handles.Threadhold,'Max',high);
set(handles.Threadhold,'value',high);
particlePosition = FindPoints(meanImage,threadhold);
low = mean(mean(meanImage));
high = max(max(meanImage));
imshow(meanImage,[low,threadhold] ,'Parent',handles.ImageWindowAxes);
if  get(handles.ShowOverlay,'Value')
    hold(handles.ImageWindowAxes, 'on');
    plot(particlePosition(:,1),particlePosition(:,2),'ro','Parent',handles.ImageWindowAxes);
    hold(handles.ImageWindowAxes, 'off');
end
% --- Executes during object creation, after setting all properties.
function Threadhold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threadhold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function StackProgress_Callback(hObject, eventdata, handles)
% hObject    handle to StackProgress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global rawImagesStack;
global meanImage;
global particlePosition;
global mouseDownPosition;

xPos = mouseDownPosition(1);
yPos = mouseDownPosition(2);
id =  floor(get(hObject,'Value')); 
low = mean(mean(meanImage));
threadhold = get(handles.Threadhold,'Value');
if id ==1
    imshow(meanImage,[low,threadhold] ,'Parent',handles.ImageWindowAxes);
else
    imshow(rawImagesStack(:,:,id),[low,threadhold] ,'Parent',handles.ImageWindowAxes);
    imshow(rawImagesStack((yPos-5):(yPos+5),(xPos-5):(xPos+5),id),[low,threadhold] ,'Parent',handles.axes4);
end

hold(handles.ImageWindowAxes, 'on');
plot(xPos,yPos,'go','Parent',handles.ImageWindowAxes);
hold(handles.ImageWindowAxes, 'off');

if  get(handles.ShowOverlay,'Value')
    hold(handles.ImageWindowAxes, 'on');
    plot(particlePosition(:,1),particlePosition(:,2),'ro','Parent',handles.ImageWindowAxes);
    hold(handles.ImageWindowAxes, 'off');
end

% --- Executes during object creation, after setting all properties.
function StackProgress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StackProgress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ShowPreviouTrace.
function ShowPreviouTrace_Callback(hObject, eventdata, handles)
% hObject    handle to ShowPreviouTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = str2double(get(handles.CurrentDisplayIndex,'String'))-1;
global traces;
global posNum;
if index<1
    index = 1;
end
if index >posNum
    index = posNum;
end
set(handles.CurrentDisplayIndex,'String',int2str(index));
plot(traces(index,:),'parent',handles.TraceAxes);


% --- Executes on button press in ShowNextTrace.
function ShowNextTrace_Callback(hObject, eventdata, handles)
% hObject    handle to ShowNextTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = str2double(get(handles.CurrentDisplayIndex,'String'))+1;
global traces;
global posNum;
if index<1
    index = 1;
end
if index >posNum
    index = posNum;
end
set(handles.CurrentDisplayIndex,'String',int2str(index));
plot(traces(index,:),'parent',handles.TraceAxes);


function CurrentDisplayIndex_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentDisplayIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentDisplayIndex as text
%        str2double(get(hObject,'String')) returns contents of CurrentDisplayIndex as a double
index = str2double(get(hObject,'String'));
global traces;
global posNum;
if index<1
    index = 1;
end
if index >posNum
    index = posNum;
end
plot(traces(index,:),'parent',handles.TraceAxes);

% --- Executes during object creation, after setting all properties.
function CurrentDisplayIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentDisplayIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BuildTraces.
function BuildTraces_Callback(hObject, eventdata, handles)
% hObject    handle to BuildTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global particlePosition;
global traces;
global stackSize;
global rawImagesStack;
global imgWidth;
global imgHeight;
global posNum;
posNum = size(particlePosition,1);
traces = zeros(posNum,stackSize);
trace = zeros(stackSize); 
magrin = 4;
for i = 1:posNum
    x = particlePosition(i,1);
    y = particlePosition(i,2);  
    if x <magrin || x >imgWidth-200
        continue
    end
    if y <magrin || y >imgHeight-magrin
        continue
    end
    trace = rawImagesStack(y-1,x-1,:)+rawImagesStack(y-1,x,:)+rawImagesStack(y-1,x+1,:);
    trace = trace+rawImagesStack(y,x-1,:)+rawImagesStack(y,x,:)+rawImagesStack(y,x+1,:);
    trace = trace+rawImagesStack(y+1,x-1,:)+rawImagesStack(y+1,x,:)+rawImagesStack(y+1,x+1,:);
    trace = trace/9;  
    traces(i,:) = gather(trace);
end
plot(traces(1,:),'parent',handles.TraceAxes);
set(handles.CurrentDisplayIndex,'String',int2str(1));
set(handles.TotalParticleNum,'String',int2str(posNum));


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ObserveState_Callback(hObject, eventdata, handles)
% hObject    handle to ObserveState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ObserveState as text
%        str2double(get(hObject,'String')) returns contents of ObserveState as a double


% --- Executes during object creation, after setting all properties.
function ObserveState_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ObserveState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveTraces.
function SaveTraces_Callback(hObject, eventdata, handles)
% hObject    handle to SaveTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global traces;
global filefullpath;
filename = filefullpath+".csv";
writematrix(traces,filename);


% --- Executes on button press in LoadTraces.
function LoadTraces_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.csv');
filefullpath = path+"\"+file;
global traces;
global posNum;
traces = csvread(filefullpath);
plot(traces(1,:),'parent',handles.TraceAxes);
posNum = size(traces,1);
set(handles.CurrentDisplayIndex,'String',int2str(1));
set(handles.TotalParticleNum,'String',int2str(posNum));


% --- Executes on button press in BuiltHistgram.
function BuiltHistgram_Callback(hObject, eventdata, handles)
% hObject    handle to BuiltHistgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global traces;
[w,h] = size(traces);
temp = reshape(traces,1,w*h);
binning = str2double(get(handles.HistgramBinning,'String'));
histogram(temp,binning,'parent',handles.HistgramAxes);



function HistgramBinning_Callback(hObject, eventdata, handles)
% hObject    handle to HistgramBinning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HistgramBinning as text
%        str2double(get(hObject,'String')) returns contents of HistgramBinning as a double
global traces;
[w,h] = size(traces);
temp = reshape(traces,1,w*h);
binning = str2double(get(handles.HistgramBinning,'String'));
histogram(temp,binning,'parent',handles.HistgramAxes);

% --- Executes during object creation, after setting all properties.
function HistgramBinning_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HistgramBinning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddTraces.
function AddTraces_Callback(hObject, eventdata, handles)
% hObject    handle to AddTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.csv');
filefullpath = path+"\"+file;
global traces;
global posNum;
temp = csvread(filefullpath);
traces = [traces;temp];
plot(traces(1,:),'parent',handles.TraceAxes);
posNum = size(traces,1);
set(handles.CurrentDisplayIndex,'String',int2str(1));
set(handles.TotalParticleNum,'String',int2str(posNum));


% --- Executes on button press in ShowOverlay.
function ShowOverlay_Callback(hObject, eventdata, handles)
% hObject    handle to ShowOverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  
