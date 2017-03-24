function [om] = omega_fpression (P)
       Ptot=101325; %Pa
       om=0.622*(P)./(Ptot-P);
end