function[omega, eps]=humidite(P_H2O, Ptot, Pvs)

%omega=m_eau/m_air_sec; 

omega=0.622*P_H2O/(Ptot-P_H2O);

eps=P_H2O/Pvs ; 

end 