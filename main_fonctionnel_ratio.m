clc 
clear all 
close all

%% Debut courbes de sat


% Hypotheses :
Ptot=101325; %Pa


% Constantes
Cp_as = 1.005 % kJ/kg/K (the engineering toolbox)
Cp_eau = 4.180   %kJ/kg/K (the engineering toolbox)
Lv_eau = 2257.92 % kJ/kg
Cpair_humide=1040; %J/kg/K    %Cpair_humide= %air Cpair + %eau Cpeau (Cpeau~4180 J/kg/K Cpair=1005 J/kg/K)
R=8,3144621; %J/mol/K
Mas= 28.96546*10^-3 ; %kg/mol
Mv= 18.01528*10^-3 ; 

hlg = 2501000; %J/kg
cw  = 1860;

% Variables
Tmin=-15;
Tmax=50;
Tmax_affiche=Tmax+4; %valeur de temperature pour l'affichage et non pas pour le calul
Tmin_affiche=Tmin+4;
omega_maxaffich=0.06;

T=[Tmin:0.01:Tmax]; %T augmente de 1 degre par pas de 100

%% Trace de omega en fct de T


Pvs_min=pression_vapPa(Tmin);
Pvs_max=pression_vapPa(Tmax);

omega_max=0.621945*(Pvs_max./(Ptot-Pvs_max)); 

vs_min= ((Mv/Mas)) * (R*(Tmin+273.15)/(Ptot*Mv));  
vs_max=((Mv/Mas)+omega_max) * (R*(Tmax+273.15)/(Ptot*Mv)); 

Pvs=pression_vapPa(T);
omega=0.621945.*(Pvs./(Ptot-Pvs)); % vient de psychrometric news

pressions_partiellesPa=pressionpartielle_fomega(omega,Ptot);
pressions_partielleskgcm2=pressions_partiellesPa.*1E-5;


%% Tracer du diagramme psychrometrique

figure(1) %figure diagramme 
hold 


%% Parametres de l'image 

% taille de la feuille o?? on imprime (A3)
width = 16.5;     % Width in inches
height = 23.4;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 10;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

%%%%%%%%% --> Choix du format d'affichage ici 

pbaspect([21 29.7 1])
%% %%%%%%%%%%%%%%%%%%%%%% Mise en forme  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos = get(gcf, 'Position');

%Vecteurs pour les ticks en abscisse et ordonnee
abscisses=T(1:100:end);
ordonnees=[0:0.001:omega_maxaffich];


set(gca, 'FontSize', fsz, 'LineWidth', alw,'Box','off','XTick',abscisses,...
    'YTick',ordonnees); %<- Choix propertees, choix notamment des graduations abscisses/ordonnees

title('Abaque psychrometrique simplifie')

xlabel('T en {\circ}C')
ylabel('omega en kg/kg')
xlim([Tmin Tmax_affiche])
ylim([0 omega_maxaffich])



% Gestion des axes
axes=gca;
axes.YAxisLocation='right'
axes.FontSize=8;



    
%% Trace de la courbe de saturation

Pvs=pression_vapPa(T);
courbe_sat=0.621945.*(Pvs./(Ptot-Pvs));


for h=1:10
    plot(T, 0.1*h*courbe_sat, '-k','LineWidth',lw,'MarkerSize',msz)
end 

Tlegende=2*Tmax/3;
Pvs_legende=pression_vapPa(Tlegende);
courbe_sat_legende=0.621945.*(Pvs_legende./(Ptot-Pvs_legende));

%droites et legendes selon les pourcentages d'humidite
pas=0.2;
for i=0:pas:1
    plot(T, i*courbe_sat, '-k')
    n=i*100;
    str=['\epsilon=' num2str(n) '%'];
    xt=Tlegende;
    yt=(i*courbe_sat_legende)+(0.0007)*exp(i/2); 
    text(xt,yt+0.001,str,'FontSize',10,'Color','black','rotation',65*i)

end 


title('Diagramme psychrometrique');

%% courbes isenthalpes 

%pente pour tracer ensuite l'echelle transversale
pente_ech_H=Cp_as/Lv_eau; %oppose du coeff direct des isenthalpes, voir formule L.147

%calcul de l'intersection entre le bord de l'image et l'axe 
k=1; 
while courbe_sat(k)<=omega_maxaffich
    k=k+1;
end
b=omega_maxaffich-pente_ech_H*T(k); %coeff d'ordonnee a l'origine

