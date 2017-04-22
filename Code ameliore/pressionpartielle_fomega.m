function [Pvs]= pressionpartielle_fomega (omega,Ptot)
    Pvs=(omega.*Ptot)./(omega+0.621945);
end
