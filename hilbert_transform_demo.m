clear all;close all;clc
fs = 1000;
dt = 1/fs;
t = 0:dt:1;

f1 = 40;
f2 = 42;
f3 = 50;
f4 = 5;

y1 = cos(2*pi*f1*t);
y2 = cos(2*pi*f2*t);
y3 = 0.8*cos(2*pi*f3*t);
%y4 = 1.1*cos(2*pi*f4*t);
% y = y1 + y2 + y3 + y4;
y = y1 + y2 + y3;
%y = y1 + y2;

z = hilbert(y);
A = abs(z);
phi = angle(z);

figure;
set(gcf,'Color','w')
set(gcf,'Position',[586   158   935   541])
subplot(2,1,1)
plot(t,y,'b-')
hold on
plot(t,A,'r-')
set(gca,'FontSize',18,'YLim',2.6*[-1 1])
xlabel('t (s)')

subplot(2,1,2)
plot(t,phi,'r-')
set(gca,'FontSize',18,'YTick',[-pi 0 pi])
xlabel('t (s)')