function varargout = Main_Touch(varargin)
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

% Last Modified by GUIDE v2.5 22-Jul-2020 02:43:01

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
warning off; 
global gImages;
LogMsg(handles,"Start to Load Stack");
if ~get(handles.System_Debug,'value')
    [file,path] = uigetfile('*.tif');
    gImages.filefullpath = [path,file];
    if path ==0
        return
    end
    gImages.rawImagesStack = FastReadTirf(gImages.filefullpath);
end

[gImages.imgHeight,gImages.imgWidth,gImages.stackSize]= size(gImages.rawImagesStack);
gImages.ZprojectMean = mean(gImages.rawImagesStack,3);
gImages.ZprojectMax = max(gImages.rawImagesStack,[],3);

intensity_low = floor(mean(mean(gImages.ZprojectMean)));
intensity_high = floor(max(max(gImages.ZprojectMean)));
 
set(handles.Slider_Threadhold_Low,'min',intensity_low/2);
set(handles.Slider_Threadhold_Low,'max',intensity_high/2);
set(handles.Slider_Threadhold_Low,'value',intensity_low/2);

set(handles.Slider_Threadhold_High,'min',intensity_low/2);
set(handles.Slider_Threadhold_High,'max',intensity_high/2);
set(handles.Slider_Threadhold_High,'value',intensity_high/2);
set(handles.Slider_Stack_Index,'Min',1);
set(handles.Slider_Stack_Index,'Max',gImages.stackSize);
set(handles.Slider_Stack_Index,'value',1);

imshow(gImages.ZprojectMean,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);

set(handles.Slider_Stack_Index,'SliderStep',[1/gImages.stackSize,0.01]);
set(handles.Slider_Threadhold_Low,'SliderStep',[2/intensity_high,0.01]);
set(handles.Slider_Threadhold_High,'SliderStep',[2/intensity_high,0.01]);

LogMsg(handles,["Finish Loading Stack   ",file]);

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
LogMsg(handles,"Start to Load IRM image");

gImages.IRMImage = mean(FastReadTirf(filefullpath),3);

intensity_low = floor(mean(mean(gImages.IRMImage)));
intensity_high = floor(max(max(gImages.IRMImage)));

set(handles.Slider_Threadhold_Low,'Value',intensity_low);
set(handles.Slider_Threadhold_High,'Value',intensity_high);
  
imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
LogMsg(handles,["Finish Loading IRM image  ",file]);

% --- Executes on button press in LoadTraces.
function LoadTraces_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gTraces;
global gImages;
LogMsg(handles,"Start to Load Traces Data");
defaultPath = 'F:\Box\DOE SCATTIRSTORM\3 Results\Experiment\Daguan\DataProcessing';
if ~get(handles.System_Debug,'value')
    [file,path] = uigetfile(defaultPath,'*.mat');
    filefullpath = [path,file];

    if path ==0
        return
    end

    gTraces = [];
    rawdata = load(filefullpath);
    gTraces.molecules = rawdata.Molecule;
    InitializeTracesMetadata();%prepare for adding new info[dwell,start,end,slope,etc.] to the traces
    gTraces.TracesPath = path;
end 

gTraces.fiducialMarkerIndex =FindFiducialIndex(gTraces,0);%auto find fiducial,dont plot it

[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty]=SmoothDriftTraces(gTraces,gTraces.fiducialMarkerIndex);%save the result to Traces struct

framecolumn = gTraces.molecules(gTraces.fiducialMarkerIndex(1)).Results(:,1);

gTraces.fiducialFrameIndicator = framecolumn;%save the start frame of the ficucial for substrate

PlotTrace(gImages,gTraces,1,handles,0);%plot all
 
set(handles.Current_Trace_Id,'String',int2str(1));
set(handles.TotalParticleNum,'String',int2str(gTraces.moleculenum));
LogMsg(handles,["Finish Loading Traces Data  ",file]);
set(handles.figure1,'Name',['FIESTA Data Processing-----------------       ', file]);

