function [vpx,vpy] = get_vanishingpoint( crosspoint,M )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
x=crosspoint'; 
[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(x,30);
cl=length(clustMembsCell);
for i=1:cl
    a=clustMembsCell{i};
    ax(i,1)=length(a);
end
  mc=max(ax);
  point=find(ax==mc);
  if length(point)>2
     dj=abs(clustCent(1,point)'-M/2);
     md=find(dj==min(dj));
     vpx=clustCent(1,point(md))';
     vpy=clustCent(2,point(md))';
  else
     vpx=clustCent(1,point)';
     vpy=clustCent(2,point)';
  end
end

