clc 
clear all 
close all 

% Plotting the Simplified Psychrometric Chart
% Izzi Urieli 2/27/2008

tpg = load ('t_pg.txt'); % saturation temp/pressure
t = tpg(:,1); % temperature (C)
pg = tpg(:,2); % saturation vapor pressure (kPa)
patm = 101.325; % standard atmosphere (kPa)
rair = 0.287; % gas constant of air (kJ/kg.K)
wg = 622*pg./(patm-pg); % saturation specific humidity
plot(t,wg,'r-')
hold
grid

for phi = 0.1:0.1:0.4, % phi = relative humidity 10% - 40%
	w = 622*phi*pg./(patm-phi*pg);
	plot(t,w)
end

for phi = 0.6:0.2:0.8, % phi = 60%, 80%
	w = 622*phi*pg./(patm-phi*pg);
	plot(t,w)
end
% specific volume and enthalpy/wet-bulb-temp
tpg1 = dlmread('t_pg1.txt','\t');
t1 = tpg1(:,1); % saturation temperature (C)
pg1 = tpg1(:,2); % saturation pressure (kPa)
wg1 = 622*pg1./(patm-pg1); % saturation specific humidity
% specific volume of dry air (cubic m/kg dry air) (green)
vol = rair.*(t1+273)./(patm-pg1) % specific vol at saturation
tv0 = patm*vol/rair-273; % air temperature at zero humidity
for i = 1:7,
	plot([t1(i),tv0(i)],[wg1(i),0],'g-')
end
% wet bulb temperature (also enthalpy) lines (red)
h = t1 + 2.5*wg1 % enthalpy (kJ/kg-dry-air) (displayed)
t0 = h; % temperature at zero humidity for enthalpy h
for i = 1:6,
	plot([t1(i),t0(i)],[wg1(i),0],'r-')
end

% enthalpy axis and enthalpy lines (black)
for h = 10:10:110, % enthalpy (kJ/kg-dry-air)
	t0 = h; % temperature at zero humidity
	t1 = (h - 12.5)/3.5; % temperature on the enthalpy axis
	w1 = t1 + 5; % specific humidity on the enthalpy axis
	plot([t0,t1],[0,w1],'k-')
end

plot([0,25],[5,30],'k-') % the oblique enthalpy axis
axis([0,50,0,30]) % limit the range of the chart
title('Simplified Psychrometric Chart')
xlabel('Dry Bulb Temperature (deg C)')
ylabel('Specific Humidity (gm vap/kg dry air)')