% --- Executes on button press in LoadMetadata.
function LoadMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
defaultPath = 'F:\Box\DOE SCATTIRSTORM\3 Results\Experiment\Daguan\DataProcessing';
if isempty(gTraces.TracesPath)
    [file,path] = uigetfile(defaultPath,'*.mat');
else
    [file,path] = uigetfile(gTraces.TracesPath,'*.mat');
end
if file ==0
    return;
end
filefullpath = [path,file];
matData = load(filefullpath);
LogMsg(handles,'start to Load Metadata');
%gTraces.Metadata = matData.metadata;%old save version

temp = matData.formatedSaveDataFormat;
gTraces.Metadata = temp.metadata;
gTraces.fiducialMarkerIndex = temp.fiducialMarkerIndex;
[gTraces.driftx,gTraces.drifty,gTraces.smoothDriftx,gTraces.smoothDrifty] = SmoothDriftTraces(gTraces,gTraces.fiducialMarkerIndex);
framecolumn = gTraces.molecules(gTraces.fiducialMarkerIndex(1)).Results(:,1);
gTraces.fiducialFrameIndicator = framecolumn;%save the start frame of the ficucial for substrate
set(handles.Frame_Expusure_Timems,'String',num2str(temp.ExpusureTimems));
set(handles.Frame_Transfer_Timems,'String',num2str(temp.FrameTrasferTimems));
try
    set(handles.DistanceAxes_BinSize,'String',num2str(temp.DistanceAxesBinSize));
    set(handles.DistanceAxes_BinEnd,'String',num2str(temp.DistanceAxesBinEnd));
    set(handles.PathLengthAxes_BinSize,'String',num2str(temp.PathLengthAxesBinSize));
    set(handles.PathLengthAxes_BinEnd,'String',num2str(temp.PathLengthAxesBinEnd));
    set(handles.IntensityAxes_BinSize,'String',num2str(temp.IntensityAxesBinSize));
    set(handles.IntensityAxes_BinEnd,'String',num2str(temp.IntensityAxesBinEnd));
    LogMsg(handles,"Finish Loading Metatata "+file);
catch
    LogMsg(handles,'Finish Loading Metatata,you need to set the binsize for histgram');
end

% --- Executes on button press in SaveMetadata.
function SaveMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
formatedSaveDataFormat.metadata = gTraces.Metadata;
formatedSaveDataFormat.fiducialMarkerIndex = gTraces.fiducialMarkerIndex;

formatedSaveDataFormat.ExpusureTimems = str2num(get(handles.Frame_Expusure_Timems,'String'));
formatedSaveDataFormat.FrameTrasferTimems = str2num(get(handles.Frame_Transfer_Timems,'String'));

formatedSaveDataFormat.DistanceAxesBinSize = str2num(get(handles.DistanceAxes_BinSize,'String'));
formatedSaveDataFormat.DistanceAxesBinEnd = str2num(get(handles.DistanceAxes_BinEnd,'String'));

formatedSaveDataFormat.PathLengthAxesBinSize = str2num(get(handles.PathLengthAxes_BinSize,'String'));
formatedSaveDataFormat.PathLengthAxesBinEnd = str2num(get(handles.PathLengthAxes_BinEnd,'String'));

formatedSaveDataFormat.IntensityAxesBinSize = str2num(get(handles.IntensityAxes_BinSize,'String'));
formatedSaveDataFormat.IntensityAxesBinEnd = str2num(get(handles.IntensityAxes_BinEnd,'String'));

defaultPath = 'F:\Box\DOE SCATTIRSTORM\3 Results\Experiment\Daguan\DataProcessing'; 
if isempty(gTraces.TracesPath)
    [file,path] = uiputfile(defaultPath,'*.mat');
else
    [file,path] = uiputfile(gTraces.TracesPath,'*.mat');
end
if path ==0
    return
