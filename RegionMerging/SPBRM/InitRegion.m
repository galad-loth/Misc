function Region=InitRegion(Img,Label,Nregion)
% initialize region information and calcluate the area, markerType and
% rgbHistogram
Region=cell(1,Nregion);
for kk=1:Nregion
    Region{kk}.size=sum(double(Label==kk-1));
    Region{kk}.feature=mean(Img(Label==kk-1));
end