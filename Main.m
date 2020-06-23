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

% Last Modified by GUIDE v2.5 22-Jun-2020 19:55:01

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
gImages.filefullpath = [path,file];
if path ==0
    return
end
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
    try
        width = 40;
        meany = 300;
        meanx = 300;
        newCombImg = [gImages.IRMImage(meany-width:meany+width,meanx-width:meanx+width);gImages.rawImagesStack(meany-width:meany+width,meanx-width:meanx+width,id)];
        imshow(newCombImg,[low,threadhold],'Parent',handles.ZoomAxes);
    catch 
    end
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
PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);


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
PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);
 

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
PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);

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
filefullpath = [path,file];
if path ==0
    return
end
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


% --- Executes on button press in SaveMetadata.
function SaveMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;

metadata = gTraces.Metadata;
[file,path] = uiputfile('*.mat');
if path ==0
    return
end
save([path,file],'metadata');

% --- Executes on button press in LoadTraces.
function LoadTraces_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gTraces;
global gImages;
[file,path] = uigetfile('*.mat');
filefullpath = [path,file];
if path ==0
    return
end
gTraces.Stuck_Go = [];
gTraces.Go_Stuck = [];
gTraces.Stuck_Go_Stuck = [];
gTraces.Go_Stuck_Go = [];
gTraces.NonLinear = [];
gTraces.Perfect = [];

gTraces.molecules = LoadFiestaMatData(filefullpath); 
gTraces.showCatalog = 1:size(gTraces.molecules,2);
gTraces.moleculenum = max(gTraces.showCatalog);
%initial metadata
metadata.Intensity = [0,0,0,0];
metadata.IntensityDwell = [0,0];
metadata.PathLength = [0,0,0,0];
metadata.PathLengthSlope = [0,0];
metadata.Distance = [0,0,0,0];
metadata.DistanceSlope = [0,0];
metadata.SetCatalog = 'All';

for i = 1:gTraces.moleculenum
    results = gTraces.molecules(i).Results;
    framecloumn = results(:,1);
    startFrame = min(framecloumn);
    endFrame = max(framecloumn);
    temp = [startFrame,endFrame,startFrame,endFrame];
    metadata.Intensity = temp;
    metadata.PathLength = temp;
    metadata.Distance = temp;
    metadata.IntensityDwell = [endFrame-startFrame,endFrame-startFrame];
    gTraces.Metadata(i) = metadata;    
end
 
gTraces.CurrentShowTpye = 'All';
gTraces.CurrentShowNums = gTraces.moleculenum ;
gTraces.CurrentShowIndex = 1:gTraces.moleculenum;
fiducialIndex = [7,8];
[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty]=SmoothDriftTraces(gTraces,fiducialIndex);%save the result to Traces struct

PlotTrace(gImages,gTraces,1,handles,0);%plot all
 
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

% --- Executes on button press in LoadMetadata.
function LoadMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
[file,path] = uigetfile('*.mat');
if file ==0
    return;
end
filefullpath = [path,file];
metadata = load(filefullpath);
gTraces.Metadata = metadata.metadata;


% --- Executes on selection change in ShowTypeList.
function ShowTypeList_Callback(hObject, eventdata, handles)
% hObject    handle to ShowTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ShowTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ShowTypeList
contents = cellstr(get(hObject,'String'));
selectedType = contents{get(hObject,'Value')};
global gTraces;
SetupCatalogByMetadata();
switch selectedType
    case 'All'
        gTraces.CurrentShowTpye = 'All';
        gTraces.CurrentShowNums = gTraces.moleculenum ;
        gTraces.CurrentShowIndex = 1:gTraces.moleculenum;
    case 'Stuck_Go'
         gTraces.CurrentShowTpye = 'Stuck_Go';
         gTraces.CurrentShowNums = size(gTraces.Stuck_Go,2);
         gTraces.CurrentShowIndex = gTraces.Stuck_Go;
    case 'Go_Stuck'
         gTraces.CurrentShowTpye = 'Go_Stuck';
         gTraces.CurrentShowNums = size(gTraces.Go_Stuck,2);
         gTraces.CurrentShowIndex = gTraces.Go_Stuck;
    case 'Stuck_Go_Stuck'
         gTraces.CurrentShowTpye = 'Stuck_Go_Stuck';
         gTraces.CurrentShowNums = size(gTraces.Stuck_Go_Stuck,2);
         gTraces.CurrentShowIndex = gTraces.Stuck_Go_Stuck;
    case 'Go_Stuck_Go'
         gTraces.CurrentShowTpye = 'Go_Stuck_Go';
         gTraces.CurrentShowNums = size(gTraces.Go_Stuck_Go,2);
         gTraces.CurrentShowIndex = gTraces.Go_Stuck_Go;
    case 'NonLinear'      
         gTraces.CurrentShowTpye = 'NonLinear';
         gTraces.CurrentShowNums = size(gTraces.NonLinear,2);
         gTraces.CurrentShowIndex = gTraces.NonLinear;
    case 'Perfect'      
         gTraces.CurrentShowTpye = 'Perfect';
         gTraces.CurrentShowNums = size(gTraces.Perfect,2);
         gTraces.CurrentShowIndex = gTraces.Perfect;