Ech_h=pente_ech_H*T+b; %droite d'echelle


%%%%%%%%%%%%%%%%%%%%%%%% Axe enthalpie %%%%%%%%%%%%%%%%%%%



for h=-4:0.5:60 %nombre de droites, intervalle d'enthalpies
    
    h=4.184*h; %conversion du compteur dans la bonne unite
    iso_h=(h-Cp_as*T)./(Lv_eau+Cp_eau*T);  % fle de psychrometric news
    %iso_h=1/2500*(h-1.826*T);
    
    k=1; %compteur pour trouver l'intersection entre Pv_sat et iso_h
    while iso_h(k)>courbe_sat(k)
        k=k+1;
    end
    
    %on repasse en valeurs entieres
    h=h/4.184;
    plot(T(k:end), iso_h(k:end), '-b') 

    
    %gestion de la legende 
    %on met la legende au point d'intersection entre courbes Pvsat et isenthapiques
    if h<=47 
        %% -     --> 47 a revoir 
        
        if mod(h,2)==0 && k>=2%seulement 1/2
            str={h};
            text(T(k-2),iso_h(k-2),str,'FontSize',10,'Color','blue','rotation',(h)/38*50)
        end
        
        %creation de l'echelle en diagonale
        
        %if 
        %intersection isenthalpes et axe diagonal 
            k=1;
            while iso_h(k)>=Ech_h(k) 
                k=k+1;
            end

            %on prolonge les courbes en pointilles jusqu'a l'echelle
            markerstep=10; %pour espacer les points des droites au dessus de la courbe de saturation
            plot(T(k:markerstep:end), iso_h(k:markerstep:end),'.b','MarkerSize',0.5)  

            text(T(k),Ech_h(k),'-','FontSize',10,'Color','blue','rotation',-45)
            if h>0 && h<49 && mod(h,1)==0
                str={h};
                text(T(k)-0.5,Ech_h(k)+0.0003,str,'FontSize',10,'Color','blue','rotation',55.5)
                if h==26 %26 pour etre au milieu de l'axe
                    text(T(k)+0.5,Ech_h(k)+0.002,'h en kcal/kg','FontSize',12,'Color','blue','rotation',atand( pente_ech_H ))
                end 
            end
    end

end

%axe diagonale des enthalpies
plot(T, Ech_h, '-b') 

%% Trace des isovolumes specifiques

%CHECK --> Valeur de Vs a calculer en fonction du reste 

