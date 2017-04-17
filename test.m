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


    
%% Trace de la courbe de saturation

Pvs=pression_vapPa(T);
courbe_sat=0.621945.*(Pvs./(Ptot-Pvs));
 
Tlegende=2*Tmax/3;
Pvs_legende=pression_vapPa(Tlegende);
courbe_sat_legende=0.621945.*(Pvs_legende./(Ptot-Pvs_legende));

pas=0.2;
for i=0:pas:1
    plot(T, i*courbe_sat, '-k')
    n=i*100;
    str=['\epsilon=' num2str(n) '%'];
    xt=Tlegende;
    yt=(i*courbe_sat_legende)+(0.0007)*exp(i/2); 
    text(xt,yt+0.001,str,'FontSize',10,'Color','black','rotation',65*i)

end 

%'Extent',[xt-1 yt-0.0015 3 0.003] pour tracer un carr?? blanc autour du
%texte mais ca marche pas

%legend('f(x)', 'g(x)', 'f(x)=g(x)', 'Location', 'NorthWest');


title('Improved Example Figure');

%% courbes isenthalpes 

%pente pour tracer ensuite l'echelle transversale
pente_ech_H=1/2500*1.826;

Ech_h=pente_ech_H*(T+31); %droite d'echelle

%le 31 est a revoir pour optimiser au mieux l'intersection de l'axe et du bord de l'image 

%%%%%%%%%%%%%%%%%%%%%%%% Axe enthalpie %%%%%%%%%%%%%%%%%%%



for h = -4:0.5:60 %nombre de droites, intervalle d'enthalpies
    
    h = 4.184*h; %conversion du compteur dans la bonne unite
    iso_h(1,:) = (h-Cp_as*T)./(Lv_eau+Cp_eau*T);  % fle de psychrometric news
    iso_h(2,:) = 1/2500*(h-1.826*T);
end 

