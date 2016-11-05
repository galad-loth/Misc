function Regions=InitRegions(SimMat,RegionGsCum,RegionSize,Nregion)
% initialize region information and calcluate the area, markerType and
% rgbHistogram
Regions=cell(1,Nregion);
for kk=1:Nregion
    Regions{kk}.SPinRegion=kk;
    Regions{kk}.GsCum=RegionGsCum(kk);
    Regions{kk}.Size=RegionSize(kk);
    NRIdx=find(SimMat(kk,:));
    [MaxSim,NNRIdx]=max(SimMat(kk,:));
    NRIdx=NRIdx(NRIdx~=NNRIdx);
    Regions{kk}.NRIdx=NRIdx;
    Regions{kk}.NNRIdx=NNRIdx;
    Regions{kk}.MaxSim=MaxSim;
end