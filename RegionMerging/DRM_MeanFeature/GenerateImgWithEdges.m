function ImgWithEdges=GenerateImgWithEdges(Img,label)
[Nx,Ny]=size(Img);
IsContour=zeros(Nx,Ny);
dx=[-1, -1,  0,  1, 1, 1, 0, -1];
dy=[0, -1, -1, -1, 0, 1, 1,  1];

for px=1:Nx
    for py=1:Ny
        NumDiffLabelPix=0;
        for pk=1:8
            pxd=px+dx(pk);
            pyd=py+dy(pk);
            if pxd>0&&pxd<Nx&&pyd>0&&pyd<Ny
               if IsContour(pxd,pyd)==0&&(label(px+(py-1)*Nx)~=label(pxd+(pyd-1)*Nx))
                  NumDiffLabelPix=NumDiffLabelPix+ 1;
               end
            end
        end
        if NumDiffLabelPix>1
            IsContour(px,py)=1;
        end
        
    end
end

ImgWithEdges=Img;
ImgWithEdges(IsContour==1)=255;

