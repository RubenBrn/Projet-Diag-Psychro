clc
clear all

%% Fonction trouv?e sur internet 

function gui_example
 
pente = 1;
freq = 1;
 
hfig=figure;
axes('parent', hfig,...
    'units', 'normalized', 'position', [0.1 0.3 0.8 0.6],...
    'tag', 'axes');
uicontrol('style', 'slider',...
    'units', 'normalized', 'position', [0.4 0.175 0.2 0.075],...
    'Min',-1, 'Max', 1, 'Value', pente,...
    'callback', @(src, evnt)sld_pente_cb(src), 'tag', 'sld_pente');
uicontrol('style', 'slider',...
    'units', 'normalized', 'position', [0.4 0.05 0.2 0.075],...
    'Min',1, 'Max', 10, 'Value', freq,...
    'callback', @(src, evnt)sld_freq_cb(src),  'tag', 'sld_freq');
 
handles = guihandles(hfig);
 
t = -1:1/(30*freq):1;
droite = pente*t;
sinusoide = sin(2*pi*freq*t);
 
handles.plot=plot(handles.axes, t, droite, t, sinusoide);
 
guidata(hfig, handles);
 
function sld_pente_cb(src)
handles = guidata(src);
droite = get(src, 'Value')*get(handles.plot(1),'XData');
set(handles.plot(1), 'YData', droite);
 
function sld_freq_cb(src)
handles = guidata(src);
freq =  get(src, 'Value');
t = -1:1/(30*freq):1;
sinusoide = sin(2*pi*freq*t);
set(handles.plot(2), 'XData', t, 'YData', sinusoide);