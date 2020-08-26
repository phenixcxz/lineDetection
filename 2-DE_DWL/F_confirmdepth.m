%确定区域深度位置
% nL——区域分割标记图；
% vanpoint——消失点；
function depthimg=F_confirmdepth(nBw,vanpoint)
[nB,nL] = bwboundaries(nBw);
nL=nL.*(~nBw);
[M,N]=size(nL);
depL=zeros(M,N);
depthimg=zeros(M,N);
xvan=vanpoint(1,1);

step=255/(M-xvan);
i=0;
while xvan<=M
    depL(xvan,:)=i;
    xvan=xvan+1;
    i=i+step;
end

depthimg=depL.*(~nBw);

%num=max(max(nL));
%for i=1:num
    %fl=find(nL==i);
    %if ~isempty(fl)
        %sL=double(nL==i);
        %dimg=depL.*sL;
        %fl=max(max(dimg));
        %depthimg=fl*sL+depthimg;
    %end
    %end
