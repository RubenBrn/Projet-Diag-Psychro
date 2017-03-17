
function varargout = my_gui(varargin)
% MY_GUI MATLAB code for my_gui.fig
%      MY_GUI, by itself, creates a new MY_GUI or raises the existing
%      singleton*.
%
%      H = MY_GUI returns the handle to a new MY_GUI or the handle to
%      the existing singleton*.
%
%      MY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MY_GUI.M with the given input arguments.
%
%      MY_GUI('Property','Value',...) creates a new MY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before my_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to my_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help my_gui

% Last Modified by GUIDE v2.5 15-Mar-2017 23:09:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @my_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @my_gui_OutputFcn, ...
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




function my_MouseClickFcn(obj,event,hObject)
handles=guidata(hObject);
set(handles.figure1,'WindowButtonMotionFcn',{@my_MouseMoveFcn,hObject});
guidata(hObject,handles)
 
function my_MouseReleaseFcn(obj,event,hObject)
handles=guidata(hObject);
set(handles.figure1,'WindowButtonMotionFcn','');
guidata(hObject,handles);

% --- Executes just before my_gui is made visible.
function my_gui_OpeningFcn(hObject, eventdata, handles, varargin)
%%
% x=-10:0.1:100;
% f=1;
% handles.x=x;
% handles.f=f;
% plot(x,sin(f*x));


Ptot=101325; %Pa

% Cp constants
Cpair_humide=1040; % J/kg/K

% Variables
Tmin=5;
Tmax=50;

pas=linspace(Tmin, Tmax, 100);

% Echelles principales
Temp=[Tmin:0.1:Tmax];


Pvs=pression_vapPa(Temp);

Pvs_omega=0.622*(Pvs./(Ptot-Pvs));
handles
hold on
for i=1:10
handles.f=0.1*i*Pvs_omega;  
    plot(Temp, handles.f, '-k')

end 
handles
grid on
% courbes isenthalpes 

for i=1:20 %nombre de droites
    
    h0=10; %enthalpie de base, choisie au hasard
    
    iso_h=1/2500*((h0*i)-1.826*Temp); 
    
    %boucle pour tracer uniquement les bonnes valeurs 
    k=1; %compteur 
    while iso_h(k)>Pvs_omega(k)
        k=k+1;
    end
    plot(Temp(1:k), iso_h(1:k), ':b')  
    plot(Temp(k:end), iso_h(k:end), '-b')  
end

% Trac? des volumes sp?cifiques

R=8.314; % J/mol/K
Mas= 28.965338E-3 ; %kg/mol
Mv= 18.01528E-3 ; 

for vs=0.75:0.01:1
    omega_vs=(vs.*Ptot.*Mv)./(R.*(Temp+273.15)) -(Mv/Mas); % pas la bonne ?quation
    k=1; %compteur 
    while omega_vs(k)>Pvs_omega(k)
        k=k+1;
         
    end
    plot(Temp(1:k),omega_vs(1:k),':r')
    plot(Temp(k:end),omega_vs(k:end),'r')
    %legend('volume sp?cifique en m^3/kg') %% probl?me
end

% Update handles structure
guidata(hObject, handles);

%%
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to my_gui (see VARARGIN)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matlabvn_mouse (see VARARGIN)
set(hObject,'WindowButtonDownFcn',{@my_MouseClickFcn,hObject});
set(hObject,'WindowButtonUpFcn',{@my_MouseReleaseFcn,hObject});
axes(handles.axes1);
set(handles.axes1,'xlim',[Tmin Tmax],'ylim',[0 0.05]);
handles.redbox=patch([1, 2, 2, 1, 1],[1, 1, 1, 1, 1], 'r');
% Choose default command line output for matlabvn_mouse


% Choose default command line output for my_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes my_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = my_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(hObject);
mousepos=get(handles.axes1,'CurrentPoint');
x=get(handles.redbox,'xdata');
y=get(handles.redbox,'ydata');
x_rel=x-x(1);
y_rel=y-y(1);
set(handles.redbox,'xdata',mousepos(1,1)+x_rel);
set(handles.redbox,'ydata',mousepos(1,2)+y_rel);
% handles.value(1)=x_rel;
% handles.value(2)=y_rel;
x
y

guidata(handles.redbox,handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_WindowButtonMotionFcn(hObject, eventdata, handles)



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%datelist={'Mon','Tue','Wed','Thurs','Fri','Sat','Sun'};
%listbox1= uicontrol('style','list','string',datelist,'max',6,'background','w');
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% datelist=['blabla'];
% listbox_date= uicontrol('style','list','string',datelist,'max',2,'background','w');
% pushbutton_add=uicontrol('style','pushbutton','string','ADD','background','w');
% edit_newitem=uicontrol('style','edit','string','','background','w');
% set(listbox_date,'unit','norm','position',[0.3 0.1 0.4 0.6]);