for vs=0.70:0.01:1
    omega_vs=(vs.*Ptot.* Mv)./(R.*(T+273.15)) - (Mv/Mas); % formule exacte (file:///users/phelma/phelma2015/boudetal/Documents/Projet%20abaque%20air%20humide/docs%20ext%C3%A9rieurs/Calcul%20des%20param%C3%A8tres%20de%20l'air%20humide%20-%20Projet%20AntiSecos.htm
    k=1; %compteur 
    
    %on cherche l'intersection entre la courbe de saturation et les isovolumes
    while omega_vs(k)>courbe_sat(k)
        k=k+1;    
    end

    plot(T(k:end),omega_vs(k:end),'-r') 
    
end

%% Grid

%%%%%%%%%%% trace de la grille et des autres echelles %%%%%%%%%%%%%%

%on trace la grille verticale (selon les temperatures) sous la courbe de sat
stem(T(1:100:end), courbe_sat(1:100:end), 'k','LineWidth',lw/4, 'Marker', '.') 
%et la grille selon les ordonnes 

L_ordo=length(ordonnees);  

%on voit que la fonction fsolve fonctionne sur les T entre 50 et 11?C mais bug ensuite 
%dans une seconde boucle, on calcule donc la solution a la main pour aider le programme 
for i=2:L_ordo
    
    plot([Tmax,  Tmax_affiche], [ordonnees(i), ordonnees(i)],':k');
    
    omeg=ordonnees(i);
    fun = @(x) 0.621945.*(pression_vapPa(x)./(Ptot-pression_vapPa(x)))-omeg;
    if i>10
        T_vapsat(i) = fsolve(fun, i-10);
        plot([T_vapsat(i) Tmax],[ordonnees(i) ordonnees(i)],'color',[0.2 0.2 0.2],'LineWidth',lw/4);
    elseif i==2
        plot ([Tmin, Tmax], [ordonnees(i) ordonnees(i)],'color', [0.2 0.2 0.2],'LineWidth',lw/4);
    else 
        T_vapsat(i)= fsolve(fun, i);
        plot([T_vapsat(i), Tmax_affiche],[ordonnees(i) ordonnees(i)],'color',[1 0.2 0.2],'LineWidth',lw/4);
    end 
    
    %Et on prolonge en pointilles l'axe des humidites relatives qui est le plus important 
    
end

%% Axes secondaires

%%%%%% ordonnees Volume specifique %%%%%%%%%%%
% valeurs

line([Tmax Tmax],[0 100],'color','r')

%valeurs a calculer !!
Vs_ord_min=0.88;
Vs_ord_max=0.965;
Vs_abs_min=0.7;

valeurs=[Vs_ord_min:0.005:Vs_ord_max];
for k=1:length(valeurs)
    om=(valeurs(k).*Ptot.* Mv)./(R.*(Tmax+273.15)) -( Mv /Mas); 
    str={valeurs(k)};
    text(Tmax+0.5,om,str,'Color','red')
end 
text(Tmax,0.0601,{'volume specifique','en m^3/kg'},'Fontsize',10,'rotation',90, 'Color','red')

% graduations
valeurs_traits=[Vs_ord_min:0.001:Vs_ord_max];
for k=1:length(valeurs_traits)
    om=(valeurs_traits(k).*Ptot.* Mv)./(R.*(Tmax+273.15)) -(Mv/Mas); 
    line([Tmax Tmax+0.4],[om om],'color','r')
end 

%%%%%% abcisses %% Volume specifique %%%%%%%%%%%
line([Tmin 56],[-0.001 -0.001],'color','r')
%valeurs affichees
valeurs=[Vs_abs_min:0.01:Vs_ord_min];

for k=1:length(valeurs)
    temp=(valeurs(k)*Ptot*Mv-Mv*R*273.15/Mas)*Mas/(Mv*R);
    str={valeurs(k)};
    text(temp,-0.001,str,'Color','r')
end 
text(Tmax,-0.001,{'volume specifique','en m^3/kg'}, 'Color','red','Fontsize',10)

% graduations
valeurs_traits=[0.730:0.001:0.915];
for k=1:length(valeurs_traits)
    temp=(valeurs_traits(k)*Ptot*Mv-Mv*R*273.15/Mas)*Mas/(Mv*R);
    line([temp temp],[-0.001 -0.0015],'color','r')
end 


%%%%%%%%%% Ordonnees %% Pression Partielle %%%%%%%%%%

% valeurs sur l'axe
valeurs=[0:0.005:0.085];
valeursPa=valeurs./1E-5; %passage en bar
for k=1:length(valeurs)
    a=valeursPa(k);
    om=omega_fpression(a);
    str={valeurs(k)};
    text(Tmax+2.5,om,str, 'Color',[0 0.5 0.5])
end 
text(Tmax+2,0.0601,{'pression partielle','en kg/cm^2'},'Fontsize',10,'rotation',90,'Color',[0 0.5 0.5])

%axe 
line([Tmax+2 Tmax+2], ylim,'Color',[0 0.5 0.5]); 

% graduations
valeurs_traits=[0:0.001:0.085];
valeursPa_traits=valeurs_traits./1E-5;
for k=1:length(valeurs_traits)
    a=valeursPa_traits(k);
    om=omega_fpression(a);
    line([52 52.4],[om om],'Color',[0 0.5 0.5])
end



%% Logo Phelma et Noms sur la figure

logo_Phelma=imread('logo.png');

imagesc([Tmin+5 Tmin+25], [0.06 0.052], logo_Phelma)

str = {'\itAlice  BOUDET','Ruben BRUNETAUD'};
text(Tmin+5,0.052,str, 'Fontsize', 24, 'Interpreter', 'Tex')


%A enlever du mode commentaire pour sauvergarder l'image

%         Here we preserve the size of the image when we save it.
            set(gcf,'InvertHardcopy','on');
            set(gcf,'PaperUnits', 'inches');
            papersize = get(gcf, 'PaperSize');
            left = (papersize(1)- width)/2;
            bottom = (papersize(2)- height)/2;
            myfiguresize = [left, bottom, width, height];
            set(gcf,'PaperPosition', myfiguresize);
        
%         Save the file as PNG
%         r300 correspond a la definition
        print('Diagramme','-dpng','-r100');
