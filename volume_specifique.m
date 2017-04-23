function [Vs] = volume_specifique (T, omega,eps,Pvs) 

Mas= 28.965338 ; %g/mol
Mv= 18,01528 : 
R=0.287042; % kJ/kg.K

Vs = R*(T+273) .* ( omega./Mv .+ 1/Mas)./(eps.*Pvs); 

end 