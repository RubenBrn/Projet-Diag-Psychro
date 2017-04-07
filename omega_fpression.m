function [om] = omega_fpression (P)
       Ptot=101325; %Pa
       om=0.621945*(P)./(Ptot-P);
end
