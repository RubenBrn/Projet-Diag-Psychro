function [Th]=temperature_humide (T,deltaHvap,Cpair,omegaS,omega)
    Th=T-(deltaHvap/Cpair)*(omegaS-omega);
    % deltaHvap à prendre à Th !!!!
end