function varargout = premierefigure(varargin)
% PREMIEREFIGURE MATLAB code for premierefigure.fig
%      PREMIEREFIGURE, by itself, creates a new PREMIEREFIGURE or raises the existing
%      singleton*.
%
%      H = PREMIEREFIGURE returns the handle to a new PREMIEREFIGURE or the handle to
%      the existing singleton*.
%
%      PREMIEREFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREMIEREFIGURE.M with the given input arguments.
%
%      PREMIEREFIGURE('Property','Value',...) creates a new PREMIEREFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before premierefigure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to premierefigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help premierefigure

% Last Modified by GUIDE v2.5 15-Mar-2017 22:19:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @premierefigure_OpeningFcn, ...
                   'gui_OutputFcn',  @premierefigure_OutputFcn, ...
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


% --- Executes just before premierefigure is made visible.
function premierefigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to premierefigure (see VARARGIN)

% Choose default command line output for premierefigure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles.output = hObject;
x=linspace(0,2*pi,200);
f=1;
handles.x=x;
handles.f=f;
plot(x,sin(f*x));
%handles
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes premierefigure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = premierefigure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)