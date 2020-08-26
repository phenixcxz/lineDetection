    
clear all
close all
warning off
im=imread('DSC00129.jpg');
lineT=40;
im=imresize(im,[480,640]);
% im=im(:,:,3);


% figure
% imshow(im)
imHsv=rgb2hsv(im);

% figure
% imshow(imHsv)

Img=rgb2gray(imHsv);

figure
imshow(Img)

bw = edge(Img,'canny');

figure
imshow(bw);

[M,N]=size(bw);
Model={};
win=31;
for ii=1:180
    Mv=GenVector(win,ii);
    Model{ii}=uint8(Mv);     
end

Msize=fix(win/2);
bw1=zeros(M+2*Msize,N+2*Msize);
bw1(Msize+1:M+Msize,Msize+1:N+Msize)=bw;
[edgelist,edgeim,codeimg,dirlist,labelim] = alinecoding(bw1,0.01);

pplist={};
ppnum=0;

Cimg=codeimg(Msize+1:M+Msize,Msize+1:N+Msize);%编码图像
Cimg=uint8(Cimg);
figure
imshow(Cimg);

%【平行线检测】
%对编码的边缘进行长度排序
len=length(dirlist);
dirlen=zeros(len,0);
for i=1:len
    dirx=dirlist{i};
    dirlen(i,1)=length(dirx);
end
[t,ix]=sort(dirlen); %对编码的边缘进行长度排序
rc=find(t>=lineT); %只考虑长度大于10个像素的线条 lineT=10
dislist={};
paranum=0;        
pimg=zeros(size(bw));

for i=rc(1,1):rc(end,1) 
      Lineim=zeros(size(bw));
      aa=dirlist{ix(i,1)};
      [dd,ds]=size(aa);
      [PL,pnum,paralist,paraimg]=pca_ParallelLine(aa,dirlist,labelim,codeimg,Model,win);  
         for j=1:pnum
             ppnum=ppnum+1;
             pplist{ppnum}=paralist{j};
         end
end 
pximg=zeros(M+2*Msize,N+2*Msize);   

for i=1:ppnum
    aa=pplist{i};
    [deg,vv,rr]=caleig(aa,100.1,100.35);
    if  rr(1,1) < 0.55 %近似直线 直接分类
           pximg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;
    end
end


figure
imshow(pximg);
imwrite(pximg,'result1.jpg');

imresult = pximg(Msize+1:M+Msize,Msize+1:N+Msize);
imwrite(imresult,'1result.jpg');





 

