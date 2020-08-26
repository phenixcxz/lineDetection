function [codeimg,dirlist,labelim] = Imgcoding(EDGE,edgeSegments)
[m,n]=size(EDGE);
codeimg = zeros(m,n);
noOfSegments = length(edgeSegments);
labelim=zeros(m,n);
dirlist={};
pnimg=zeros(m,n);
No=0;
for i = 1:noOfSegments
    aa=edgeSegments{i};  
   % pnimg((aa(:,1)-1)*m+aa(:,2))=1;
   % figure(4)
   % imshow(pnimg);
   % pnimg((aa(:,1)-1)*m+aa(:,2))=0;
    [ss,dir]=edgeangle(aa,5,0.8);   %ÐÞ¸Ä
    if sum(dir)>0
       codeimg((aa(:,1)-1)*m+aa(:,2))=dir;
       [LL,numL]=bwlabel(dir>0,4);
       for j=1:numL
            bb=aa(LL==j,:);
            if length(bb)> 4
               No=No+1;
               dirlist{No}=bb;
               labelim((bb(:,1)-1)*m+bb(:,2))=No;
            end
       end
    end
end