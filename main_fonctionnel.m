clc 
clear all 
close all

%% Debut courbes de sat


% Hypotheses :
Ptot=101325; %Pa

% Cp constants
Cpair_humide=1040; % J/kg/K

R=8.314; % J/mol/K
Mas= 28.965338*10^-3 ; %kg/mol
Mv= 18.01528*10^-3 ; 

% Variables
Tmin=-15;
Tmax=50;


T=linspace(Tmin, Tmax, 1000);


%Nb de courbes iso


nb_iso=20; %nombre de courbes iso par fenetre


%% Trace de omega en fct de T


Pvs_min=pression_vapPa(Tmin);
Pvs_max=pression_vapPa(Tmax);

omega_max=0.622*(Pvs_max./(Ptot-Pvs_max));


vs_min= ((Mv/Mas)) * (R*(Tmin+273.15)/(Ptot*Mv));  
vs_max=((Mv/Mas)+omega_max) * (R*(Tmax+273.15)/(Ptot*Mv)); 

h_min=0; % mettre les formules en fonction de T
h_max=300;



%% Tracer du diagramme psychrometrique

figure()


%creation d'un nouvel axe

%% Passer la figure en HD 
width = 5;     % Width in inches
height = 7;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

%%%%%%%%%%%%%%%%%%%%%%%% Mise en forme  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 'stem' trace les traits verticaux sous la courbe de saturation


hold 
 pos = get(gcf, 'Position');
 set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
% set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

title('Abaque psychrometrique simplifie')

xlabel('T en ??C')
ylabel('omega en kg/kg')

xlim([Tmin Tmax])
ylim([0 0.05])

% Gestion des axes
axes=gca;
axes.YAxisLocation='right'
axes.FontSize=12;
%axes.FontWeight='bold';

%Echelles secondaires

Pvs=pression_vapPa(T);
omega=0.622.*(Pvs./(Ptot-Pvs));

pressions_partiellesPa=pressionpartielle_fomega(omega,Ptot);
pressions_partielleskgcm2=pressions_partiellesPa.*1E-5;

plotyy(T,omega,T,pressions_partielleskgcm2,'plot');

%% Trac?? de la courbe de saturation

Pvs=pression_vapPa(T);
courbe_sat=0.622.*(Pvs./(Ptot-Pvs));


for h=1:10
    plot(T, 0.1*h*courbe_sat, '-k','LineWidth',lw,'MarkerSize',msz)
end 

Tlegende=2*Tmax/3;
Pvs_legende=pression_vapPa(Tlegende);
courbe_sat_legende=0.622.*(Pvs_legende./(Ptot-Pvs_legende));

pas=0.2;
for i=pas:pas:1
    plot(T, i*courbe_sat, '-k')
    n=i*100;
    str=['\epsilon=' num2str(n) '%'];
    xt=Tlegende;
    yt=(i*courbe_sat_legende)+(0.0007)*exp(i/2); 
    text(xt,yt,str,'FontSize',10,'Color','black','rotation',60*i)

end 

%'Extent',[xt-1 yt-0.0015 3 0.003] pour tracer un carr?? blanc autour du
%texte mais ??a marche pas

legend('f(x)', 'g(x)', 'f(x)=g(x)', 'Location', 'SouthEast');


title('Improved Example Figure');

%% courbes isenthalpes 

for h=-4:50 %nombre de droites, intervalle d'enthalpies
    
     %enthalpie de base, choisie au hasard
    h=4.184*h;
    iso_h=1/2500*((h)-1.826*T); %en valeur de omega
    
    %boucle pour tracer uniquement les bonnes valeurs 
    k=1; %compteur pour trouver l'intersection entre Pv_sat et iso_h
    while iso_h(k)>courbe_sat(k)
        k=k+1;
    end
    
    %on met la l?gende en ce point d'intersection
    h=h/4.184;
    if mod(h,2)==0 && h<=38%seulement 1/2
        
        
        str={h};
        text(T(k)-1,iso_h(k),str,'FontSize',10,'Color','blue','rotation',(h)/38*50)
        text(T(k),iso_h(k),'x','FontSize',10,'Color','black','rotation',(h+10)/21*45)
    end 
    if mod(h,2)==0 && h>38 %seulement 1/2
        
        
        str={h};
        text(T(k)-1,iso_h(k),str,'FontSize',10,'Color','red','rotation',(h)/38*50)
       
    end 

    plot(T(1:k), iso_h(1:k), ':b')  
    plot(T(k:end), iso_h(k:end), '-b')  
end

% Trace des volumes specifiques

for vs=0.75:0.01:1
    omega_vs=(vs.*Ptot.* Mv)./(R.*(T+273.15)) -( Mv /Mas); 
    k=1; %compteur 
    
    while omega_vs(k)>courbe_sat(k)
        k=k+1;
         
    end
    %plot(T(1:k),omega_vs(1:k),':y') pas forcement necessaire de les prolonger
    plot(T(k:end),omega_vs(k:end),':red') 
    
end

%% axes droites isenthalpiques


hax=axes; 
SP=-15; %your point goes here 


% Here we preserve the size of the image when we save it.
% set(gcf,'InvertHardcopy','on');
    % set(gcf,'PaperUnits', 'inches');
    % papersize = get(gcf, 'PaperSize');
    % left = (papersize(1)- width)/2;
    % bottom = (papersize(2)- height)/2;
    % myfiguresize = [left, bottom, width, height];
    % set(gcf,'PaperPosition', myfiguresize);

% Save the file as PNG
%r300 correspond a la definition
%print('improvedExample','-dpng','-r300');