end
set(handles.CurrentDisplayIndex,'String',num2str(1)); %go to the first
set(handles.TotalParticleNum,'String',int2str(gTraces.CurrentShowNums));
 
% --- Executes during object creation, after setting all properties.
function ShowTypeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShowTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function SectionSelectBar_Callback(hObject, eventdata, handles)
% hObject    handle to SectionSelectBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global gTraces;
global gImages;

slideBarValue = floor(get(hObject,'Value'));
index = str2num(get(handles.CurrentDisplayIndex,'String'));
traceID = gTraces.CurrentShowIndex(index);
 
switch gTraces.LastSelectedList
      case 'IntensityList'   
          selected  =floor(get(handles.IntensityList,'Value'));
          gTraces.Metadata(traceID).Intensity(selected) = slideBarValue;
         
          intensity = gTraces.Metadata(traceID).Intensity;
          gTraces.Metadata(traceID).IntensityDwell(1) = intensity(2)-intensity(1);
          gTraces.Metadata(traceID).IntensityDwell(2) = intensity(4)-intensity(3);
          PlotTrace(gImages,gTraces,traceID,handles,1);
 
      case 'PathLengthList'  
          selected  =floor(get(handles.PathLengthList,'Value'));
          gTraces.Metadata(traceID).PathLength(selected) = slideBarValue;
         
          
          slopes = PlotTrace(gImages,gTraces,traceID,handles,2);
          gTraces.Metadata(traceID).PathLengthSlope(1) = slopes(1);
          gTraces.Metadata(traceID).PathLengthSlope(2) = slopes(2);
          
    
      case 'DistanceList'        
         selected  =floor(get(handles.DistanceList,'Value'));
          gTraces.Metadata(traceID).Distance(selected) = slideBarValue;
         
          
          slopes =PlotTrace(gImages,gTraces,traceID,handles,3);
          gTraces.Metadata(traceID).DistanceSlope(1) = slopes(3);
          gTraces.Metadata(traceID).DistanceSlope(2) = slopes(4);
     
end%switch
[I,P,D] = GetMetadataByTracesId(gTraces,traceID);

set(handles.IntensityList,'String',I);
set(handles.PathLengthList,'String',P);
set(handles.DistanceList,'String',D);


 


% --- Executes on button press in PathLengthAddNew.
function PathLengthAddNew_Callback(hObject, eventdata, handles)
% hObject    handle to PathLengthAddNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PathLengthFit.
function PathLengthFit_Callback(hObject, eventdata, handles)
% hObject    handle to PathLengthFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DistanceSelectionAddNew.
function DistanceSelectionAddNew_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceSelectionAddNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DistanceFit.
function DistanceFit_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in IntensityList.
function IntensityList_Callback(hObject, eventdata, handles)
% hObject    handle to IntensityList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns IntensityList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from IntensityList
global gTraces;
gTraces.LastSelectedList = 'IntensityList';
contents = cellstr(get(hObject,'String'));
value = str2num(contents{get(hObject,'Value')});
res= xlim(handles.IntensityAxes);
set(handles.SectionSelectBar,'min',res(1));
set(handles.SectionSelectBar,'max',res(2));
set(handles.SectionSelectBar,'Value',value);
set(handles.SectionSelectBar,'SliderStep',[1/res(2),1/res(2)]);

% --- Executes during object creation, after setting all properties.
function IntensityList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IntensityList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PathLengthList.
function PathLengthList_Callback(hObject, eventdata, handles)
% hObject    handle to PathLengthList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PathLengthList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PathLengthList
global gTraces;
gTraces.LastSelectedList = 'PathLengthList';
contents = cellstr(get(hObject,'String'));
value =str2num(contents{get(hObject,'Value')});
res= xlim(handles.PathLengthAxes);
set(handles.SectionSelectBar,'min',res(1));
set(handles.SectionSelectBar,'max',res(2));

set(handles.SectionSelectBar,'Value',value);
set(handles.SectionSelectBar,'SliderStep',[1/res(2),1/res(2)]);

