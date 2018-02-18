clear;close all;clc
fs = 1000;
dt = 1/fs;
t = 0:dt:1;

f1 = 40;
f2 = 42;
f3 = 50;
f4 = 55;

y1 = cos(2*pi*f1*t);
y2 = cos(2*pi*f2*t);
y3 = 0.8*cos(2*pi*f3*t);
y4 = 0.1*cos(2*pi*f4*t);
y = y1 + y2 + y3 + y4;
% y = y1 + y2 + y3;
%y = y1 + y2;

z = hilbert(y);
A = abs(z);
phi = angle(z);

figure;
set(gcf,'Color','w')
set(gcf,'Position',[586   158   935   541])
subplot(2,1,1)
plot(t,y,'b-')
title('complex wave and hilbert enevelope')
hold on
plot(t,A,'r-')
set(gca,'FontSize',18,'YLim',2.6*[-1 1])
xlabel('t (s)')
% positioning arrow with text:
a = 0.65; %a = max(A);
at = 2; %at = a(A==max(A));
text(a,at,'\leftarrow Hilbert envelope','color','r','Fontsize',14)


subplot(2,1,2)
plot(t,phi,'r-')
title('wave phase')
yt = [-pi 0 pi];
syt = {'-\pi', '0' , '\pi'};
set(gca,'FontSize',18,'YTick',yt)
set(gca,'YTickLabel',syt) 
text(yt,-0.01*ones(size(yt)),syt, ...
           'horizontal','center','vertical','top')
xlabel('t (s)')

