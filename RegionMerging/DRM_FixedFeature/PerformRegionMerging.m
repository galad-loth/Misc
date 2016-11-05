function [Regions,RegionList,LabelNew,MergedRegion]=PerformRegionMerging(Regions,RegionList,LabelNew,SimMat,IdxRtmp,IdxNNR)
IdxR1=IdxRtmp;IdxR2=IdxNNR;
if IdxR1>IdxR2
    IdxTemp=IdxR1;IdxR1=IdxR2;IdxR2=IdxTemp;
end
MergedRegion=IdxR2;
%Updating Label and List of Regions
LabelNew(LabelNew==IdxR2-1)=IdxR1-1;
RegionList=RegionList(RegionList~=IdxR2);
% fields only related to current region
Regions{IdxR1}.GsCum=Regions{IdxR1}.GsCum+Regions{IdxR2}.GsCum;
Regions{IdxR1}.Size=Regions{IdxR1}.Size+Regions{IdxR2}.Size;
SPinRegion=[Regions{IdxR1}.SPinRegion,Regions{IdxR2}.SPinRegion];
Regions{IdxR1}.SPinRegion=SPinRegion;
% Update list of neighboring regions
NRIdx=unique([Regions{IdxR1}.NRIdx,Regions{IdxR2}.NRIdx]);
% Find the Nearest Neighboring Region
MaxSim=0;
for ii=1:length(NRIdx)
    NRIdxTmp=NRIdx(ii);
    SPinNRegion=Regions{NRIdxTmp}.SPinRegion;
    for jj=1:length(SPinNRegion)
        IdxSP2=SPinNRegion(jj);
        for kk=1:length(SPinRegion)
            IdxSP1=SPinRegion(kk);
            if SimMat(IdxSP1,IdxSP2)>MaxSim
               MaxSim=SimMat(IdxSP1,IdxSP2);
               IdxNNRTmp=NRIdxTmp;
            end
        end
    end
    % if any region links to merged region, relink it to the current region
    NR_NRIdx=Regions{NRIdxTmp}.NRIdx;
    if Regions{NRIdxTmp}.NNRIdx==IdxR2
        Regions{NRIdxTmp}.NNRIdx=IdxR1;
        NR_NRIdx=NR_NRIdx(NR_NRIdx~=IdxR1);
    end        
    if ~isempty(find(NR_NRIdx==IdxR2, 1))
        if Regions{NRIdxTmp}.NNRIdx==IdxR1
            NR_NRIdx=NR_NRIdx(NR_NRIdx~=IdxR2);
        elseif isempty(find(NR_NRIdx==IdxR1, 1))
            NR_NRIdx(NR_NRIdx==IdxR2)=IdxR1;
        else
            NR_NRIdx=NR_NRIdx(NR_NRIdx~=IdxR2);
        end        
    end
    Regions{NRIdxTmp}.NRIdx=NR_NRIdx;
end
Regions{IdxR1}.MaxSim=MaxSim;
Regions{IdxR1}.NNRIdx=IdxNNRTmp;
Regions{IdxR1}.NRIdx=NRIdx(NRIdx~=IdxNNRTmp);
    
