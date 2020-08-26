

% I=[2 3 219  966  216 217 218 219 220 221 1 2 3 5 7]';
% Tx=[1004 1005 1006 1007 1008 87 90 99 379 857 892 903 897 600,610,616,619,624,625,626,627,631,634,640,708,744,745,747,749,755,756,758,761,762,763,767,771,772,775,784,788,791,792,794,795,797,798,805,807,809,811,818,820,824,829];
% Tt=zeros(length(Tx),1);
for kk=26:27
%i=322;
% k=Tx(kk);
close all 
tic
% if k<10
%     str=sprintf('roadImgs_final\\image000%.0f.jpg',k);
%   %str=sprintf('roadImgs_final\\%.0f.jpg',k(j));
%     str0=sprintf('result\\seg000%.0f.bmp',k);
%     str1=sprintf('result\\image000%.0f.bmp',k);
%     str2=sprintf('result\\image000%.0f.tif',k);
% elseif k<100
%     str=sprintf('roadImgs_final\\image00%.0f.jpg',k);
%     str0=sprintf('result\\seg00%.0f.bmp',k);
%     str1=sprintf('result\\image0%.0f.bmp',k);
%     str2=sprintf('result\\image00%.0f.tif',k);
% elseif k<1000
%     str=sprintf('roadImgs_final\\image0%.0f.jpg',k);
%     str0=sprintf('result\\seg00%.0f.bmp',k);
%     str1=sprintf('result\\image0%.0f.bmp',k);
%     str2=sprintf('result\\image0%.0f.tif',k);
% else
%     str=sprintf('roadImgs_final\\image%.0f.jpg',k);
%     str0=sprintf('result\\seg%.0f.bmp',k);
%     str1=sprintf('result\\image%.0f.bmp',k);
%     str2=sprintf('result\\image%.0f.tif',k);
%   
% end
str=sprintf('待测\\%.0f.jpg',kk);
str1=sprintf('result\\%.0f.bmp',kk);
I = imread(str);
Img= imresize(I, [180 240]);
hsv=rgb2hsv(Img);
gr = rgb2gray(Img);
Gr = double(gr);   
%figure
%imshow(Img);
[m,n,t]=size(Img);
dark_size=fix(min(m,n)/30);
%[darkimg,pixel_labels]=RoadSeg_darkimg(Img,dark_size);
%imwrite(darkimg,str1);
EDGE=zeros(m,n);
t0=cputime; 

[edgeSegments,EDGE,JIMG] = EDPF(Img, 1);

%figure
%imshow(EDGE);

noOfSegments = length(edgeSegments);

[nBW,nL,LC,Blist,ix]=F_Segmentation(EDGE,edgeSegments,Gr);
%imwrite(LC,str0);


TT=0.25;
T=0.25;
h=5;
To=5.8;
mu=5;

%hold on;

lineimg=ones(m,n);
codeimg=uint8(ones(m,n).*255);
Linelist={};
Linenum=0;
Slist={};
Snum=0;
cornerlist=[];

%len=77;

showflag=1;
writeflag=1;


[codeimg,dirlist,labelim] = Imgcoding(EDGE,edgeSegments);

[dislist,Pim,RoadRegion,Plist,Plabel,Labelim]=F_ParaLineDetection(EDGE,codeimg,dirlist,labelim);%道路区域平行线识别
%figure(1);
%imshow(Pim);
%imwrite(Pim,str2);
%[Pslist,ix]=sort(dislist,'descend'); %将提取的平行线组按长度排序
%PNlist={};
Rim=zeros(m,n);
Cim=zeros(m,n,3);
bw1=double(nL==1);
se=[0 1 1;1 0 1; 1 1 0];
ppTeam={};
dd=length(ix);
ss=zeros(dd,1);
for i=1:dd
    j=ix(i);
    if j>1
        Lx=double(nL==j);
        Him=double(hsv(:,:,1)).*Lx;
        Ri=mean(mean(Cim(:,:,1)));
        Gi=mean(mean(Cim(:,:,2)));
        Bi=mean(mean(Cim(:,:,3)));
        thr=0.2;
        s3=1-min(abs(Ri-0.08),abs(0.8-Ri))/thr-min(abs(Ri-0.08),abs(0.8-Ri)/thr)-min(abs(Ri-0.08),abs(0.8-Ri))/thr;
        Jx=Lx.*RoadRegion;
        scale=sum(sum(Jx))/sum(sum(Lx));
        bw2 = imdilate(Lx,se);
        Lab=bw2.*Pim; 
        plab=Lab.*Plabel; 
        [a,b]=find(Lab>0);
        my=max(a); 
        [pL,pNum]=bwlabel(plab>0);
        if scale>0.8 && pNum>1 &&my/m>0.8 %s3如果相交的区域在80%以上 并且区域包含2条以上平行线  并且 区域最低点与图像底端接近
           Rim=Rim+bw2;
           pix=[];
           pixNum=1;
          % for ii=1:pNum
          %     xL=double(pL==ii).*plab;
          %     [r,c]=find(xL>0);
          %     pix=[pix xL(r(1,1),c(1,1))];
            %   ju=double(Plabel==xL(r(1,1),c(1,1)));
              % figure
              % imshow(ju);
          %     ppTeam{j}=pix;
          %     pixNum=pixNum+1;
          % end
          % hold on
          % cross = Cross_ParallelLine(ppTeam,codeimg);
          % plot(cross(:,1),cross(:,2),'r+');
          
        end
     end
 
end
%figure
%imshow(Rim);    
%imwrite(Rim,str1);

   nI=zeros(m,n,3);
   nI1=zeros(m,n,3);
   nI(:,:,1)=Img(:,:,1);
   nI(:,:,2)=Img(:,:,2);
   nI(:,:,3)=Img(:,:,3);
   
   nR1=244*ones(m,n);
   nG1=91*ones(m,n);
   nB1=221*ones(m,n);
   nI1(:,:,1)=nR1.*Rim;
   nI1(:,:,2)=nG1.*Rim;
   nI1(:,:,3)=nB1.*Rim;
   nI1=uint8(nI1);

   A=double(nI)./255*0.8+double(nI1)./255*0.5;
   figure
   imshow(A);
   imwrite(A,str1);

%imwrite(Rim.*Pim,str2);
t1=cputime-t0;
Tt(kk,1)=t1;
%imshow(A);

end

