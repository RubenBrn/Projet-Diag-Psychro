function [Hg]= enthalpie_gaz_humide(T, omega)

%enlever les constantes et se referer aux formules des Cp, chaleur latente
%et tout

Hg= (1.003 + 1.964*omega)*T +2487*omega; 
Hg=Hg/4.184; %passage en kcal/kg

end