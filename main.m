clc 
clear all 
close all

%% D?finition des constantes et de la variable principale : la temp?rature

% Constantes
Ptot=101325; %Pa (Wikipedia)
Cp_as = 1.005 % kJ/kg/K (the engineering toolbox)
Cp_eau = 4.180   %kJ/kg/K (the engineering toolbox)
Lv_eau = 2257.92 % kJ/kg (ThermExcel)
R=8.3144621; %J/mol/K (Wikipedia)
Mas= 28.96546*10^-3 ; %kg/mol (Metgen)
Mv= 18.01528*10^-3 ; %kg/mol (Wikipedia)

% Variables
Tmin=-15;
Tmax=50;
Tmax_affiche=Tmax+4; %valeur de temperature pour l'affichage et non pas pour le calul (pour avoir de la marge pour tracer les axes secondaires)
omega_maxaffich=0.06;

T=[Tmin:0.01:Tmax]; % on travaille avec une pr?cision au centi?me de degr?


%% Trac? du diagramme psychrometrique

figure(1) %figure diagramme 
hold 


%% Parametres de l'image : choix du format d'affichage

% taille de la feuille, on imprime (A3)
width = 29.7 ;     % Width in cm
height = 42;    % Height in cm
alw = 0.75;    % AxesLineWidth
fsz = 8;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

pbaspect([29.7 42 1])
set(gcf,'units','centimeters','position',[1,1,width,height])

%%  Mise en forme 

pos = get(gcf, 'Position');

title('\fontsize{13}Abaque psychrometrique simplifiee')

xlabel('T en {\circ}C')
ylabel('omega en kg/kg')
xlim([Tmin Tmax_affiche])
ylim([0 omega_maxaffich])

% Gestion des axes
axes=gca;
axes.YAxisLocation='right'
axes.FontSize=8;

%Vecteurs pour les ticks en abscisse et ordonnee   
abscisses=T(1:100:end);
ordonnees=[0:0.001:omega_maxaffich];

set(gca, 'FontSize', fsz, 'LineWidth', alw,'Box','off','XTick',abscisses,...
    'YTick',ordonnees); %<- Choix propri?t?s, choix notamment des graduations abscisses/ordonnees

    
%% Trac? des iso-humidit?s relatives

Pvs=pression_vapPa(T);
courbe_sat=0.621945.*(Pvs./(Ptot-Pvs));

for h=1:10
    plot(T, 0.1*h*courbe_sat, '-k','LineWidth',lw)
end 

% Trac? des l?gendes au dessus d'une courbe sur deux
Tlegende=2*Tmax/3; 
Pvs_legende=pression_vapPa(Tlegende);
courbe_sat_legende=0.621945.*(Pvs_legende./(Ptot-Pvs_legende));

pas=0.2;
for i=0.2:pas:1
    n=i*100;
    str=['\epsilon=' num2str(n) '%'];
    xt=Tlegende;
    yt=i*courbe_sat_legende;
    text(xt,yt+0.001,str,'FontSize',fsz,'Color','black','rotation',66*i)
end 



%% Courbes isenthalpes 

%pente pour tracer ensuite l'echelle transversale
pente_ech_H=Cp_as/Lv_eau; %oppose du coeff direct des isenthalpes, voir formule L.147

%calcul de l'intersection entre le bord de l'image et l'axe 
k=1; 
while courbe_sat(k)<=omega_maxaffich
    k=k+1;
end
b=omega_maxaffich-pente_ech_H*T(k); %coeff d'ordonnee a l'origine

Ech_h=pente_ech_H*T+b; %droite d'echelle
Angle_pente_H=atand(pente_ech_H*(height/width)*((T(end)-T(1))/omega_maxaffich)); %angle sur la figure finale

%%%%%%%%%%%%%%%%%%%%%%%% Axe enthalpie %%%%%%%%%%%%%%%%%%%

hmin=Cp_as.*T(1) + courbe_sat(1).*(Cp_eau.*T(1) +Lv_eau);
hmax=Cp_as.*T(end) + courbe_sat(end).*(Cp_eau.*T(end) +Lv_eau);

