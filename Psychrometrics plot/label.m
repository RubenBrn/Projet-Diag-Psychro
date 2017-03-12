function [htext] = label(h,textString,varargin)
%LABEL places a label next to your data.  
% 
% This function provides an option between the legend and text or annotation commands
% for labeling data that you plot.  Edward Tufte
% says that data shouldn't stray far from its label, because
% the viewer of a graph should not need to repeatedly move his or her eyes
% back and forth between plotted data and the legend to connect the dots of
% which data are which.  In this spirit, label can be used to place a
% label directly on a plot close to the data it describes.  
%
%% Syntax 
% 
%  label(h,'string')
%  label(...,'location',LocationString)
%  label(...,'TextProperty',PropertyValue)
%  label(...,'slope')
%  h = label(...)
%
%% Description 
% 
% label(h,'string') places 'string' near the leftmost data described by
% handle h. 
%
% label(...,'location',LocationString) specifies location of the string.
% LocationString can be any of the following:
% 
% * 'left' or 'west' (default) 
% * 'right' or 'east' 
% * 'top' or 'north' 
% * 'bottom' or 'south' 
% * 'center' or 'middle' 
% 
% label(...,'TextProperty',PropertyValue) specifies text properties as
% name-value pairs. 
%
% label(...,'slope') attempts to angle text following the local slope of
% the data. 
%
% htext = label(...) returns the handle htext of the newly-created text
% object. 
% 
%% Author Info
% Written by Chad A. Greene of the University of Texas at Austin and its 
% Institute for Geophysics, July 2014. 
% 
% See also annotation, text, and legend. 
%% 

%assert(isobject(h)==1,'Input handle(s) h must be object.')
assert(isempty(get(gca,'children'))==0,'No current axes are open.') 
assert(isnumeric(textString)==0,'Label given by textString must be a string.') 
assert(nargin>=2,'Must input an object handle and corresponding label string.') 


location = 'left'; 
for k = 1:length(varargin) 
    if strncmpi(varargin{k},'loc',3)
        location = varargin{k+1}; 
        varargin(k:k+1)=[]; 
        break
    end
end

followSlope = false; 
for k = 1:length(varargin) 
    if strcmpi(varargin{k},'slope')
        followSlope = true; 
        varargin(k)=[]; 
        break
    end
end

%% 

color = get(h,'color'); 
xdata = get(h,'XData'); 
assert(isvector(xdata)==1,'Plotted data must be vector or scalar.') 
ydata = get(h,'YData'); 

gcax = get(gca,'xlim'); 
gcay = get(gca,'ylim'); 

if followSlope
    % slope is scaled because axes may not be equal:
    apparentTheta = atand(gradient(ydata,xdata).*(gcax(2)-gcax(1))/(gcay(2)-gcay(1))); 
end

% Find indices of data within figure window: 
ind = find(xdata>=gcax(1)&xdata<=gcax(2)&ydata>=gcay(1)&ydata<=gcay(2)); 

switch lower(location)
    case {'left','west','leftmost','westmost'}
        horizontalAlignment = 'left'; 
        verticalAlignment = 'bottom'; 
        x = min(xdata(ind));
        y = ydata(xdata==x);
        textString = [' ',textString]; 
        xi = xdata==x; 
        
    case {'right','east','rightmost','eastmost'}
        horizontalAlignment = 'right'; 
        verticalAlignment = 'bottom'; 
        x = max(xdata(ind)); 
        y = ydata(xdata==x);
        textString = [textString,' ']; 
        xi = xdata==x(1); 
        
    case {'top','north','topmost','northmost'}
        horizontalAlignment = 'left'; 
        verticalAlignment = 'top'; 
        y = max(ydata(ind));
        x = xdata(ydata==y);
        xi = xdata==x(1); 
        
    case {'bottom','south','southmost','bottommost'} 
        horizontalAlignment = 'left'; 
        verticalAlignment = 'bottom'; 
        y = min(ydata(ind));
        x = xdata(ydata==y);
        xi = xdata==x(1); 
        
    case {'center','central','middle','centered','middlemost','centermost'}
        horizontalAlignment = 'center'; 
        verticalAlignment = 'bottom'; 
        xi = round(mean(ind)); 
        if ~ismember(xi,ind)
            xi = find(ind<xi,1,'last'); 
        end
        x = xdata(xi); 
        y = ydata(xi);
        
        
    otherwise
        error('Unrecognized location string.') 
end
 
% Set rotation preferences: 
if followSlope
    theta = apparentTheta(xi); 
    if length(theta)>1
        theta=theta(end);
    end
else
    theta = 0; 
end

% Create the label: 
htext = text(x(1),y(1),textString,'color',color,'horizontalalignment',horizontalAlignment,...
    'verticalalignment',verticalAlignment,'rotation',theta); 

% Add any user-defined preferences: 
if length(varargin)>1 
    set(htext,varargin{:});
end


% Clean up: 
if nargout == 0
    clear htext
end

end



