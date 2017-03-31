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

figure(1)

%% En HD 
width = 16.5;     % Width in inches
height = 23.4;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

%%%%%%%%%%%%%%%%%%%%%%%% Mise en forme  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 'stem' trace les traits verticaux sous la courbe de saturation


hold 

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); % choix de la taille de l'image
set(gca, 'FontSize', fsz, 'LineWidth', alw,'Box','off'); %,'XTick',T(1:(1000/65):end-2)); %<- Set properties, choix notamment des graduations abscisses

title('Abaque psychrometrique simplifie')

xlabel('T en ?C')
ylabel('omega en kg/kg')

xlim([Tmin Tmax+15])
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

line([56 56],[0 100],'color','k')

% valeurs sur l'axe
valeurs=[0:0.005:0.075];
valeursPa=valeurs./1E-5;
for k=1:length(valeurs)
    a=valeursPa(k);
    om=omega_fpression(a);
    str={valeurs(k)};
    text(57,om,str)
end 
text(56,0.052,{'pression partielle','en kg/cm²'},'Fontsize',10,'rotation',90)

% graduations
valeurs_traits=[0:0.001:0.075];
valeursPa_traits=valeurs_traits./1E-5;
for k=1:length(valeurs_traits)
    a=valeursPa_traits(k);
    om=omega_fpression(a);
    line([56 56.7],[om om],'color','k')
end

    
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

%stockage d'une pente pour tracer ensuite l'echelle transversale
pente_ech_H=1/2500*1.826;
Ech_h=pente_ech_H*(T+31); %droite d'echelle
%axe enthalpie
plot(T, Ech_h, '-b') %droite 

for h=-4:60 %nombre de droites, intervalle d'enthalpies
    
    h=4.184*h; %conversion dans la bonne unite
    iso_h=1/2500*(h-1.826*T); %en valeur de omega
    k=1; %compteur pour trouver l'intersection entre Pv_sat et iso_h
    while iso_h(k)>courbe_sat(k)
        k=k+1;
    end
    
    h=h/4.184;
    markerstep=2; %pour espacer les points des pointillés
    plot(T(1:markerstep:k), iso_h(1:markerstep:k),'.b','MarkerSize',0.1)  % pointillés
    plot(T(k:end), iso_h(k:end), '-b') % ligne pleine
    
    
    %gestion de la legende 
    %on met la legende au point d'intersection entre courbes Pvsat et isenthalpiques
    if h<=55 % pour ne pas mettre mettre la légende dans la courbe
        if mod(h,2)==0%seulement 1/2


            str={h};
            text(T(k)-1,iso_h(k),str,'FontSize',10,'Color','blue','rotation',(h)/38*50)
        end
        
        %creation de l'echelle en diagonale
        k=1;
        while iso_h(k)>=Ech_h(k)
            k=k+1;
        end
        text(T(k),Ech_h(k),'-','FontSize',10,'Color','blue','rotation',-45)
        if h>=0 && h<49
            str={h};
            text(T(k)+0.5,Ech_h(k)+0.001,str,'FontSize',10,'Color','blue','rotation',56)
        	if h==26
                text(T(k)+0.5,Ech_h(k)+0.002,'h en kcal/kg','FontSize',12,'Color','blue','rotation',56)
            end 
        end
    end
    
end


%% Trace des volumes specifiques
for vs=0.75:0.01:1
    omega_vs=(vs.*Ptot.* Mv)./(R.*(T+273.15)) -( Mv /Mas); 
    
    k=1; %compteur 
    while omega_vs(k)>courbe_sat(k)
        k=k+1;     
    end
    %plot(T(1:k),omega_vs(1:k),':y') pas forcement necessaire de les prolonger
    plot(T(k:end),omega_vs(k:end),':red') 
    
end



% valeurs sur l'axe des ordonnées
line([50 50],[0 100],'color','k')
valeurs=[0.915:0.005:0.99];
for k=1:length(valeurs)
    om=(valeurs(k).*Ptot.* Mv)./(R.*(Tmax+273.15)) -( Mv /Mas); 
    str={valeurs(k)};
    text(51,om,str)
end 
text(51,0.052,{'volume spécifique','en m³/kg'},'Fontsize',10,'rotation',90)

% graduations
valeurs_traits=[0.915:0.001:0.99];
for k=1:length(valeurs_traits)
    om=(valeurs_traits(k).*Ptot.* Mv)./(R.*(Tmax+273.15)) -( Mv /Mas); 
    line([50 50.7],[om om],'color','k')
end 

% valeurs sur l'axe des abcisses
line([-15 56],[-0.001 -0.001],'color','k')
valeurs=[0.730:0.01:0.910];
for k=1:length(valeurs)
    temp=(valeurs(k)*Ptot*Mv-Mv*R*273.15/Mas)*Mas/(Mv*R);
    str={valeurs(k)};
    text(temp,-0.001,str)
end 
text(25,-0.001,{'volume spécifique','en m³/kg'},'Fontsize',10)

% graduations
valeurs_traits=[0.730:0.001:0.915];
for k=1:length(valeurs_traits)
    temp=(valeurs_traits(k)*Ptot*Mv-Mv*R*273.15/Mas)*Mas/(Mv*R);
    line([temp temp],[-0.001 -0.0015],'color','k')
end 



FigHandle = figure(1);
set(FigHandle, 'Position', [0, 0, 720, 800]);


% % A enlever du mode commentaire pour sauvergarder l'image
% %Here we preserve the size of the image when we save it.
% set(gcf,'InvertHardcopy','on');
%     set(gcf,'PaperUnits', 'inches');
%     papersize = get(gcf, 'PaperSize');
%     left = (papersize(1)- width)/2;
%     bottom = (papersize(2)- height)/2;
%     myfiguresize = [left, bottom, width, height];
%     set(gcf,'PaperPosition', myfiguresize);
% 
% % Save the file as PNG
% % r300 correspond a la definition
% print('Diagramme','-dpng','-r300');


%% Logo de Phelma


%imshow('phelma.png')






