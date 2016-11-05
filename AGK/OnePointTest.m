clear all;clc;close all
Nx=9;Ny=9;
A=32+5*randn(Nx,Ny);
for ii=1:Nx
    for jj=1:Ny
        if jj>Ny/2
            A(ii,jj)=144+A(ii,jj);
        end
    end
end
A=fliplr(A);

figure;imagesc(A);colormap(gray)

[Ax,Ay]=gradient(A);
G=fspecial('gaussian',5,5/3);
Ixx=sum(sum(Ax(3:7,3:7).^2.*G));
Iyy=sum(sum(Ay(3:7,3:7).^2.*G));
Ixy=sum(sum(Ax(3:7,3:7).*Ay(3:7,3:7).*G));

J=[Ixx,Ixy;Ixy,Iyy];
[eigvec,eigval]=eig(J);
Ani=10*eigval(1,1)/eigval(2,2);
theta=-atan(eigvec(2,1)/eigvec(1,1));
% theta=theta/pi*180;
rau=5;
temp3=sin(theta);temp4=cos(theta);
SIGMAxx=rau^2*(temp4.^2+Ani.*temp3.^2);
SIGMAyy=rau^2*(temp3.^2+Ani.*temp4.^2);
SIGMAxy=rau^2*(Ani-1).*(temp3.*temp4);
% SIGMAxx=SIGMAxx(ceil(sigma/2)+1:ceil(sigma/2)+Nx,ceil(sigma/2)+1:ceil(sigma/2)+Ny);
% SIGMAxy=SIGMAxy(ceil(sigma/2)+1:ceil(sigma/2)+Nx,ceil(sigma/2)+1:ceil(sigma/2)+Ny);
% SIGMAyy=SIGMAyy(ceil(sigma/2)+1:ceil(sigma/2)+Nx,ceil(sigma/2)+1:ceil(sigma/2)+Ny);

rau=7;
D=ceil(rau/2);
dx=repmat(-D:D,rau+2,1);
dy=repmat((-D:D)',1,rau+2);

temp5=SIGMAxx.*SIGMAyy-SIGMAxy.^2;
SIGMAINVxx=SIGMAyy./temp5;
SIGMAINVyy=SIGMAxx./temp5;
SIGMAINVxy=-SIGMAxy./temp5;

W=SIGMAINVxx.*dx.^2+SIGMAINVxy.*dx.*dy+SIGMAINVyy.*dy.^2;
W=exp(-W);
hold on;contour(W,[0.7 0.7],'r','Linewidth',2)
