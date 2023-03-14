function varargout = Main(varargin)
% MAIN MATLAB code for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventDaa,handles,...) calls the local
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

% Last Modified by GUIDE v2.5 13-Mar-2023 19:27:25

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
global Workspace;
global gPlots;
Workspace = 'F:\ExperimentalRawData\2023\';
%Workspace = 'F:\ExperimentalRawData\2022_2021_2020\20200519_[0,2,10,20nM]Cel7a_NaOH_ABCellulose_Good\2nM_10nM_20nM_Cel7a500pMQdot_NaOH_Cellulose\2nM\Metadata';
DirRoot = [fileparts( mfilename('fullpath') ) filesep];
DirBin = [DirRoot 'bin' filesep];
addpath(genpath(DirBin));

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
 
% --- Executes on button press in File.
function LoadImageStack_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadImageStack(handles);

% --- Executes on button press in LoadIRMImage.
function LoadIRMImage_Callback(hObject, eventdata, handles)
% hObject    handle to LoadIRMImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadIRMImage(handles);

% --- Executes on button press in LoadTraces.
function LoadTraces_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadTraces(handles);

% --- Executes on button press in InitMetadata.
function InitMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to InitMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InitializeTraces(handles);

% --- Executes on button press in LoadMetadata.
function LoadMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadMetadata(handles);

% --- Executes on button press in SaveMetadata.
function SaveMetadata_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMetadata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SaveMetadata(handles);

% --- Executes on button press in ShowHistgram. 
function ShowHistgram_Callback(hObject, eventdata, handles)
% hObject    handle to ShowHistgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function Slider_Threadhold_Low_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Threadhold_Low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ShowRawImageStack(handles);

