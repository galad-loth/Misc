clear all;close all;clc
tic
Img=imread('toys.bmp');
Img=double(Img(:,:,1));
figure;imagesc(Img);colormap(gray)
[Nx,Ny]=size(Img);
sigma=5;rau=9;
ImgPad=padmatrix(Img,sigma);
G=fspecial('gaussian',sigma,sigma/3);
ImgSmooth=conv2(ImgPad,G,'same');
ImgSmooth=ImgSmooth(ceil(sigma/2)+1:ceil(sigma/2)+Nx,ceil(sigma/2)+1:ceil(sigma/2)+Ny);
[Ix,Iy]=gradient(ImgSmooth);
Ixx=Ix.^2;Iyy=Iy.^2;Ixy=Ix.*Iy;

IxxPad=padmatrix(Ixx,rau);
IyyPad=padmatrix(Iyy,rau);
IxyPad=padmatrix(Ixy,rau);
G=fspecial('gaussian',rau,rau/3);
Ixx=conv2(IxxPad,G,'same');
Iyy=conv2(IyyPad,G,'same');
Ixy=conv2(IxyPad,G,'same');

Ixx=Ixx(ceil(rau/2)+1:ceil(rau/2)+Nx,ceil(rau/2)+1:ceil(rau/2)+Ny);
Ixy=Ixy(ceil(rau/2)+1:ceil(rau/2)+Nx,ceil(rau/2)+1:ceil(rau/2)+Ny);
Iyy=Iyy(ceil(rau/2)+1:ceil(rau/2)+Nx,ceil(rau/2)+1:ceil(rau/2)+Ny);
%% 
Ani=zeros(Nx,Ny);
theta=zeros(Nx,Ny);
for ii=1:Nx
    for jj=1:Ny
        J=[Ixx(ii,jj),Ixy(ii,jj);Ixy(ii,jj),Iyy(ii,jj)];
        [eigvec,eigval]=eig(J);
        Ani(ii,jj)=eigval(1,1)/eigval(2,2);
        theta(ii,jj)=-atan(eigvec(2,1)/eigvec(1,1));
        (ii-1)*Ny+jj
    end
end
toc
% theta=-theta/pi*180;
% figure;imagesc(theta,[-90 90]);
% figure;imagesc(Ani,[0 1]);
%%
figure;imagesc(Img);colormap(gray);
ii=100;
jj=60;
rau=9;
WW=ComputeAGK(theta,Ani,rau,ii,jj,Img);
hold on;contour(WW,[0.5 0.5],'r','Linewidth',2)
% for ii=50:10:150
%     for jj=50:10:150
%         W=ComputeAGK(theta,Ani,rau,ii,jj,Img);
%         hold on;contour(W,[0.7 0.7],'r','Linewidth',2)
%     end
% end