% --- Executes during object creation, after setting all properties.
function PathLengthList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PathLengthList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DistanceList.
function DistanceList_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DistanceList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DistanceList
global gTraces;
gTraces.LastSelectedList = 'DistanceList';
contents = cellstr(get(hObject,'String'));
value = str2num(contents{get(hObject,'Value')});
res= xlim(handles.DistanceAxes);
set(handles.SectionSelectBar,'min',res(1));
set(handles.SectionSelectBar,'max',res(2));
set(handles.SectionSelectBar,'Value',value);
set(handles.SectionSelectBar,'SliderStep',[1/res(2),1/res(2)]);


% --- Executes during object creation, after setting all properties.
function DistanceList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DistanceList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

 


% --- Executes on button press in IntensityAddNew.
function IntensityAddNew_Callback(hObject, eventdata, handles)
% hObject    handle to IntensityAddNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
IntensityDwell = [];
PathLengthSlope = [];
DistanceSlope = [];
DistanceRunLength = [];
for i = 1:gTraces.moleculenum
    metadata=gTraces.Metadata(i) ; 
    IntensityDwell(i) = metadata.IntensityDwell(1);
    
    if metadata.PathLengthSlope(2) ~=0
        PathLengthSlope(i) = metadata.PathLengthSlope(2)-metadata.PathLengthSlope(1);
    end
    if metadata.DistanceSlope(1) ~=0
        DistanceSlope(i) = metadata.DistanceSlope(1);   
        DistanceRunLength(i) = metadata.DistanceSlope(1)*(metadata.Distance(2)-metadata.Distance(1));
    end
end
DistanceRunLength(find(DistanceRunLength ==0)) = [];
PathLengthSlope(find(PathLengthSlope ==0)) = [];
DistanceSlope(find(DistanceSlope ==0)) = [];

numBinDRL = floor(max(DistanceRunLength)/2);%2nm res.
numBinPLS = floor(max(PathLengthSlope)*2);%0.5nm/s
numBinDS = floor(max(DistanceSlope)*2);%0.5nm/s

%hist(handles.IntensityAxes,IntensityDwell,500);
h1 = histogram(handles.IntensityAxes,DistanceRunLength,numBinDRL);
h2 = histogram(handles.PathLengthAxes,PathLengthSlope,numBinPLS);
h3 = histogram(handles.DistanceAxes,DistanceSlope,numBinDS);

axis(handles.IntensityAxes,[0,150,0,max(h1.Values)+5]);
axis(handles.PathLengthAxes,[0,25,0,max(h2.Values)+5]);
axis(handles.DistanceAxes,[0,25,0,max(h3.Values)+5]);

dwellTime = mean(IntensityDwell);
runLength = mean(DistanceRunLength);
velocity_PathLength = mean(PathLengthSlope);
velocity_Distance = mean(DistanceSlope);

title(handles.IntensityAxes,['mean runLength  =  ',num2str(runLength),' nm--------- mean dwell time = ',int2str(dwellTime),' s']);
title(handles.PathLengthAxes,['mean velocity(PathLength) =  ',num2str(velocity_PathLength),' nm/s']);
title(handles.DistanceAxes,['mean velocity(Distance) =  ',num2str(velocity_Distance),' nm/s']);
grid(handles.IntensityAxes,'on');
grid(handles.PathLengthAxes,'on');
grid(handles.DistanceAxes,'on');

% --- Executes on selection change in SetTypeList.
function SetTypeList_Callback(hObject, eventdata, handles)
% hObject    handle to SetTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SetTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SetTypeList
contents = cellstr(get(hObject,'String'));
selectedType = contents{get(hObject,'Value')};
global gTraces;
CurrentDisplayIndex= str2num(get(handles.CurrentDisplayIndex,'String'));
traceId = gTraces.CurrentShowIndex(CurrentDisplayIndex);
switch selectedType
    case 'All'
        gTraces.Metadata(traceId).SetCatalog = 'All';
    case 'Stuck_Go'
         gTraces.Metadata(traceId).SetCatalog = 'Stuck_Go';
    case 'Go_Stuck'
         gTraces.Metadata(traceId).SetCatalog = 'Go_Stuck';
    case 'Stuck_Go_Stuck'
         gTraces.Metadata(traceId).SetCatalog = 'Stuck_Go_Stuck';
    case 'Go_Stuck_Go'
         gTraces.Metadata(traceId).SetCatalog = 'Go_Stuck_Go';
    case 'NonLinear'      
         gTraces.Metadata(traceId).SetCatalog = 'NonLinear';
    case 'Perfect'      
         gTraces.Metadata(traceId).SetCatalog = 'Perfect';
end


% --- Executes during object creation, after setting all properties.
function SetTypeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SetTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