for h=-4:0.5:60 %nombre de droites, intervalle d'enthalpies
    
    h=4.184*h; %conversion du compteur dans la bonne unite
    iso_h=(h-Cp_as*T)./(Lv_eau+Cp_eau*T);  % fle de psychrometric news
    
    k=1; %compteur pour trouver l'intersection entre les isenthalpes et la courbe de saturation
    while iso_h(k)>courbe_sat(k)
        k=k+1;
    end
    
    %on repasse en valeurs entieres
    h=h/4.184;
    plot(T(k:end), iso_h(k:end), '-b') 

    
    %gestion de la legende : on met la legende au point d'intersection entre la courbe de
    %saturation et les isenthalpes
    if h<=47 
        %% -     --> 47 a revoir 
        
        if mod(h,2)==0 && k>=2%seulement 1/2
            str={h};
            text(T(k)-1,iso_h(k)+0.0003,str,'FontSize',fsz,'Color','blue','rotation', 0)
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

            text(T(k),Ech_h(k),'-','FontSize',fsz,'Color','blue','rotation',-Angle_pente_H)
            %idem, les bornes de h sont a recalculer
            if h>10 && h<49 && mod(h,1)==0
                str={h};
                text(T(k)-0.3,Ech_h(k),str,'FontSize',fsz,'Color','blue','rotation',Angle_pente_H)
                if h==26 %26 pour etre au milieu de l'axe
                    text(T(k)+0.5,Ech_h(k)+0.002,'h en kcal/kg','FontSize',12,'Color','blue','rotation', Angle_pente_H)
                end 
            end
    end

end

%axe diagonale des enthalpies
plot(T, Ech_h, '-b') 



%% Trac? des isovolumes specifiques

%Calcul precis
Vs_ord_min= ((Mv/Mas)) * (R*(Tmax+273.15)/(Ptot*Mv));  
Vs_ord_max=((Mv/Mas)+omega_maxaffich) * (R*(Tmax+273.15)/(Ptot*Mv));
Vs_abs_min= ((Mv/Mas)) * (R*(Tmin+273.15)/(Ptot*Mv));

%On les passe en valeurs avec 2 chiffres significatifs 
Vs_ord_min=fix(1000*Vs_ord_min)/1000;
Vs_ord_max=fix(1000*Vs_ord_max)/1000;
Vs_abs_min=fix(1000*Vs_abs_min)/1000;

for vs=Vs_abs_min:0.01:Vs_ord_max
    omega_vs=(vs.*Ptot.* Mv)./(R.*(T+273.15)) - (Mv/Mas); % source = Metgen
    k=1; %compteur 
    
    %on cherche l'intersection entre la courbe de saturation et les isovolumes
    while omega_vs(k)>courbe_sat(k)
        k=k+1;    
    end

    plot(T(k:end),omega_vs(k:end),'-r') 
    
end

% Trac? de l'axe des ordonn?es en volume sp?cifique

line([Tmax Tmax],[0 omega_maxaffich],'color','r')   

valeurs=[Vs_ord_min:0.005:Vs_ord_max];
for k=1:length(valeurs)
    om=(valeurs(k).*Ptot.* Mv)./(R.*(Tmax+273.15)) -( Mv /Mas); % abscisses des graduations
    str={valeurs(k)};
    text(Tmax+0.5,om,str,'Color','red','FontSize',fsz,'rotation', 0)
end 
text(Tmax,0.0601,{'volume specifique','en m^3/kg'},'Fontsize',fsz,'rotation',90, 'Color','red')

% graduations
valeurs_traits=[Vs_ord_min:0.001:Vs_ord_max];
for k=1:length(valeurs_traits)
    om=(valeurs_traits(k).*Ptot.* Mv)./(R.*(Tmax+273.15)) -(Mv/Mas); 
    line([Tmax Tmax+0.4],[om om],'color','r')
end 

% Trac? de l'axe des abscisses en volume sp?cifique