end
save([path,file],'formatedSaveDataFormat'); 
LogMsg(handles,'Finish saving Metadata');
% --- Executes on button press in FindFiducialMarker.
function FindFiducialMarker_Callback(hObject, eventdata, handles)
% hObject    handle to FindFiducialMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
global gImages;
 
fiducialIndex = gTraces.fiducialMarkerIndex;
FindFiducialIndex(gTraces,1);

% --- Executes on button press in ShowFiducialMarker.
function ShowFiducialMarker_Callback(hObject, eventdata, handles)
% hObject    handle to ShowFiducialMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
 
figure;
handle = subplot(1,1,1);
fiducialIndex = gTraces.fiducialMarkerIndex ;
colNums = ceil(size(fiducialIndex,2)/2);
plot(handle,gTraces.smoothDriftx,gTraces.smoothDrifty,'r');
hold on;
str = ["smooth"];
for i = 1:size(fiducialIndex,2)
    x = gTraces.molecules(fiducialIndex(i)).Results(:,3);
    y = gTraces.molecules(fiducialIndex(i)).Results(:,4);
    str = [str,string(fiducialIndex(i))];
    plot(handle,x-x(1),y-y(1));
end
legend(str);

% --- Executes on slider movement.
function Slider_Threadhold_Low_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Threadhold_Low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global gImages;
intensity_high = floor(get(handles.Slider_Threadhold_High,'Value'));
intensity_low = get(hObject,'Value');

if intensity_low>=intensity_high
    set(hObject,'Value',intensity_high-1);
    intensity_low = intensity_high-11;
end

