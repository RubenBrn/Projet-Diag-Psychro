clc
clear all 
close all 

hold all
X=[0:1:10];
% create the plot/graph
plot(X,10*X);
% GET handle to current axes and move the plot axes to the bottom
% 
% ha =gca;
% uistack(ha,'bottom');
% % Creating a new axes for the logo on the current axes
% % To create the logo at the bottom left corner of the plot use 
% % the next two lines
% haPos = get(ha,'position');
% ha2=axes('position',[haPos(1:2), .1,.04,]);
% % To place the logo at the bottom left corner of the figure window
% % uncomment the line below and comment the above two lines
% % ha2=axes('position',[0, 0, .1,.04,]);
% % Adding a LOGO to the new axes
% 

% image(x)
% % Setting the colormap to the colormap of the imported logo image
% colormap (map)
% % Turn the handlevisibility off so that we don't inadvertently plot
% % into the axes again. Also, make the axes invisible
% set(ha2,'handlevisibility','off','visible','off')  ], x);