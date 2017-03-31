clc 
clear all 
close all

%% Debut courbes de sat


% Hypotheses :
Ptot=101325; %Pa

% Cp constants
Cpair_humide=1040; %J/kg/K
R=8.314; %J/mol/K
Mas= 28.965338*10^-3 ; %kg/mol
Mv= 18.01528*10^-3 ; 

% Variables
Tmin=-15;
Tmax=50;

T=[Tmin:0.01:Tmax]; %T augmente de 1 degre par pas de 100

%% Trace de omega en fct de T


Pvs_min=pression_vapPa(Tmin);
Pvs_max=pression_vapPa(Tmax);

omega_max=0.622*(Pvs_max./(Ptot-Pvs_max)); %cours de Mr. Boichot


vs_min= ((Mv/Mas)) * (R*(Tmin+273.15)/(Ptot*Mv));  
vs_max=((Mv/Mas)+omega_max) * (R*(Tmax+273.15)/(Ptot*Mv)); 

%% Tracer du diagramme psychrometrique

figure(1)
hold 

%% Parametres de l'image 
width = 16.5;     % Width in inches
height = 23.4;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 10;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

%%%%%%%%%%%%%%%%%%%%%%%% Mise en forme  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos = get(gcf, 'Position');

abscisses=T(1:100:end);
ordonnees=[0:0.001:0.06];

set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); % choix de la taille de l'image
set(gca, 'FontSize', fsz, 'LineWidth', alw,'Box','off','XTick',abscisses,...
    'YTick',ordonnees); %<- Choix propertees, choix notamment des graduations abscisses/ordonnees

title('Abaque psychrometrique simplifie')
xlim([Tmin Tmax])
ylim([0 0.06])
xlabel('T en {\circ}C')
ylabel('omega en kg/kg')



% Gestion des axes
axes=gca;
axes.YAxisLocation='right'
axes.FontSize=10;

Pvs=pression_vapPa(T);
omega=0.622.*(Pvs./(Ptot-Pvs));

pressions_partiellesPa=pressionpartielle_fomega(omega,Ptot);
pressions_partielleskgcm2=pressions_partiellesPa.*1E-5;


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
for i=0:pas:1
    plot(T, i*courbe_sat, '-k')
    n=i*100;
    str=['\epsilon=' num2str(n) '%'];
    xt=Tlegende;
    yt=(i*courbe_sat_legende)+(0.0007)*exp(i/2); 
    text(xt,yt+0.001,str,'FontSize',10,'Color','black','rotation',70*i)

end 

%'Extent',[xt-1 yt-0.0015 3 0.003] pour tracer un carr?? blanc autour du
%texte mais ca marche pas

legend('f(x)', 'g(x)', 'f(x)=g(x)', 'Location', 'NorthWest');


title('Improved Example Figure');

%% courbes isenthalpes 

%stockage d'une pente pour tracer ensuite l'echelle transversale
pente_ech_H=1/2500*1.826;
Ech_h=pente_ech_H*(T+31); %droite d'echelle

%axe enthalpie
plot(T, Ech_h, '-b') %droite diagonale des enthalpies

for h=-4:0.5:60 %nombre de droites, intervalle d'enthalpies
    
    h=4.184*h; %conversion dans la bonne unite
    iso_h=1/2500*(h-1.826*T); %en valeur de omega
    
    k=1; %compteur pour trouver l'intersection entre Pv_sat et iso_h
    while iso_h(k)>courbe_sat(k)
        k=k+1;
    end
    
    h=h/4.184;
    plot(T(k:end), iso_h(k:end), '-b') 

    
    %gestion de la legende 
    %on met la legende au point d'intersection entre courbes Pvsat et isenthapiques
    if h<=55 
        if mod(h,2)==0 %seulement 1/2


            str={h};
            text(T(k)-1,iso_h(k),str,'FontSize',10,'Color','blue','rotation',(h)/38*50)
        end
        
        %creation de l'echelle en diagonale
        k=1;
        while iso_h(k)>=Ech_h(k)
            k=k+1;
        end
        
        %on prolonge les courbes en pointilles jusqu'a l'echelle
        markerstep=20; %pour espacer les points des droites au dessus de la courbe de saturation
        plot(T(k:markerstep:end), iso_h(k:markerstep:end),'.b','MarkerSize',0.1)  
        
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
    plot(T(k:end),omega_vs(k:end),'-r') 
    
end

FigHandle = figure(1);
set(FigHandle, 'Position', [100, 100, 1000, 1200]); %apercu de l'image finale au bon format sur Matlab 

%% Grid 

%on trace la grille selon les abcisses (des temperatures) sous la courbe de sat
stem(T(1:100:end), courbe_sat(1:100:end), 'k','LineWidth',lw/3, 'Marker', '.') 
%et la grille selon les ordonnes 
L_ordo=length(ordonnees);  


for i=1:L_ordo
    omeg=ordonnees(i);
    fun = @(x) 0.622.*(pression_vapPa(x)./(Ptot-pression_vapPa(x)))-omeg;
    T_vapsat(i) = fsolve(fun, i-10);
    plot([T_vapsat(i), Tmax],[ordonnees(i) ordonnees(i)],'color',[0.2 0.2 0.2]);
end


%% Logo Phelma 

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

