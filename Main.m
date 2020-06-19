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

% Last Modified by GUIDE v2.5 15-Jun-2020 07:28:00

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
 
global gImages;
[file,path] = uigetfile('*.tif');
gImages.filefullpath = path+"\"+file;
gImages.rawImagesStack = FastReadTirf(gImages.filefullpath);
[gImages.imgHeight,gImages.imgWidth,gImages.stackSize]= size(gImages.rawImagesStack);
gImages.ZprojectMean = mean(gImages.rawImagesStack,3);
gImages.ZprojectMax = max(gImages.rawImagesStack,[],3);

low = floor(mean(mean(gImages.ZprojectMean)));
high = floor(max(max(gImages.ZprojectMean)));
set(handles.Threadhold,'Min',low);
set(handles.Threadhold,'Max',high);
set(handles.Threadhold,'value',400);

set(handles.StackProgress,'Min',1);
set(handles.StackProgress,'Max',gImages.stackSize);
set(handles.StackProgress,'value',1);
set(gcf,'WindowButtonDownFcn',{@mouseDown,handles});
imshow(gImages.ZprojectMean,[] ,'Parent',handles.ImageWindowAxes);


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
threadhold = get(handles.Threadhold,'Value');
id =  floor(get(handles.StackProgress,'Value')); 
hold(handles.ImageWindowAxes, 'on');
plot(xPos,yPos,'go','Parent',handles.ImageWindowAxes);
hold(handles.ImageWindowAxes, 'off');
imshow(rawImagesStack((yPos-5):(yPos+5),(xPos-5):(xPos+5),id),[low,threadhold] ,'Parent',handles.ZoomAxes);

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
threadhold = get(handles.Threadhold,'Value');
id =  floor(get(handles.StackProgress,'Value')); 
imshow(rawImagesStack(:,:,id),[low,threadhold] ,'Parent',handles.ImageWindowAxes);
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

% --- Executes on slider movement.
function Threadhold_Callback(hObject, eventdata, handles)
% hObject    handle to Threadhold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global gImages;
threadhold = get(hObject,'Value');
low = get(hObject,'Min');
imageId = floor(get(handles.StackProgress,'Value'));
stackSize = floor(get(handles.StackProgress,'Max'));
if imageId ==stackSize
    imshow(gImages.IRMImage,[low,threadhold] ,'Parent',handles.ImageWindowAxes);
else
    imshow(gImages.ZprojectMean,[low,threadhold] ,'Parent',handles.ImageWindowAxes);
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
global gImages;
 
id =  floor(get(hObject,'Value')); 
low = get(handles.Threadhold,'Min');
threadhold = get(handles.Threadhold,'Value');
 
if id ==1
    imshow(gImages.ZprojectMean,[low,threadhold] ,'Parent',handles.ImageWindowAxes);
else
    if id ==1000
        imshow(gImages.IRMImage,[low,threadhold] ,'Parent',handles.ImageWindowAxes);   
    else
        imshow(gImages.rawImagesStack(:,:,id),[low,threadhold] ,'Parent',handles.ImageWindowAxes);

    end
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
global gTraces;
global gImages;
if index<1
    index = 1;
end
if index >gTraces.CurrentShowNums
    index = gTraces.CurrentShowNums;
end
set(handles.CurrentDisplayIndex,'String',int2str(index));
PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles);


% --- Executes on button press in ShowNextTrace.
function ShowNextTrace_Callback(hObject, eventdata, handles)
% hObject    handle to ShowNextTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = str2double(get(handles.CurrentDisplayIndex,'String'))+1;
global gTraces;
global gImages;
    
if index<1
    index = 1;
end
if index >gTraces.CurrentShowNums
    index =gTraces.CurrentShowNums;
end
set(handles.CurrentDisplayIndex,'String',int2str(index));
PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles);
 

function CurrentDisplayIndex_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentDisplayIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentDisplayIndex as text
%        str2double(get(hObject,'String')) returns contents of CurrentDisplayIndex as a double
index = str2double(get(hObject,'String'));
global gTraces;
global gImages;

if index<1
    index = 1;
end
if index >gTraces.CurrentShowNums
    index = gTraces.CurrentShowNums;
end
set(handles.CurrentDisplayIndex,'String',int2str(index));
PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles);

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


% --- Executes on button press in LoadIRMImage.
function LoadIRMImage_Callback(hObject, eventdata, handles)
% hObject    handle to LoadIRMImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gImages;
warning off;
[file,path] = uigetfile('*.tif');
filefullpath = path+"\"+file;
gImages.IRMImage = FastReadTirf(filefullpath);

low = gather(floor(mean(mean(gImages.IRMImage))));
high = gather(floor(max(max(gImages.IRMImage))));

set(handles.Threadhold,'Min',low/2);
set(handles.Threadhold,'Max',high);
 
try
    if gImages.stackSize<1
        gImages.stackSize  =1;
    end
catch
    gImages.stackSize = 1;
end
set(handles.StackProgress,'Min',1);
set(handles.StackProgress,'Max',gImages.stackSize);
set(handles.StackProgress,'value',gImages.stackSize);
 
imshow(gImages.IRMImage,[low,high] ,'Parent',handles.ImageWindowAxes);


% --- Executes on button press in SaveCatalog.
function SaveCatalog_Callback(hObject, eventdata, handles)
% hObject    handle to SaveCatalog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;

catalogs.catalogs1 =gTraces.catalogs1;
catalogs.catalogs2 = gTraces.catalogs2;
catalogs.catalogs3 =gTraces.catalogs3;
catalogs.catalogs4 =gTraces.catalogs4;
catalogs.catalogs5 = gTraces.catalogs5;