% --- Executes on slider movement.
function Slider_Threadhold_High_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Threadhold_High (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ShowRawImageStack(handles);
 
% --- Executes on slider movement.
function Slider_Stack_Index_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Stack_Index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
SetSlideIndex(handles,round(get(hObject,'Value')),true);

function Current_Frame_Id_Callback(hObject, eventdata, handles)
% hObject    handle to Current_Frame_Id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_Frame_Id as text
%        str2double(get(hObject,'String')) returns contents of Current_Frame_Id as a double
SetSlideIndex(handles,str2double(get(hObject,'String')),true)

% --- Executes on button press in ShowPreviouTrace.
function ShowPreviouTrace_Callback(hObject, eventdata, handles)
% hObject    handle to ShowPreviouTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = str2double(get(handles.Current_Trace_Id,'String'));
updateAxes = 5;
PlotTrace(handles,index-1,updateAxes);

% --- Executes on button press in ShowNextTrace.
function ShowNextTrace_Callback(hObject, eventdata, handles)
% hObject    handle to ShowNextTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = str2double(get(handles.Current_Trace_Id,'String'));
updateAxes = 0;
PlotTrace(handles,index+1,updateAxes);

if handles.System_Debug.Value ==1
    set(handles.Traces_SetType_List,'Value',3);
    SetTraceCategory(handles,"Go_Stuck");%setdefault to go stuck
end


% --- Executes on button press in ShowNextNTraces.
function ShowNextNTraces_Callback(hObject, eventdata, handles)
% hObject    handle to ShowNextNTraces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start = str2double(get(handles.Current_Trace_Id,'String'));
number =  str2double(get(handles.MultiTracesNumber,'String'));
PlotMultipleTraces(handles,start,number)

% --- Executes on button press in ShowNextTrace.
function Current_Trace_Id_Callback(hObject, eventdata, handles)
% hObject    handle to Current_Trace_Id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_Trace_Id as text
%        str2double(get(hObject,'String')) returns contents of Current_Trace_Id as a double
index = str2double(get(hObject,'String'));
updateAxes = 0;
PlotTrace(handles,index,updateAxes);

% --- Executes on button press in DistanceAxes_Show_Both_Slope.
function DistanceAxes_Show_Both_Slope_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceAxes_Show_Both_Slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DistanceAxes_Show_Both_Slope
% automaticaly detected and checked if the start/end of 1 and 2 are different
index = str2double(get(handles.Current_Trace_Id,'String'));
updateAxes = 5;
PlotTrace(handles,index,updateAxes);

% --- Executes on button press in ShowRawIntensity.
function ShowRawIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to ShowRawIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowRawIntensity
index = str2double(get(handles.Current_Trace_Id,'String'));
updateAxes = 5;
PlotTrace(handles,index,updateAxes);

% --- Executes on slider movement. to set the start and end of processive
% movement
function Slider_Section_Select_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Section_Select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
time = floor(get(hObject,'Value'));
SetFittingsegment(handles,time);

% --- Executes on selection change in Intensity_Section_List.
function Intensity_Section_List_Callback(hObject, eventdata, handles)
% hObject    handle to Intensity_Section_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Intensity_Section_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Intensity_Section_List
AutoScaleAxes(handles,hObject);
% --- Executes on selection change in PathLength_Section_List.
function PathLength_Section_List_Callback(hObject, eventdata, handles)
% hObject    handle to PathLength_Section_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PathLength_Section_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PathLength_Section_List
AutoScaleAxes(handles,hObject);
% --- Executes on selection change in Distance_Section_List.
function Distance_Section_List_Callback(hObject, eventdata, handles)
% hObject    handle to Distance_Section_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Distance_Section_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Distance_Section_List
AutoScaleAxes(handles,hObject);

% --- Executes on selection change in Traces_SetType_List.
function Traces_SetType_List_Callback(hObject, eventdata, handles)
% hObject    handle to Traces_SetType_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Traces_SetType_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Traces_SetType_List
contents = cellstr(get(hObject,'String'));
category = contents{get(hObject,'Value')};
SetTraceCategory(handles,category);

% --- Executes on selection change in Traces_ShowType_List.
function Traces_ShowType_List_Callback(hObject, eventdata, handles)
% hObject    handle to Traces_ShowType_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Traces_ShowType_List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Traces_ShowType_List
contents = cellstr(get(hObject,'String'));
category = contents{get(hObject,'Value')};
ShowTraceCategory(handles,category);

% --- Executes when selected object is changed in Data_Quality_Set_Group.
function Data_Quality_Set_Group_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Data_Quality_Set_Group 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataQuality = handles.Data_Quality_Set_Group.SelectedObject.String;
SetTraceQuality(handles,dataQuality);

% --- Executes when selected object is changed in Data_Quality_Show_Group.
function Data_Quality_Show_Group_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Data_Quality_Show_Group 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.Traces_ShowType_List,'String'));
category = contents{get(handles.Traces_ShowType_List,'Value')};
ShowTraceCategory(handles,category);

function DistanceAxes_BinEnd_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceAxes_BinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DistanceAxes_BinEnd as text
%        str2double(get(hObject,'String')) returns contents of DistanceAxes_BinEnd as a double
PlotHistgram(handles);
function DistanceAxes_BinSize_Callback(hObject, eventdata, handles)
% hObject    handle to DistanceAxes_BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DistanceAxes_BinSize as text
%        str2double(get(hObject,'String')) returns contents of DistanceAxes_BinSize as a double
PlotHistgram(handles);
function PathLengthAxes_BinEnd_Callback(hObject, eventdata, handles)
% hObject    handle to PathLengthAxes_BinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathLengthAxes_BinEnd as text
%        str2double(get(hObject,'String')) returns contents of PathLengthAxes_BinEnd as a double
PlotHistgram(handles);
function PathLengthAxes_BinSize_Callback(hObject, eventdata, handles)
% hObject    handle to PathLengthAxes_BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PathLengthAxes_BinSize as text
%        str2double(get(hObject,'String')) returns contents of PathLengthAxes_BinSize as a double
PlotHistgram(handles);
function IntensityAxes_BinEnd_Callback(hObject, eventdata, handles)
% hObject    handle to IntensityAxes_BinEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IntensityAxes_BinEnd as text
%        str2double(get(hObject,'String')) returns contents of IntensityAxes_BinEnd as a double
PlotHistgram(handles);
function IntensityAxes_BinSize_Callback(hObject, eventdata, handles)
% hObject    handle to IntensityAxes_BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IntensityAxes_BinSize as text
%        str2double(get(hObject,'String')) returns contents of IntensityAxes_BinSize as a double
PlotHistgram(handles);