line([Tmin Tmax],[-0.001 -0.001],'color','r')

valeurs=[Vs_abs_min:0.01:Vs_ord_min];

for k=1:length(valeurs)
    temp=(valeurs(k)*Ptot*Mv-Mv*R*273.15/Mas)*Mas/(Mv*R);
    str={valeurs(k)};
    text(temp,-0.001,str,'FontSize',fsz,'Color','r')
end 
text(Tmax,-0.001,{'volume specifique','en m^3/kg'}, 'Color','red','Fontsize',fsz+2)

% graduations
valeurs_traits=[Vs_abs_min:0.001:Vs_ord_min];
for k=1:length(valeurs_traits)
    temp=(valeurs_traits(k)*Ptot*Mv-Mv*R*273.15/Mas)*Mas/(Mv*R);
    line([temp temp],[-0.001 -0.0015],'color','r')
end 


%% Trac? de la grille et des autres ?chelles 

%on trace la grille facilitant la lecture de T et de omega sous la courbe de sat
stem(T(1:100:end), courbe_sat(1:100:end), 'k','LineWidth',lw/4, 'Marker', '.') 

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
        T_vapsat(i)= fsolve(fun, i-5);
        plot([T_vapsat(i), Tmax_affiche],[ordonnees(i) ordonnees(i)],'color',[1 0.2 0.2],'LineWidth',lw/4);
    end 
    
    %Et on prolonge en pointilles l'axe des humidites relatives qui est le plus important 
    
end


%% Axe des pressions partielles

pressions_partiellesPa_max=pressionpartielle_fomega(omega_maxaffich,Ptot); 
pressions_partielleskgcm2_max=pressions_partiellesPa_max.*1E-5; 

pressions_partiellesPa_min=pressionpartielle_fomega(0,Ptot); 
pressions_partielleskgcm2_min=pressions_partiellesPa_min.*1E-5;

% valeurs sur l'axe
valeurs=[pressions_partielleskgcm2_min:0.005:pressions_partielleskgcm2_max];
valeursPa=valeurs./1E-5; %passage en bar
for k=1:length(valeurs)
    a=valeursPa(k);
    om=omega_fpression(a);
    str={valeurs(k)};
    text(Tmax+2.5,om,str,'FontSize',fsz, 'Color',[0 0.5 0.5],'rotation',0)
end 
text(Tmax+2,0.0601,{'pression partielle','en kg/cm^2'},'Fontsize',fsz+2,'rotation',90,'Color',[0 0.5 0.5])

%axe 
line([Tmax+2 Tmax+2], ylim,'Color',[0 0.5 0.5]); 

% graduations
valeurs_traits=[pressions_partielleskgcm2_min:0.001:pressions_partielleskgcm2_max];
valeursPa_traits=valeurs_traits./1E-5;
for k=1:length(valeurs_traits)
    a=valeursPa_traits(k);
    om=omega_fpression(a);
    line([Tmax_affiche-2 Tmax_affiche-1.6],[om om],'Color',[0 0.5 0.5])
end



%% Logo Phelma et Noms sur la figure

logo_Phelma=imread('logo.png');

imagesc([Tmin+5 Tmin+25], [0.06 0.052], logo_Phelma)

str = {'\itAlice  BOUDET','Ruben BRUNETAUD','EPEE 2016/2017'};
text(Tmin+5,0.052,str, 'Fontsize', 2*fsz, 'Interpreter', 'Tex')


%% Sauvegarde de l'image au format png

% % les lignes suivantes permettent de pr?server le format de l'image avant
% % de la sauvegarder
%             set(gcf,'InvertHardcopy','on');
%             set(gcf,'PaperUnits', 'centimeters');
%             papersize = get(gcf, 'PaperSize');
%             left = (papersize(1)- width)/2;
%             bottom = (papersize(2)- height)/2;
%             myfiguresize = [left, bottom, width, height];
%             set(gcf,'PaperPosition', myfiguresize);
%             
%         print('Diagramme','-dpng','-r200'); % sauvegarde l'image au format png

