function labelNew=relabeling(label,Img,NumSPDesire)
[Nx,Ny]=size(Img);
SizeSP=round(Nx*Ny/NumSPDesire);
label=reshape(label,[Nx Ny]);
labelNew=-1*ones(Nx,Ny);
labelnow=0;
adjlabel=0;
dx=[-1,0,1,0];dy=[0,-1,0,1];
for px=1:Nx
    for py=1:Ny
        PixelInSeg=zeros(5*SizeSP,2);
        if labelNew(px,py)<0            
            labelNew(px,py)=labelnow;
            NumofSeg=1;
            PixelInSeg(NumofSeg,:)=[px,py];            
            for nn=1:4
                pxtmp=px+dx(nn);
                pytmp=py+dy(nn);
                if pxtmp>0&&pytmp>0&&pxtmp<=Nx&&pytmp<=Ny
                    if labelNew(pxtmp,pytmp)>=0
                        adjlabel=labelNew(pxtmp,pytmp);
                    end
                end
            end
            cc=1;
            while cc<=NumofSeg
                for nn=1:4
                    pxtmp=PixelInSeg(cc,1)+dx(nn);pytmp=PixelInSeg(cc,2)+dy(nn);
                    if pxtmp>0&&pytmp>0&&pxtmp<=Nx&&pytmp<=Ny
                        if labelNew(pxtmp,pytmp)<0&&label(pxtmp,pytmp)==label(px,py)
                            labelNew(pxtmp,pytmp)=labelnow;
                            NumofSeg=NumofSeg+1;
                            PixelInSeg(NumofSeg,:)=[pxtmp,pytmp];                            
                        end
                    end
                end
                cc=cc+1;
            end
            
            if NumofSeg<SizeSP
               for cc=1:NumofSeg
                   labelNew(PixelInSeg(cc,1),PixelInSeg(cc,2))=adjlabel;
               end
             labelnow=labelnow-1;
            end
          labelnow=labelnow+1;           
         end      
    end
end