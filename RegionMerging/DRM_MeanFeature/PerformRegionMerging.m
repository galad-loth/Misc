function [Regions,RegionList,LabelNew,MergedRegion]=...
    PerformRegionMerging(Regions,RegionList,LabelNew,IdxRtmp,IdxNNR)
%
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
NRIdx2=Regions{IdxR2}.NRIdx;
for ii=1:length(NRIdx2)
    NRIdxTmp=NRIdx2(ii);
        % if any region links to merged region, relink it to the current region
        NR_NRIdx=Regions{NRIdxTmp}.NRIdx;
        if Regions{NRIdxTmp}.NNRIdx==IdxR2
            Regions{NRIdxTmp}.NNRIdx=IdxR1;
            NR_NRIdx=NR_NRIdx(NR_NRIdx~=IdxR1);
        elseif Regions{NRIdxTmp}.NNRIdx==IdxR1
            NR_NRIdx=NR_NRIdx(NR_NRIdx~=IdxR2);
        elseif isempty(find(NR_NRIdx==IdxR1, 1))
            NR_NRIdx(NR_NRIdx==IdxR2)=IdxR1;
        else
            NR_NRIdx=NR_NRIdx(NR_NRIdx~=IdxR2);
        end
    Regions{NRIdxTmp}.NRIdx=NR_NRIdx;
end
NRIdx=unique([Regions{IdxR1}.NRIdx,Regions{IdxR2}.NRIdx]);
MaxSimR1=0;
for ii=1:length(NRIdx)
    NRIdxTmp=NRIdx(ii);
    DistTmp=abs(Regions{IdxR1}.GsCum/Regions{IdxR1}.Size-...
        Regions{NRIdxTmp}.GsCum/Regions{NRIdxTmp}.Size);
    SimTmp=1/(DistTmp+1);
    if SimTmp>MaxSimR1
       MaxSimR1=SimTmp;
       IdxNNRTmpR1=NRIdxTmp;
    end
    NR_NRIdx=[Regions{NRIdxTmp}.NRIdx,Regions{NRIdxTmp}.NNRIdx];
    MaxSimNR=0;
    for jj=1:length(NR_NRIdx)
        NRNRIdxTmp=NR_NRIdx(jj);
        DistTmp=abs(Regions{NRNRIdxTmp}.GsCum/Regions{NRNRIdxTmp}.Size-...
            Regions{NRIdxTmp}.GsCum/Regions{NRIdxTmp}.Size);
        SimTmp=1/(DistTmp+1);
        if SimTmp>MaxSimNR
           MaxSimNR=SimTmp;
           IdxNNRTmpNR=NRNRIdxTmp;
        end
    end
    Regions{NRIdxTmp}.MaxSim=MaxSimNR;
    Regions{NRIdxTmp}.NNRIdx=IdxNNRTmpNR;
    Regions{NRIdxTmp}.NRIdx=NR_NRIdx(NR_NRIdx~=IdxNNRTmpNR);
end
Regions{IdxR1}.MaxSim=MaxSimR1;
Regions{IdxR1}.NNRIdx=IdxNNRTmpR1;
Regions{IdxR1}.NRIdx=NRIdx(NRIdx~=IdxNNRTmpR1);
    
    
    