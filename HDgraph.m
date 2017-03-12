clc
clear all 

%% test Code HD 
f = @(x) x.^2;
g = @(x) 5*sin(x)+5;
dmn = -pi:0.001:pi;
xeq = dmn(abs(f(dmn) - g(dmn)) < 0.002);
figure(1);
plot(dmn,f(dmn),'b-',dmn,g(dmn),'r--',xeq,f(xeq),'g*');
xlim([-pi pi]);
legend('f(x)', 'g(x)', 'f(x)=g(x)', 'Location', 'SouthEast');
xlabel('x');
title('Example Figure');
print('example', '-dpng', '-r300'); %<-Save as PNG with 300 DPI
%<img src="example.png" height=300>

%% Taile de l'image 

% Defaults for this blog post
width = 30;     % Width in inches
height = 30;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

figure(2);
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
plot(dmn,f(dmn),'b-',dmn, g(dmn),'r--',xeq,f(xeq),'g*','LineWidth',lw,'MarkerSize',msz); %<- Specify plot properites
xlim([-pi pi]);
legend('f(x)', 'g(x)', 'f(x)=g(x)', 'Location', 'SouthEast');
xlabel('x');
title('Improved Example Figure');
