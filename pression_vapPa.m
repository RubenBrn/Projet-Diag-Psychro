function [Pvs]=pression_vap(T)   % pas trouvé de fles plus précises
    if 11<=T<=68 % Antoine
        a=10.23-(1750./(T+235));
        Pvs=10.^a;
    elseif 5<=T<11 || 68<T<90 % Rankine
        a=13.7-(5120./T);
        b=exp(a);
        Pvs=b.*1.01325.*10^5;
    elseif 90<=T<=300 % Duperray
        b=(T./100).^4;
        Pvs=b.*1.01325.*10.^5;
    end
  
end