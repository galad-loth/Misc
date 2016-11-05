clear all;close all;clc
load label.mat;
Img=imread('24063.jpg');
Img=double(Img(:,:,1));
[Nx,Ny]=size(Img);
ImgMean=GenerateMeanGrayScaleImg(Img,Label);
figure(1);set(gcf,'position',[100 100 900 600]);
subplot(2,2,1);imagesc(Img);colormap(gray)
title('Original Image')
subplot(2,2,2);imagesc(ImgMean);colormap(gray)
title('superpixels');
pause(.5)
%%
Nregion=max(Label(:))+1;
RegionList=1:Nregion;
AdjRec=zeros(Nregion,Nregion);
RegionGsCum=zeros(1,Nregion);
RegionSize=zeros(1,Nregion);
dx=[-1,0,1,0];dy=[0,-1,0,1];
for px=1:Nx
    for py=1:Ny
        labeltmp=Label(px,py);
        RegionGsCum(labeltmp+1)=RegionGsCum(labeltmp+1)+Img(px,py);
        RegionSize(labeltmp+1)=RegionSize(labeltmp+1)+1;
        for kk=1:4
            pxtmp=px+dx(kk);pytmp=py+dy(kk);
            if pxtmp>0&&pytmp>0&&pxtmp<=Nx&&pytmp<=Ny
               if labeltmp~=Label(pxtmp,pytmp)
                  AdjRec(labeltmp+1,Label(pxtmp,pytmp)+1)=1;  
               end
            end
        end
    end
end
%%
SimMat=zeros(Nregion,Nregion);
IdxAdj=find(AdjRec);
for kk=1:length(IdxAdj)
    IdxAdjTmp=IdxAdj(kk);
    AdjR2=ceil(IdxAdjTmp/Nregion);
    AdjR1=IdxAdjTmp-(AdjR2-1)*Nregion;
    DistTmp=abs(RegionGsCum(AdjR1)/RegionSize(AdjR1)-RegionGsCum(AdjR2)/RegionSize(AdjR2));
    SimMat(AdjR1,AdjR2)=1./(DistTmp+1);
end
%%
Regions=InitRegions(SimMat,RegionGsCum,RegionSize,Nregion);
LabelNew=Label;SimThresh=1/(50+1);
FlagMerge=1;
MergeTimes=0;
MergeTable=zeros(1,Nregion);
while FlagMerge
    FlagMerge=0;
    for kk=1:length(RegionList)
        IdxRtmp=RegionList(kk);
        IdxNNR=Regions{IdxRtmp}.NNRIdx;
        if IdxRtmp~=Regions{IdxNNR}.NNRIdx
            continue;
        elseif Regions{IdxRtmp}.MaxSim<SimThresh
            continue;
        else
            MergeTimes=MergeTimes+1
            [Regions,RegionList,LabelNew,MergedRegion]=...
                PerformRegionMerging(Regions,RegionList,LabelNew,IdxRtmp,IdxNNR);
            FlagMerge=1; 
            MergeTable(MergeTimes)=MergedRegion;
            break;
        end        
    end
end
 %%
ImgWithEdges=GenerateImgWithEdges(Img,LabelNew);
ImgMean=GenerateMeanGrayScaleImg(Img,LabelNew);
figure(1);set(gcf,'position',[100 100 900 600]);
subplot(2,2,3);imagesc(ImgWithEdges);colormap(gray)
subplot(2,2,4);imagesc(ImgMean);colormap(gray)