% --- Executes on mouse press over axes background.
function DistanceAxes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to DistanceAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = eventdata.Button;
if button ==1
    set(handles.Distance_Section_List,'Value',1);
end
if button ==3
    set(handles.Distance_Section_List,'Value',2);
end
time = eventdata.IntersectionPoint;
time(1)
SetFittingsegment(handles,time(1));


% --- Executes during object creation, after setting all properties.
function TrustBands_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrustBands (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ExportData.
function ExportData_Callback(hObject, eventdata, handles)
% hObject    handle to ExportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DataExporter(handles);



% --------------------------------------------------------------------
function ShowHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to ShowHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotHistgram(handles);

 



function TraceRotationAngle_Callback(hObject, eventdata, handles)
% hObject    handle to TraceRotationAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TraceRotationAngle as text
%        str2double(get(hObject,'String')) returns contents of TraceRotationAngle as a double


% --- Executes during object creation, after setting all properties.
function TraceRotationAngle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TraceRotationAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function FindReferenceMolecules_Callback(hObject, eventdata, handles)
% hObject    handle to FindReferenceMolecules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
gTraces.Config.fiducialMarkerIndex = FindFiducialIndex();


% --- Executes on button press in ApplyDriftCorrection.
function ApplyDriftCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyDriftCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ApplyDriftCorrection


% --------------------------------------------------------------------
function ShowReferenceMolecules_Callback(hObject, eventdata, handles)
% hObject    handle to ShowReferenceMolecules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ShowFiducialMarker();


 



function PlotRangeYLim_Callback(hObject, eventdata, handles)
% hObject    handle to PlotRangeYLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotRangeYLim as text
%        str2double(get(hObject,'String')) returns contents of PlotRangeYLim as a double
RangeYLim = get(hObject,'String');
global gPlots;
if ~isempty(RangeYLim)
    RangeYLim = split(RangeYLim,',');
    ylim(gPlots.GlobalXYPlotInNewWindow ,[str2num(RangeYLim{1}),str2num(RangeYLim{2})]);
end


 

% --- Executes during object creation, after setting all properties.
function PlotRangeYLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotRangeYLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PlotRangeXLim_Callback(hObject, eventdata, handles)
% hObject    handle to PlotRangeXLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotRangeXLim as text
%        str2double(get(hObject,'String')) returns contents of PlotRangeXLim as a double
RangeXLim = get(hObject,'String');
global gPlots;

if ~isempty(RangeXLim)
    RangeXLim = split(RangeXLim,',');
    xlim(gPlots.GlobalXYPlotInNewWindow ,[str2num(RangeXLim{1}),str2num(RangeXLim{2})]);
end


% --- Executes during object creation, after setting all properties.
function PlotRangeXLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotRangeXLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ShowAllTracesInTIRFImage_Callback(hObject, eventdata, handles)
% hObject    handle to ShowAllTracesInTIRFImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in ShowFullStackIntensity.
function ShowFullStackIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to ShowFullStackIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowFullStackIntensity


% --------------------------------------------------------------------
function ShowAllProcessiveTracesInTIRFImage_Callback(hObject, eventdata, handles)
% hObject    handle to ShowAllProcessiveTracesInTIRFImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ShowStaticTracesInTIRFImage_Callback(hObject, eventdata, handles)
% hObject    handle to ShowStaticTracesInTIRFImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
