function axh=psychplotting(TDBllim,TDBhlim,wllim,whlim,varargin)
%TDBllim=10;TDBhlim=40;wllim=6;whlim=30;
if ~isempty(varargin) && isnumeric(cell2mat(varargin))
    Pamb=cell2mat(varargin);
else Pamb=101.325;
end
TDB=TDBllim:1:TDBhlim;RH=10:10:100; %Dry bulb temperature and relative humidity vector
[a, ~, ~, hllim,~,~,Twbllim] = Psychrometricsnew ('tdb',TDBllim, 'w',wllim/1000); %calculate enthalpy lower limit
[a, ~, ~, hhlim,~,~,Twbhlim] = Psychrometricsnew ('tdb',TDBhlim, 'w',whlim/1000); %calculate enthalpy upper limit
hllim=round(hllim/10000)*10;hhlim=round(hhlim/10000)*10;h=hllim:10:hhlim; %round enthalpy limits to tens in kJ/kg
Twbllim=round(Twbllim/10)*10;Twbhlim=round(Twbhlim/10)*10;Twb=Twbllim:5:Twbhlim+5; %round wet bulb limits to tens in C
TDB=TDB';RH=RH';h=h'*1000;
figure
set(gcf, 'Color', 'w');
%% RH lines plotting
for i=1:length(RH)
    for j=1:length(TDB)
[a, w(i,j), ~, ~, ~, ~,~] = Psychrometricsnew ('tdb',TDB(j), 'phi', RH(i),'p',Pamb);
    end
    rhhandle=plot(TDB,w(i,:)*1000,'-k');hold on;
    if i==1 || i==length(RH) || i==length(RH)/2
    label(rhhandle,[num2str(RH(i)),'%'],'location','center','slope') % label plotting for RH lines
    end
end
%% enthalpy lines plotting
for i=1:length(h)
    for j=1:length(TDB)
        [Tdbplot(i,j), w(i,j), phi(i,j), ~, ~, ~,~] = Psychrometricsnew ('tdb',TDB(j), 'h', h(i),'p',Pamb);
    if phi(i,j)>100        
        [Tdbplot(i,j), w(i,j), phi(i,j), ~, Tdp, ~,~] = Psychrometricsnew ('phi', 100, 'h', h(i),'p',Pamb);
    end
    if w(i,j)<0 %make specific humidity NaN if negative
        w(i,j)=NaN;
    end
    end
    hhandle=plot(Tdbplot(i,:),w(i,:)*1000,'-b');hold on;
    if rem(i,2)==0
    label(hhandle,[num2str(round(h(i)/1000)),'kJ/kg'],'location','left','slope','horizontalalignment','right') % label plotting for enthalpy lines
    end
end

%% dew point lines
for i=1:length(Twb)    
%     for j=1:length(TDB)
%     [Tdbwp(i,j), wwp(i,j), phiw(i,j), ~, ~, ~,~] = Psychrometricsnew ('twb',Twb(i), 'tdb', TDB(j));
%     if phiw(i,j)>100        
%         [Tdbwp(i,j), wwp(i,j), phiw(i,j), ~, ~, ~,~] = Psychrometricsnew ('phi', 100, 'twb', Twb(i));
%     end
%     if phiw(i,j)<0 %make specific humidity NaN if negative
%         wwp(i,j)=NaN;
%     end
%     end
%     hhandle=plot(Tdbwp(i,:),wwp(i,:)*1000,'--g');hold on;
%     if rem(i,2)==1
%     label(hhandle,[num2str(round(Twb(i))),'\circC'],'color','k','location','left','horizontalalignment','right') % label plotting for enthalpy lines
%     end    
    [Tdbwp(i,1), wwp(i,1), ~, ~, ~, ~,~] = Psychrometricsnew ('twb',Twb(i), 'phi', 100,'p',Pamb);
    plot([Tdbwp(i,1) Tdbwp(i,1)],[wllim wwp(i,1)*1000],'--k');hold on;
    plot([Tdbwp(i,1) TDBhlim],[wwp(i,1) wwp(i,1)]*1000,'--k');hold on;            
end
axh=gca;xticklabel=-20:2.5:50;yticklabel=0:5:90; %x and y axes ticks stepping
set(axh,'YAxisLocation','right','xminortick','off','yminortick','off','XTick',xticklabel,'YTick',yticklabel);
xlabel('Dry Bulb Temperature (\circC)','fontsize',12,'fontname','arial');
ylabel('Specific Humidity (g/kg)','fontsize',12,'fontname','arial');
aa=get(gca,'YTick');set(gca,'YTickLabel',sprintf('%.0f\n',aa));
aa=get(gca,'XTick');set(gca,'XTickLabel',sprintf('%.1f\n',aa));
box off;axis([TDBllim TDBhlim wllim whlim]);
end