current_stack_Id = floor(get(handles.Slider_Stack_Index,'Value'));
stackSize = floor(get(handles.Slider_Stack_Index,'Max'));
try
switch current_stack_Id
    case 1
        imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
    case stackSize
        imshow(gImages.ZprojectMean,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
    otherwise
        imshow(gImages.rawImagesStack(:,:,current_stack_Id),[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);       
end
catch
    LogMsg(handles,'Show Image Error');
end

% --- Executes on slider movement.
function Slider_Threadhold_High_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Threadhold_High (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global gImages;
intensity_high = get(hObject,'Value');
intensity_low = floor(get(handles.Slider_Threadhold_Low,'Value'));

if intensity_low>=intensity_high
    set(hObject,'Value',intensity_low+1);
    intensity_high = intensity_low+1;
end

current_stack_Id = floor(get(handles.Slider_Stack_Index,'Value'));
stackSize = floor(get(handles.Slider_Stack_Index,'Max'));
try
    switch current_stack_Id
        case 1
            imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
        case stackSize
            imshow(gImages.ZprojectMean,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
        otherwise
            imshow(gImages.rawImagesStack(:,:,current_stack_Id),[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);       
    end
catch
    LogMsg(handles,'Show Image Error');
end

% --- Executes on slider movement.
function Slider_Stack_Index_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Stack_Index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global gImages;
global gTraces;
 
current_frameId =  floor(get(hObject,'Value')); 

intensity_low = get(handles.Slider_Threadhold_Low,'Value');
intensity_high = get(handles.Slider_Threadhold_High,'Value');
stackSize = floor(get(handles.Slider_Stack_Index,'Max'));
set(handles.Current_Frame_Id,'String',num2str(current_frameId));
current_tracesId = gTraces.CurrentShowIndex(str2num(get(handles.Current_Trace_Id,'String')));
try
switch current_frameId
    case 1
        imshow(gImages.IRMImage,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
    case stackSize
        imshow(gImages.ZprojectMean,[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);
    otherwise
        imshow(gImages.rawImagesStack(:,:,current_frameId),[intensity_low,intensity_high] ,'Parent',handles.ImageWindowAxes);  
        PlotTrace(gImages,gTraces,current_tracesId,handles,5);
end
catch
    LogMsg(handles,'Show Image Error');
end

function Current_Frame_Id_Callback(hObject, eventdata, handles)
% hObject    handle to Current_Frame_Id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_Frame_Id as text
%        str2double(get(hObject,'String')) returns contents of Current_Frame_Id as a double
global gImages;
global gTraces;
value = str2double(get(hObject,'String'));
set(handles.Slider_Stack_Index,'Value',value);
tracesId = gTraces.CurrentShowIndex(str2num(get(handles.Current_Trace_Id,'String')));
PlotTrace(gImages,gTraces,tracesId,handles,5);

% --- Executes on button press in ShowPreviouTrace.
function ShowPreviouTrace_Callback(hObject, eventdata, handles)
% hObject    handle to ShowPreviouTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = str2double(get(handles.Current_Trace_Id,'String'))-1;
global gTraces;
global gImages;
if index<1
    index = 1;
end
if index >gTraces.CurrentShowNums
    index = gTraces.CurrentShowNums;
end
set(handles.Current_Trace_Id,'String',int2str(index));
PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);

% --- Executes on button press in ShowNextTrace.
function ShowNextTrace_Callback(hObject, eventdata, handles)
% hObject    handle to ShowNextTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = str2double(get(handles.Current_Trace_Id,'String'))+1;
global gTraces;
global gImages;
    
if index<1
    index = 1;
end
if index >gTraces.CurrentShowNums
    index =gTraces.CurrentShowNums;
end
set(handles.Current_Trace_Id,'String',int2str(index));

PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);


% --- Executes on button press in ShowHistgram. 
function ShowHistgram_Callback(hObject, eventdata, handles)
% hObject    handle to ShowHistgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
PlotHistgram(handles,gTraces);

% --- Executes on button press in ShowNextTrace.
function Current_Trace_Id_Callback(hObject, eventdata, handles)
% hObject    handle to Current_Trace_Id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_Trace_Id as text
%        str2double(get(hObject,'String')) returns contents of Current_Trace_Id as a double
index = str2double(get(hObject,'String'));
global gTraces;
global gImages;

if index<1
    index = 1;
end
if index >gTraces.CurrentShowNums
    index = gTraces.CurrentShowNums;
end
set(handles.Current_Trace_Id,'String',int2str(index));
PlotTrace(gImages,gTraces,gTraces.CurrentShowIndex(index),handles,0);
 
% --- Executes on slider movement.
function Slider_Section_Select_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Section_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global gTraces;
global gImages;

slideBarValue = floor(get(hObject,'Value'));
index = str2num(get(handles.Current_Trace_Id,'String'));
traceID = gTraces.CurrentShowIndex(index);
 
switch gTraces.LastSelectedList
      case 'IntensityList'   
          selected  =floor(get(handles.Intensity_Section_List,'Value'));
          gTraces.Metadata(traceID).Intensity(selected) = slideBarValue;
         
          intensity = gTraces.Metadata(traceID).Intensity;
          gTraces.Metadata(traceID).IntensityDwell(1) = intensity(2)-intensity(1);
          gTraces.Metadata(traceID).IntensityDwell(2) = intensity(4)-intensity(3);
          PlotTrace(gImages,gTraces,traceID,handles,1);
 
      case 'PathLengthList'  
          selected  =floor(get(handles.PathLength_Section_List,'Value'));
          gTraces.Metadata(traceID).PathLength(selected) = slideBarValue;
                  
          slopes = PlotTrace(gImages,gTraces,traceID,handles,2);
          gTraces.Metadata(traceID).PathLengthSlope(1) = slopes(1);
          gTraces.Metadata(traceID).PathLengthSlope(2) = slopes(2);
             
      case 'DistanceList'        
         selected  =floor(get(handles.Distance_Section_List,'Value'));
          gTraces.Metadata(traceID).Distance(selected) = slideBarValue;
                   
          slopes =PlotTrace(gImages,gTraces,traceID,handles,3);
          gTraces.Metadata(traceID).DistanceSlope(1) = slopes(3);
          gTraces.Metadata(traceID).DistanceSlope(2) = slopes(4);
     
end%switch
[I,P,D] = GetMetadataByTracesId(gTraces,traceID);

set(handles.Intensity_Section_List,'String',I);
set(handles.PathLength_Section_List,'String',P);
set(handles.Distance_Section_List,'String',D);

% --- Executes on selection change in Intensity_Section_List.
function Intensity_Section_List_Callback(hObject, eventdata, handles)
% hObject    handle to Intensity_Section_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Intensity_Section_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Intensity_Section_List
global gTraces;
gTraces.LastSelectedList = 'IntensityList';
contents = cellstr(get(hObject,'String'));
value = str2num(contents{get(hObject,'Value')});
res= xlim(handles.IntensityAxes);
set(handles.Slider_Section_Select,'min',res(1));
set(handles.Slider_Section_Select,'max',res(2));
set(handles.Slider_Section_Select,'Value',value);
set(handles.Slider_Section_Select,'SliderStep',[1/(res(2)-res(1)),1/res(2)]);

% --- Executes on selection change in PathLength_Section_List.
function PathLength_Section_List_Callback(hObject, eventdata, handles)
% hObject    handle to PathLength_Section_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PathLength_Section_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PathLength_Section_List
global gTraces;
gTraces.LastSelectedList = 'PathLengthList';
contents = cellstr(get(hObject,'String'));
value =str2num(contents{get(hObject,'Value')});
res= xlim(handles.PathLengthAxes);
set(handles.Slider_Section_Select,'min',res(1));
set(handles.Slider_Section_Select,'max',res(2));

set(handles.Slider_Section_Select,'Value',value);
set(handles.Slider_Section_Select,'SliderStep',[1/(res(2)-res(1)),1/res(2)]);

% --- Executes on selection change in Distance_Section_List.
function Distance_Section_List_Callback(hObject, eventdata, handles)
% hObject    handle to Distance_Section_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Distance_Section_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Distance_Section_List
global gTraces;
gTraces.LastSelectedList = 'DistanceList';
contents = cellstr(get(hObject,'String'));
value = str2num(contents{get(hObject,'Value')});
res= xlim(handles.DistanceAxes);
set(handles.Slider_Section_Select,'min',res(1));
set(handles.Slider_Section_Select,'max',res(2));
set(handles.Slider_Section_Select,'Value',value);
set(handles.Slider_Section_Select,'SliderStep',[1/(res(2)-res(1)),1/(res(2)-res(1))]);

% --- Executes on selection change in Traces_SetType_List.
function Traces_SetType_List_Callback(hObject, eventdata, handles)
% hObject    handle to Traces_SetType_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Traces_SetType_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Traces_SetType_List
contents = cellstr(get(hObject,'String'));
selectedType = contents{get(hObject,'Value')};
global gTraces;
CurrentDisplayIndex= str2num(get(handles.Current_Trace_Id,'String'));
traceId = gTraces.CurrentShowIndex(CurrentDisplayIndex);
gTraces.Metadata(traceId).SetCatalog = selectedType;


% --- Executes on selection change in Traces_ShowType_List.
function Traces_ShowType_List_Callback(hObject, eventdata, handles)
% hObject    handle to Traces_ShowType_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Traces_ShowType_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Traces_ShowType_List
contents = cellstr(get(hObject,'String'));
selectedType = contents{get(hObject,'Value')};
global gTraces;
SetupCatalogByMetadata();
gTraces.CurrentShowTpye = selectedType;
switch selectedType
    case 'All'       
        gTraces.CurrentShowNums = gTraces.moleculenum ;
        gTraces.CurrentShowIndex = 1:gTraces.moleculenum;
    case 'Stuck_Go'
         gTraces.CurrentShowNums = size(gTraces.Stuck_Go,2);
         gTraces.CurrentShowIndex = gTraces.Stuck_Go;
    case 'Go_Stuck'
         gTraces.CurrentShowNums = size(gTraces.Go_Stuck,2);
         gTraces.CurrentShowIndex = gTraces.Go_Stuck;
    case 'Stuck_Go_Stuck'
         gTraces.CurrentShowNums = size(gTraces.Stuck_Go_Stuck,2);
         gTraces.CurrentShowIndex = gTraces.Stuck_Go_Stuck;
    case 'Go_Stuck_Go'
         gTraces.CurrentShowNums = size(gTraces.Go_Stuck_Go,2);
         gTraces.CurrentShowIndex = gTraces.Go_Stuck_Go;
    case 'NonLinear'      
         gTraces.CurrentShowNums = size(gTraces.NonLinear,2);
         gTraces.CurrentShowIndex = gTraces.NonLinear;
    case 'Stepping'      
         gTraces.CurrentShowNums = size(gTraces.Stepping,2);
         gTraces.CurrentShowIndex = gTraces.Stepping;
    case 'Perfect'      
         gTraces.CurrentShowNums = size(gTraces.Perfect,2);
         gTraces.CurrentShowIndex = gTraces.Perfect;
    case 'Temp'      
         gTraces.CurrentShowNums = size(gTraces.Temp,2);
         gTraces.CurrentShowIndex = gTraces.Temp;
end
set(handles.Current_Trace_Id,'String',num2str(1)); %go to the first
set(handles.TotalParticleNum,'String',int2str(gTraces.CurrentShowNums));

% --- Executes on button press in DistanceAxes_Show_Both_Slope.
function DistanceAxes_Show_Both_Slope_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceAxes_Show_Both_Slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DistanceAxes_Show_Both_Slope
global gImages;
global gTraces;
value = str2double(get(hObject,'String'));
set(handles.Slider_Stack_Index,'Value',value);
tracesId = gTraces.CurrentShowIndex(str2num(get(handles.Current_Trace_Id,'String')));
PlotTrace(gImages,gTraces,tracesId,handles,5);

% --- Executes on button press in ShowRawIntensity.
function ShowRawIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to ShowRawIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowRawIntensity
global gImages;
global gTraces;
value = str2double(get(hObject,'String'));
set(handles.Slider_Stack_Index,'Value',value);
tracesId = gTraces.CurrentShowIndex(str2num(get(handles.Current_Trace_Id,'String')));
PlotTrace(gImages,gTraces,tracesId,handles,5);

function DistanceAxes_BinEnd_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceAxes_BinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DistanceAxes_BinEnd as text
%        str2double(get(hObject,'String')) returns contents of DistanceAxes_BinEnd as a double
global gTraces;
PlotHistgram(handles,gTraces);

function DistanceAxes_BinSize_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceAxes_BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DistanceAxes_BinSize as text
%        str2double(get(hObject,'String')) returns contents of DistanceAxes_BinSize as a double
global gTraces;
PlotHistgram(handles,gTraces);

function PathLengthAxes_BinEnd_Callback(hObject, eventdata, handles)
% hObject    handle to PathLengthAxes_BinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathLengthAxes_BinEnd as text
%        str2double(get(hObject,'String')) returns contents of PathLengthAxes_BinEnd as a double
global gTraces;
PlotHistgram(handles,gTraces);

function PathLengthAxes_BinSize_Callback(hObject, eventdata, handles)
% hObject    handle to PathLengthAxes_BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathLengthAxes_BinSize as text
%        str2double(get(hObject,'String')) returns contents of PathLengthAxes_BinSize as a double
global gTraces;
PlotHistgram(handles,gTraces);

function IntensityAxes_BinEnd_Callback(hObject, eventdata, handles)
% hObject    handle to IntensityAxes_BinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IntensityAxes_BinEnd as text
%        str2double(get(hObject,'String')) returns contents of IntensityAxes_BinEnd as a double
global gTraces;
PlotHistgram(handles,gTraces);

function IntensityAxes_BinSize_Callback(hObject, eventdata, handles)
% hObject    handle to IntensityAxes_BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IntensityAxes_BinSize as text
%        str2double(get(hObject,'String')) returns contents of IntensityAxes_BinSize as a double
global gTraces;
PlotHistgram(handles,gTraces);
