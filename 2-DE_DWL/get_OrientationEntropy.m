function ei=get_OrientationEntropy(dir)
  dir=uint8(dir-75);
  [count,X]=imhist(dir);
  count(1,1)=0;
  p=count./sum(count);
  [r,c]=find(p>0);
  pp=p(r(:,1),1);
  ei=-sum(pp.*log(pp)); %·½ֿעל״