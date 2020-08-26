clear all
close all

% warning off
im=imread('DSC00013.JPG');
lineT=10;
im = imresize(im,[480,640]);
% figure('Name','缩略图'), imshow(im);

%% 灰度化图像
imHsv=rgb2hsv(im);
imwrite(imHsv,'1imHsv.jpg');

Img=rgb2gray(imHsv);
% imwrite(Img,'1grayImg.jpg');

Img=im(:,:,3);
figure('Name','灰度图'), imshow(Img);
[M,N]=size(Img);


%% canny算法
bw = edge(Img,'canny');

figure('Name','canny'), imshow(bw);

%% 
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

imgn = zeros(M+2*Msize,N+2*Msize); 
figure('Name','Cimg'),imshow(Cimg);

%% 平行线检测
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
    if  rr(1,1) < 0.35 %近似直线 直接分类
        pximg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=255;
    else
        pximg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=0;
    end
end

figure('Name','平行线检测'),imshow(pximg);

%% 灰度图扩充边界
img = zeros(M+2*Msize,N+2*Msize); 
for i = 1:M
    for j=1:N
        img(Msize+i,Msize+j) = Img(i,j);
    end
end

%% 梯度统计2
grads = zeros(ppnum,3);
gap = 10;
for m=1:ppnum
    aa = pplist{m};
    [num,t] = size(aa);
    for n = 1:size(aa)
        x=aa(n,1);
        y=aa(n,2);
        if img(x,y+1) - img(x,y) > gap   %左边缘
            if img(x,y+1) - img(x,y+2) > gap || img(x,y+2) - img(x,y+3) > gap || img(x,y+3) - img(x,y+4) > gap || img(x,y+4) - img(x,y+5) > gap%右边缘
                grads(m,1) = grads(m,1)+1;
            end
        end
        
        if img(x,y-1) - img(x,y) > gap   %右边缘
            if img(x,y-1) - img(x,y-2) > gap || img(x,y-2) - img(x,y-3) > gap || img(x,y-3) - img(x,y-4) > gap || img(x,y-4) - img(x,y-5) > gap %左边缘
                grads(m,2) = grads(m,2)+1;
            end            
        end
    end
    if grads(m,1)/num >3/5 || grads(m,2)/num > 3/5
        grads(m,3) = 1;
    end
end


%% LTP算法
imgdown = zeros(M+2*Msize,N+2*Msize);
numLTP = zeros(ppnum,1);
for m=1:ppnum
    aa=pplist{m};
    [x,y] = size(aa);
    for n = 1:size(aa)
        if LTP(img,aa(n,1),aa(n,2),10,0) >50
            imgdown(aa(n,1),aa(n,2)) = 255;      
            numLTP(m) = numLTP(m)+1;        %统计LTP点
        end  
    end
    numLTP(m) = numLTP(m)/x;
end
figure('Name','LTP'),imshow(imgdown);

%% 直线拟合+信息统计
imgdown = zeros(M+2*Msize,N+2*Msize);

slope=zeros(ppnum,3);       %斜率统计
slope2 = zeros(ppnum,1);    %起始点统计
startdot = zeros(ppnum,1);
num = 1;
for m=1:ppnum
    aa=pplist{m};                       %待处理线段
    p = polyfit(aa(:,1),aa(:,2),1);     %线段斜率与起始点
    slope(m,1) = p(1);                  %斜率
    slope(m,2) = round(p(2));           %起始点
    slope(m,3) = length(aa);            %点的个数
    if length(aa) > 60                  %记录点数大于60的线段
        slope2(num,1) = p(1);
        num = num+1;
        startdot(num,1) = p(2);         
    end
    for n = 1:size(aa)                  %线段拟合
        xx = aa(n,1);
        yy =round(aa(n,1)*p(1)+p(2));
        imgdown(xx,yy) = aa(n,2);
    end
end
figure('Name','直线拟合'),imshow(imgdown);


%% 斜率优化
a3 = slope(:,3);
[a3,pos] = sort(a3);
a2 = slope(pos,2);
a1 = slope(pos,1);
gapslope = a1(size(a1)-10:size(a1));

%% 梯度约束
imgGrads = zeros(M+2*Msize,N+2*Msize);
for m = 1:ppnum
    aa = pplist{m};
    [x,y] = size(aa);
    if grads(m,3)>0
        for n = 1:size(aa)
            imgGrads(aa(n,1),aa(n,2)) = pximg(aa(n,1),aa(n,2));
        end
    end
end
figure('Name','梯度约束'),imshow(imgGrads);

%% 起始点和斜率约束
imgdown2 = zeros(M+2*Msize,N+2*Msize);
num = 1;
for m=1:ppnum
    aa=pplist{m};
    x = size(aa);
    x1 = x(1);
    p = polyfit(aa(:,1),aa(:,2),1);         %以60个点以上的点的斜率和起始点作为约束
    if p(1)<max(gapslope) && p(1) >= min(gapslope) && p(2) <=max(startdot) && p(2) >= min(startdot)  %&& grads(m,3) == 1 && numLTP(m) > 0.3
        for n = 1:size(aa)
            xx = aa(n,1);
            yy =round(aa(n,1)*p(1)+p(2));
            imgdown2(xx,yy) = aa(n,2);
        end
    end
end

figure('Name','斜率约束'),imshow(imgdown2);
%起始点与角度投票

%% 斜率约束+梯度约束
img4 = zeros(M+2*Msize,N+2*Msize);
num = 1;
for m=1:ppnum
    aa=pplist{m};
    x = size(aa);
    x1 = x(1);
    p = polyfit(aa(:,1),aa(:,2),1);         %以60个点以上的点的斜率和起始点作为约束
    if p(1)<max(gapslope) && p(1) >= min(gapslope) && grads(m,3)>0
        for n = 1:size(aa)
            xx = aa(n,1);
            yy =round(aa(n,1)*p(1)+p(2));
            img4(xx,yy) = aa(n,2);
        end
    end
end

figure('Name','斜率约束+梯度约束'),imshow(img4);





