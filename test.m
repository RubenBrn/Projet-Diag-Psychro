
% Hypoth??ses :
Ptot=101325; %Pa

% Cp constants
Cpair_humide=1040; % J/kg/K

% Variables
Tmin=5;
Tmax=50;

pas=linspace(Tmin, Tmax, 100);

% Echelles principales
Temp=[Tmin:0.1:Tmax];

title('Abaque psychrometrique simplifie')


% %Echelles secondaires
% pressions_partiellesPa=pressionpartielle_fomega(humidites_absolues,Ptot);
% pressions_partielleskgcm2=pressions_partiellesPa.*1E-5;

% %% voir td optimisation
% [T,omega]=meshgrid(temperatures,humidites_absolues);
% volume_spe=volume_specifique (T, pressions_partiellesPa, omega); 

%% Trace de omega en fct de T

Pvs=pression_vapPa(Temp);

Pvs_omega=0.622*(Pvs./(Ptot-Pvs));

axes=gca;
axes.YAxisLocation='right';

%creation d'un nouvel axe


figure(1)
ax1 = axes('Position',[0.1 0.1 0.7 0.7]);
ax2 = axes('Position',[0.65 0.65 0.28 0.28]);
hold 
ylim([0 0.05])
for i=1:10
    plot(Temp, 0.1*i*Pvs_omega, '-k')

end 


% courbes isenthalpes 

for i=1:20 %nombre de droites
    
    h0=10; %enthalpie de base, choisie au hasard
    
    iso_h=1/2500*((h0*i)-1.826*Temp); 
    
    %boucle pour tracer uniquement les bonnes valeurs 
    k=1; %compteur 
    while iso_h(k)>Pvs_omega(k)
        k=k+1;
    end
    plot(Temp(1:k), iso_h(1:k), ':b')  
    plot(Temp(k:end), iso_h(k:end), '-b')  
end

% Trac? des volumes sp?cifiques

R=8.314; % J/mol/K
Mas= 28.965338E-3 ; %kg/mol
Mv= 18.01528E-3 ; 

for vs=0.75:0.01:1
    omega_vs=(vs.*Ptot.*Mv)./(R.*(Temp+273.15)) -(Mv/Mas); % pas la bonne ?quation
    k=1; %compteur 
    while omega_vs(k)>Pvs_omega(k)
        k=k+1;
         
    end
    plot(Temp(1:k),omega_vs(1:k),':r')
    plot(Temp(k:end),omega_vs(k:end),'r')
    %legend('volume sp?cifique en m^3/kg') %% probl?me
end

