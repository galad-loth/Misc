function W=ComputeAGK(theta,Ani,rau,ii,jj,Img)
[Nx,Ny]=size(Img);
temp3=sin(theta);temp4=cos(theta);
SIGMAxx=rau^2*(temp4.^2+Ani.*temp3.^2);
SIGMAyy=rau^2*(temp3.^2+Ani.*temp4.^2);
SIGMAxy=rau^2*(Ani-1).*(temp3.*temp4);
% SIGMAxx=SIGMAxx(ceil(sigma/2)+1:ceil(sigma/2)+Nx,ceil(sigma/2)+1:ceil(sigma/2)+Ny);
% SIGMAxy=SIGMAxy(ceil(sigma/2)+1:ceil(sigma/2)+Nx,ceil(sigma/2)+1:ceil(sigma/2)+Ny);
% SIGMAyy=SIGMAyy(ceil(sigma/2)+1:ceil(sigma/2)+Nx,ceil(sigma/2)+1:ceil(sigma/2)+Ny);

% D=ceil(rau2/2);
dx=repmat((1:Nx)-jj,Ny,1);
dy=repmat(((1:Ny)-ii)',1,Nx);

temp5=SIGMAxx.*SIGMAyy-SIGMAxy.^2;
SIGMAINVxx=SIGMAyy./temp5;
SIGMAINVyy=SIGMAxx./temp5;
SIGMAINVxy=-SIGMAxy./temp5;

W=SIGMAINVxx(ii,jj).*dx.^2+SIGMAINVxy(ii,jj).*dx.*dy+SIGMAINVyy(ii,jj).*dy.^2;
W=exp(-W);
% WW=zeros(Nx,Ny);
% WW(ii-D:ii+D,jj-D:jj+D)=W;

% hold on;contour(WW,[0.7 0.7],'r','Linewidth',2)