[file,path] = uiputfile('*.mat');
save([path,file],'catalogs');

% --- Executes on button press in LoadTraces.
function LoadTraces_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
global gImages;
[file,path] = uigetfile('*.mat');
filefullpath = path+"\"+file;

gTraces.catalogs1 = [];
gTraces.catalogs2 = [];
gTraces.catalogs3 = [];
gTraces.catalogs4 = [];
gTraces.catalogs5 = [];

gTraces.molecules = LoadFiestaMatData(filefullpath); 
gTraces.showCatalog = 1:size(gTraces.molecules,2);
gTraces.moleculenum = max(gTraces.showCatalog);

gTraces.CurrentShowTpye = 'All';
gTraces.CurrentShowNums = gTraces.moleculenum ;
gTraces.CurrentShowIndex = 1:gTraces.moleculenum;
fiducialIndex = [7,8];
[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty]=SmoothDriftTraces(gTraces,fiducialIndex);%save the result to Traces struct

PlotTrace(gImages,gTraces,1,handles);
 
set(handles.CurrentDisplayIndex,'String',int2str(1));
set(handles.TotalParticleNum,'String',int2str(gTraces.moleculenum));

 
 


% --- Executes on button press in AddCatalog1.
function AddCatalog1_Callback(hObject, eventdata, handles)
% hObject    handle to AddCatalog1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
index = str2num(get(handles.CurrentDisplayIndex,'String'));
if ~ismember(index,gTraces.catalogs1)
    gTraces.catalogs1 = [gTraces.catalogs1,index];
end
% --- Executes on button press in AddCatalog2.
function AddCatalog2_Callback(hObject, eventdata, handles)
% hObject    handle to AddCatalog2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
index = str2num(get(handles.CurrentDisplayIndex,'String'));
if ~ismember(index,gTraces.catalogs2)
    gTraces.catalogs2 = [gTraces.catalogs2,index];
end
% --- Executes on button press in AddCatalog3.
function AddCatalog3_Callback(hObject, eventdata, handles)
% hObject    handle to AddCatalog3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
index = str2num(get(handles.CurrentDisplayIndex,'String'));
if ~ismember(index,gTraces.catalogs3)
    gTraces.catalogs3 = [gTraces.catalogs3,index];
end
% --- Executes on button press in AddCatalog4.
function AddCatalog4_Callback(hObject, eventdata, handles)
% hObject    handle to AddCatalog4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
index = str2num(get(handles.CurrentDisplayIndex,'String'));
if ~ismember(index,gTraces.catalogs4)
    gTraces.catalogs4 = [gTraces.catalogs4,index];
end
% --- Executes on button press in AddCatalog5.
function AddCatalog5_Callback(hObject, eventdata, handles)
% hObject    handle to AddCatalog5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
index = str2num(get(handles.CurrentDisplayIndex,'String'));
if ~ismember(index,gTraces.catalogs5)
    gTraces.catalogs5 = [gTraces.catalogs5,index];
end

% --- Executes on button press in LoadCatalog.
function LoadCatalog_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCatalog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
[file,path] = uigetfile('*.mat');
if file ==0
    return;
end
filefullpath = path+"\"+file;
catalogs = load(filefullpath);
catalogs = catalogs.catalogs;
gTraces.catalogs1 = catalogs.catalogs1;
gTraces.catalogs2 = catalogs.catalogs2;
gTraces.catalogs3 = catalogs.catalogs3;
gTraces.catalogs4 = catalogs.catalogs4;
gTraces.catalogs5 = catalogs.catalogs5;
all = [catalogs.catalogs1,catalogs.catalogs2,catalogs.catalogs3,catalogs.catalogs4,catalogs.catalogs5];
set(handles.CurrentDisplayIndex,'String',num2str(max(all)));


% --- Executes on selection change in ShowType.
function ShowType_Callback(hObject, eventdata, handles)
% hObject    handle to ShowType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ShowType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ShowType
contents = cellstr(get(hObject,'String'));
selectedType = contents{get(hObject,'Value')};
global gTraces;
switch selectedType
    case 'All'
        gTraces.CurrentShowTpye = 'All';
        gTraces.CurrentShowNums = gTraces.moleculenum ;
        gTraces.CurrentShowIndex = 1:gTraces.moleculenum;
    case 'Stuck'
         gTraces.CurrentShowTpye = 'Stuck';
         gTraces.CurrentShowNums = size(gTraces.catalogs1,2);
         gTraces.CurrentShowIndex = gTraces.catalogs1;
    case 'BigStep'
         gTraces.CurrentShowTpye = 'BigStep';
         gTraces.CurrentShowNums = size(gTraces.catalogs2,2);
         gTraces.CurrentShowIndex = gTraces.catalogs2;
    case 'Linear'
         gTraces.CurrentShowTpye = 'Linear';
         gTraces.CurrentShowNums = size(gTraces.catalogs3,2);
         gTraces.CurrentShowIndex = gTraces.catalogs3;
    case 'BackForward'
         gTraces.CurrentShowTpye = 'BackForward';
         gTraces.CurrentShowNums = size(gTraces.catalogs4,2);
         gTraces.CurrentShowIndex = gTraces.catalogs4;
    case 'Other'      
         gTraces.CurrentShowTpye = 'Other';
         gTraces.CurrentShowNums = size(gTraces.catalogs5,2);
         gTraces.CurrentShowIndex = gTraces.catalogs5;
end
set(handles.CurrentDisplayIndex,'String',num2str(1)); %go to the first
set(handles.TotalParticleNum,'String',int2str(gTraces.CurrentShowNums));
gTraces.CurrentShowIndex
% --- Executes during object creation, after setting all properties.
function ShowType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShowType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
