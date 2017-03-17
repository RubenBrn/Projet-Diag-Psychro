clc
clear all
close all

% Constantes
Cpair_humide=1040; % J/kg/K
R=8.314; % J/mol/K
Mas= 28.965338E-3 ; %kg/mol
Mv= 18.01528E-3 ; 

% Variables
Ptot=101325; %Pa

Tmin=5;
Tmax=40;
T=linspace(Tmin,Tmax,100);

nbe_iso=20; % 20 courbes de chaque type par niveau de zoom


% Valeurs min et max pour chaque courbe dans la fenêtre qui va s'afficher

Pvs_min=pression_vapPa(Tmin);
Pvs_max=pression_vapPa(Tmax);

omega_min=0;  % sinon les iso-courbes ne sont pas sous toute la courbe de saturation
%omega_min=0.622.*(Pvs_min./(Ptot-Pvs_min));
omega_max=0.622.*(Pvs_max./(Ptot-Pvs_max));


vs_min= ((Mv/Mas)+omega_min) * (R*(Tmin+273.15)/(Ptot*Mv));  
vs_max=((Mv/Mas)+omega_max) * (R*(Tmax+273.15)/(Ptot*Mv)); 

h_min=0; % mettre les formules en fonction de T
h_max=300;



% %Echelles secondaires
% pressions_partiellesPa=pressionpartielle_fomega(humidites_absolues,Ptot);
% pressions_partielleskgcm2=pressions_partiellesPa.*1E-5;



%% Tracé du diagramme psychrométrique

figure()
hold all


%%%%%%%%%%%%%%%%%%%%%%%% Mise en forme  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xlabel('T en °C')
ylabel('omega en kg/kg')

ylim([0 0.04])

% Positionnement de l'axe des ordonées à droite
axes=gca;
axes.YAxisLocation='right'

% Mettre les valeurs de epsilon le long de la courbe



%%%%%%%%%%%%%%%%%%%% Tracé de la courbe de saturation %%%%%%%%%%%%%%%%%%%%

Pvs=pression_vapPa(T);
courbe_sat=0.622.*(Pvs./(Ptot-Pvs));

for j=0:0.2:1
    plot(T,j*courbe_sat,'k')
end

% Comment mettre nbe_iso courbes dans la fenêtre????????????????????


%%%%%%%%%%%%%%%%%%% Tracé des iso-volume spécifique %%%%%%%%%%%%%%%%%%%%%%

vs=linspace(vs_min,vs_max,nbe_iso);

for c=1:length(vs)
   omega_vs=(vs(c).*Ptot.*Mv)./(R.*(T+273.15)) -(Mv/Mas); 
   
   %boucles pour faire le tracé uniquement sous la courbe de saturation
   k=1; 
   while omega_vs(k)>courbe_sat(k) 
        k=k+1;
   end
   
   i=100;
%    i=k;
%    while omega_vs(i) >0 || i<length(omega_vs)
%        i=i+1;
%    end
   
   plot(T(k:i),omega_vs(k:i),'r')
   
end
legend('volume spécifique en m^3/kg') %% problème


%%%%%%%%%%%%%%%%%%%%%%%%%% Tracé des isenthalpes %%%%%%%%%%%%%%%%%%%%%%%%%

h=linspace(h_min,h_max,nbe_iso);

for d=1:length(h)
    iso_h=1/2500*((h(d))-1.826*T); 
   
   %boucles pour faire le tracé uniquement sous la courbe de saturation
   a=1; 
   while iso_h(a)>courbe_sat(a) 
        a=a+1;
   end
   
   b=100;
%    b=a;
%    while iso_h(b) >0
%        b=b+1;
%    end
   
   plot(T(a:b),iso_h(a:b),'b')
   
end 
legend('isenthalpes en ?????????????????')






