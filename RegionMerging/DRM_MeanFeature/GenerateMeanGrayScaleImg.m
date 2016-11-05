function ImgMean=GenerateMeanGrayScaleImg(Img,label)
[Nx,Ny]=size(Img);
NumLabel=max(label(:))+1;
ImgMean=zeros(Nx,Ny);
for kk=1:NumLabel
    ImgMean(label==kk-1)=mean(Img(label==kk-1));
end
