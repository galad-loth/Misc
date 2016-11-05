clear all;close all;clc
Img=imread('fingerprint1.png');
Img=double(Img(:,:,1));
[Nx,Ny]=size(Img);
sigma=5;rau=9;
ImgPad=padarray(Img,[ceil(sigma/2), ceil(sigma/2)],'symmetric','both');
G=fspecial('gaussian',sigma,sigma/3);
ImgSmooth=conv2(ImgPad,G,'same');
ImgSmooth=ImgSmooth(ceil(sigma/2)+1:ceil(sigma/2)+Nx,ceil(sigma/2)+1:ceil(sigma/2)+Ny);
[Ix,Iy]=gradient(ImgSmooth);
Ixx=Ix.^2;Iyy=Iy.^2;Ixy=Ix.*Iy;

IxxPad=padarray(Ixx,[ceil(rau/2), ceil(rau/2)],'symmetric','both');
IyyPad=padarray(Iyy,[ceil(rau/2), ceil(rau/2)],'symmetric','both');
IxyPad=padarray(Ixy,[ceil(rau/2), ceil(rau/2)],'symmetric','both');
G=fspecial('gaussian',rau,rau/3);
Ixx=conv2(IxxPad,G,'same');
Iyy=conv2(IyyPad,G,'same');
Ixy=conv2(IxyPad,G,'same');

Ixx=Ixx(ceil(rau/2)+1:ceil(rau/2)+Nx,ceil(rau/2)+1:ceil(rau/2)+Ny);
Ixy=Ixy(ceil(rau/2)+1:ceil(rau/2)+Nx,ceil(rau/2)+1:ceil(rau/2)+Ny);
Iyy=Iyy(ceil(rau/2)+1:ceil(rau/2)+Nx,ceil(rau/2)+1:ceil(rau/2)+Ny);

temp1=4*(Ixx.*Iyy-Ixy.^2);
temp2=Ixx+Iyy;
eigval1=(temp2+sqrt(temp2.^2-temp1))/2;
eigval2=(temp2-sqrt(temp2.^2-temp1))/2;

eigvec2y=(eigval2-Ixx)./Ixy;
theta=-atan(eigvec2y);

Ani=eigval2./eigval1;

%%
rau=15;
temp3=sin(theta);temp4=cos(theta);
SIGMAxx=rau^2*(temp4.^2+Ani.*temp3.^2);
SIGMAyy=rau^2*(temp3.^2+Ani.*temp4.^2);
SIGMAxy=rau^2*(Ani-1).*(temp3.*temp4);

DetSIGMA=SIGMAxx.*SIGMAyy-SIGMAxy.^2;
DetSIGMA=sqrt(DetSIGMA);

temp5=SIGMAxx.*SIGMAyy-SIGMAxy.^2;
SIGMAINVxx=SIGMAyy./temp5;
SIGMAINVyy=SIGMAxx./temp5;
SIGMAINVxy=-SIGMAxy./temp5;
figure;imagesc(Img);colormap(gray);
%%
% ii=215;jj=180;
for ii=40:30:310
    for jj=40:30:310        
        dx=repmat((1:Nx)-jj,Ny,1);
        dy=repmat(((1:Ny)-ii)',1,Nx);
        W=SIGMAINVxx(ii,jj).*dx.^2+2*SIGMAINVxy(ii,jj).*dx.*dy+SIGMAINVyy(ii,jj).*dy.^2;        
        W=exp(-W/2)/2/pi/DetSIGMA(ii,jj);
        ContourLevel=0.7/2/pi/DetSIGMA(ii,jj);
        hold on;contour(W,[ContourLevel ContourLevel],'r','Linewidth',2)
    end
end
