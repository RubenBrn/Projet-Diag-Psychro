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

T=linspace(Tmin, Tmax, 100);

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



%% Tracé du diagramme psychrométrique

figure()
hold all


%%%%%%%%%%%%%%%%%%%%%%%% Mise en forme  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 'stem' trace les traits verticaux sous la courbe de saturation

title('Abaque psychrometrique simplifie')

xlabel('T en °C')
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

%% Tracé de la courbe de saturation

Pvs=pression_vapPa(T);
courbe_sat=0.622.*(Pvs./(Ptot-Pvs));

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

%'Extent',[xt-1 yt-0.0015 3 0.003] pour tracer un carré blanc autour du
%texte mais ça marche pas

%% courbes isenthalpes 

for i=1:20 %nombre de droites
    
    h0=10; %enthalpie de base, choisie au hasard
    
    iso_h=1/2500*((h0*i)-1.826*T); 
    
    %boucle pour tracer uniquement les bonnes valeurs 
    k=1; %compteur 
    while iso_h(k)>courbe_sat(k)
        k=k+1;
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
    plot(T(1:k),omega_vs(1:k),':r')
    plot(T(k:end),omega_vs(k:end),'r')
    %legend('volume sp?cifique en m^3/kg') %% probl?me
end

