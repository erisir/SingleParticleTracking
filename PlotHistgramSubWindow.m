function varargout = PlotHistgramSubWindow(varargin)
% PLOTHISTGRAMSUBWINDOW MATLAB code for PlotHistgramSubWindow.fig
%      PLOTHISTGRAMSUBWINDOW, by itself, creates a new PLOTHISTGRAMSUBWINDOW or raises the existing
%      singleton*.
%
%      H = PLOTHISTGRAMSUBWINDOW returns the handle to a new PLOTHISTGRAMSUBWINDOW or the handle to
%      the existing singleton*.
%
%      PLOTHISTGRAMSUBWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTHISTGRAMSUBWINDOW.M with the given input arguments.
%
%      PLOTHISTGRAMSUBWINDOW('Property','Value',...) creates a new PLOTHISTGRAMSUBWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlotHistgramSubWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlotHistgramSubWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlotHistgramSubWindow

% Last Modified by GUIDE v2.5 13-Oct-2020 19:07:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlotHistgramSubWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @PlotHistgramSubWindow_OutputFcn, ...
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


% --- Executes just before PlotHistgramSubWindow is made visible.
function PlotHistgramSubWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlotHistgramSubWindow (see VARARGIN)

% Choose default command line output for PlotHistgramSubWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PlotHistgramSubWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PlotHistgramSubWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PlotHistgram.
function PlotHistgram_Callback(hObject, eventdata, handles)
% hObject    handle to PlotHistgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gTraces;
