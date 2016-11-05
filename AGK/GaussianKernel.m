clear all;clc;close all
theta=pi/3;
rau=21;
A=.8;
M1=[cos(theta),sin(theta);-sin(theta),cos(theta)];
M2=[rau^2,0;0,rau^2*A];
SIGMA=M1'*M2*M1;
SIGMAINV=inv(SIGMA);
rau=181;
D=ceil(rau/2);
dx=repmat(-D:D,rau+2,1);
dy=repmat((-D:D)',1,rau+2);
W=SIGMAINV(1,1).*dx.^2+2*SIGMAINV(1,2).*dx.*dy+SIGMAINV(2,2).*dy.^2;
detSIGMA=sqrt(det(SIGMA));
W=exp(-W/2)/2/pi/detSIGMA;
ContourLevel=0.7/2/pi/detSIGMA;
figure;contour(W,[ContourLevel ContourLevel],'r','Linewidth',2)
% figure;mesh(W)