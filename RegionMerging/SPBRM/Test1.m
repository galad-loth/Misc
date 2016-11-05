clear all;close all;clc
load label.mat;
Img=imread('CameraMan.jpg');
Img=double(Img(:,:,1));
[Nx,Ny]=size(Img);
ImgWithEdges=GenerateImgWithEdges(Img,Label);
ImgMean=GenerateMeanGrayScaleImg(Img,Label);
figure(1);set(gcf,'position',[300 100 2*Nx 2*Ny])
subplot(2,2,1);imagesc(Img);colormap(gray);
% subplot(2,2,2);imagesc(ImgWithEdges);colormap(gray)
subplot(2,2,2);imagesc(ImgMean);colormap(gray)
pause(.5)
%%
Nregion=max(Label(:))+1;
Region=cell(1,Nregion);
DistMat=256^2*ones(Nregion,Nregion);
AdjRec=zeros(Nregion,Nregion);
for kk=1:Nregion
    Region{kk}.size=0;
    Region{kk}.feature=0;
end
dx=[-1,0,1,0];dy=[0,-1,0,1];
for px=1:Nx
    for py=1:Ny
        labelnow=Label(px,py);
%         DistTable(Labelnow,Labelnow)=1;
        Region{labelnow+1}.size=Region{labelnow+1}.size+1;
        Region{labelnow+1}.feature=Region{labelnow+1}.feature+Img(px,py);
        for kk=1:4
            pxtmp=px+dx(kk);pytmp=py+dy(kk);
            if pxtmp>0&&pytmp>0&&pxtmp<=Nx&&pytmp<=Ny
               if labelnow~=Label(pxtmp,pytmp)
                  AdjRec(labelnow+1,Label(pxtmp,pytmp)+1)=1;  
               end
            end
        end
    end
end
for ii=1:Nregion
    for jj=ii+1:Nregion
        if AdjRec(ii,jj)==1
            DistMat(ii,jj)=abs(Region{ii}.feature/Region{ii}.size-Region{jj}.feature/Region{jj}.size);
        end
    end
end

NregionNow=Nregion;
LabelNew=Label;
while NregionNow>8
    [minDist,index]=min(DistMat(:));
    R2=ceil(index/Nregion);
    R1=index-(R2-1)*Nregion;
    AdjRec(R1,R2)=0;AdjRec(R2,R1)=0;
    DistMat(R1,R2)=256^2;
    Region{R1}.size=Region{R1}.size+Region{R2}.size;
    Region{R1}.feature=Region{R1}.feature+Region{R2}.feature;
    LabelNew(LabelNew==R2-1)=R1-1;
    index1=find(AdjRec(R2,:)~=0);
    for kk=1:length(index1)
        Rtmp=index1(kk);
        AdjRec(R2,Rtmp)=0;AdjRec(Rtmp,R2)=0;
        if R2<Rtmp
            DistMat(R2,Rtmp)=256^2;
        else
            DistMat(Rtmp,R2)=256^2;
        end
        AdjRec(R1,Rtmp)=1;AdjRec(Rtmp,R1)=1;
        if R1<Rtmp
            DistMat(R1,Rtmp)=abs(Region{R1}.feature/Region{R1}.size-...
                Region{Rtmp}.feature/Region{Rtmp}.size);
        else
            DistMat(Rtmp,R1)=abs(Region{R1}.feature/Region{R1}.size-...
                Region{Rtmp}.feature/Region{Rtmp}.size);
        end
    end
    NregionNow=NregionNow-1
end
%%
LabelNew=relabeling(LabelNew,Img,10000);
ImgWithEdges=GenerateImgWithEdges(Img,LabelNew);
ImgMean=GenerateMeanGrayScaleImg(Img,LabelNew);
figure(1);
subplot(2,2,3);imagesc(ImgWithEdges);colormap(gray)
subplot(2,2,4);imagesc(ImgMean);colormap(gray)
        
            
        
