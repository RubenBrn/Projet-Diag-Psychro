%% example 1

axhandle=psychplotting(10,40,6,30); %TDB 10-40C and SH 6-30 g/kg
processdata=[38    0.026
            30.2    0.017498
            17.81   0.012777422
            12.5    0.009
            24.89   0.009
            26.71707573 0.009];
plot(axhandle,processdata(:,1),processdata(:,2)*1000,'-r+') %plot process data on psychrometrics plot

for i=1:length(processdata) %plot process data numbers
htext = text(processdata(i,1),processdata(i,2)*1000,num2str(i),'color','k','horizontalalignment','left','verticalalignment','top','fontweight','bold'); 
end

%% example 2
axhandle=psychplotting(10,40,6,30,84.6); %TDB 10-40C and SH 6-30 g/kg 84.6kPa
processdata=[38    0.026
            30.2    0.017498
            17.81   0.012777422
            12.5    0.009
            24.89   0.009
            26.71707573 0.009];
plot(axhandle,processdata(:,1),processdata(:,2)*1000,'-r+') %plot process data on psychrometrics plot

for i=1:length(processdata) %plot process data numbers
htext = text(processdata(i,1),processdata(i,2)*1000,num2str(i),'color','k','horizontalalignment','left','verticalalignment','top','fontweight','bold'); 
end