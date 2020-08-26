clear all
close all

warning off
im=imread('dsc00041.jpg');

%%旋转图像
% im = imrotate(im,90);

lineT=20;
im = imresize(im,[480,640]);

% figure('Name','缩略图'),imshow(im);

%% 灰度化图像
% imHsv=rgb2hsv(im);
% imwrite(imHsv,'1imHsv.jpg');
% 
% Img=rgb2gray(imHsv);
% imwrite(Img,'1grayImg.jpg');

Img=im(:,:,3);

figure('Name','灰度图'), imshow(Img);


[M,N]=size(Img);

%% canny算法
bw = edge(Img,'canny');
% figure('Name','边缘检测'),imshow(bw);

%% alinecoding算法
Model={};
win=31;
for ii=1:180
    Mv=GenVector(win,ii);
    Model{ii}=uint8(Mv);     
end

Msize=fix(win/2);
bw1=zeros(M+2*Msize,N+2*Msize);
bw1(Msize+1:M+Msize,Msize+1:N+Msize)=bw;
[edgelist,edgeim,codeimg,dirlist,labelim] = alinecoding(bw1,0.005);

pplist={};
ppnum=0;

Cimg=codeimg(Msize+1:M+Msize,Msize+1:N+Msize);%编码图像
Cimg=uint8(Cimg);

imgn = zeros(M+2*Msize,N+2*Msize); 

% figure('Name','Cimg'),imshow(Cimg);

%% 连续点数限制
dirlist_lineT = {};
dirnum = 0;
len1 = length(dirlist);
for i=1:len1
    len2 = length(dirlist{i});
    if len2>lineT
        temp = dirlist{i};
        for j = 1:len2
            imgn(temp(j,1),temp(j,2)) = 255;
        end
        dirnum = dirnum+1;
        dirlist_lineT{dirnum} = dirlist{i};
    end
end

figure('Name','点数阈值'),imshow(imgn);

dirlistT_lens = length(dirlist_lineT);

%% 直线拟合+信息统计
imgdown = zeros(M+2*Msize,N+2*Msize);
slope=zeros(dirlistT_lens,3);       %斜率计算

fitline = dirlist_lineT;
for m=1:dirlistT_lens
    aa=dirlist_lineT{m};  %待处理线段
    [x1,x2] = size(aa);
    p = polyfit(aa(3:x1-3,1),aa(3:x1-3,2),1);     %线段斜率与起始点
    slope(m,1) = p(1);
    slope(m,2) = round(p(2));
    x = length(aa);
    slope(m,3) = x;                  %点数记录 
    bb = fitline{m};
    if p(1)<1 && p(1) > -1   
        maxaa = max(aa(:,1));
        minaa = min(aa(:,1));
        for n = minaa:maxaa
            xx = n;
            yy =round(n*p(1)+p(2));
            if yy < N+2*Msize && yy >= 1
                imgdown(xx,yy) = 255;
            end
        end
    else
        maxaa = max(aa(:,2));
        minaa = min(aa(:,2));
        for n = minaa:maxaa                 %线段拟合
            yy = n;
            xx = round((yy-p(2))/p(1));
            bb(n,1) = xx;
            bb(n,2) = yy;
            if xx < M+2*Msize && xx >= 1
                imgdown(xx,yy) = 255;
            end
        end
    end
    fitline{m} = bb;
end
figure('Name','直线拟合'),imshow(imgdown);

%% 斜率排序
a3 = slope(:,3);
[a3,pos] = sort(a3);
slope(:,3) = slope(pos,3);
slope(:,2) = slope(pos,2);
slope(:,1)= slope(pos,1);

%% 寻找适合斜率
[slsize,y] = size(slope);
dotNum = 20;
figure(21)
slHist = histogram(slope(slsize-dotNum+1:slsize,1));   %斜率直方图

slValue = slHist.Values;
slEdge = slHist.BinEdges;

slEdgeLeft = 0;
slEdgeRight = 0;

for i = 1:length(slValue)
    if slValue(i) > dotNum/4
        slEdgeLeft = slEdge(i);
        break;
    end
end
for i = length(slValue):-1:1
    if slValue(i) > dotNum/4
        slEdgeRight = slEdge(i+1);
        break;
    end
end

% [slMax,slLocate] = max(slValue);

% slEdgeLeft = slEdge(slLocate);      
% slEdgeRight = slEdge(slLocate+1);

meanValue = 0;
meanNum = 0;
for i = slsize-dotNum+1:slsize
    if slope(i,1)>slEdgeLeft && slope(i,1) < slEdgeRight
        meanNum = meanNum+1;
        meanValue = meanValue + slope(i,1);
    end
end

if meanValue>0
    slValueLeft = meanValue/meanNum*1/2; %%斜率边界
    slValueRight = meanValue/meanNum*3/2;
else
    slValueLeft = meanValue/meanNum*3/2; %%斜率边界
    slValueRight = meanValue/meanNum*1/2; 
end

imgSlope = zeros(M+2*Msize,N+2*Msize);
for m = 1:dirlistT_lens
    aa = dirlist_lineT{m};
    aaLen = length(aa);
    p = polyfit(aa(4:aaLen-3,1),aa(4:aaLen-3,2),1);
    aaSlope = p(1);
    aaDot = p(2);
    if aaSlope(1) <1 && aaSlope > -1 
        if aaSlope>slValueLeft && aaSlope < slValueRight
            aaMax = max(aa(:,1));
            aaMin = min(aa(:,1));
            for n = aaMin:aaMax
                xx = n;
                yy = round(n*aaSlope+aaDot);
                if yy < N+2*Msize && yy >= 1
                    imgSlope(xx,yy) = 255;
                end
            end
        end
    else
        if aaSlope > slValueLeft && aaSlope < slValueRight
            aaMax = max(aa(:,2));
            aaMin = min(aa(:,2));
            for n = aaMin:aaMax
                yy = n;
                xx = round((yy-aaDot)/aaSlope);
                if xx < M+2*Msize && xx >= 1
                    imgSlope(xx,yy) = 255;
                end
            end 
        end
    end
end


figure('Name','斜率约束'),imshow(imgSlope);

imgdown3 = zeros(M+2*Msize,N+2*Msize);
num = 1;
for m=1:dirlistT_lens
    aa=dirlist2{m};
    bb = fitline{m};  
end
%% 灰度图扩充边界
img = zeros(M+2*Msize,N+2*Msize); 
for i = 1:M
    for j=1:N
        img(Msize+i,Msize+j) = Img(i,j);
    end
end

grads = zeros(dirlistT_lens,3);
gap = 5;
for m=1:dirlistT_lens
    aa = dirlist2{m};
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
%% 梯度约束
imgGrads = zeros(M+2*Msize,N+2*Msize);
for m = 1:dirlistT_lens
    aa = dirlist2{m};
    [x,y] = size(aa);
    if grads(m,3)>0
        for n = 1:size(aa)
            imgGrads(aa(n,1),aa(n,2)) = 255;
        end
    end
end
figure('Name','梯度约束'),imshow(imgGrads);

% figure('Name','方差约束'),imshow(imgdown3);

%% 直线拟合

% img5 = img;
% grads = zeros(dirlistT_lens,3);
% gap = 5;
% for m=1:dirlistT_lens
%     aa = dirlist2{m};
%     [num,t] = size(aa);
%     for n = 1:size(aa)
%         x=aa(n,1);
%         y=aa(n,2);
%         if img(x,y+1) - img(x,y) > gap   %左边缘
%             if img(x,y+1) - img(x,y+2) > gap || img(x,y+2) - img(x,y+3) > gap || img(x,y+3) - img(x,y+4) > gap || img(x,y+4) - img(x,y+5) > gap%右边缘
%                 grads(m,1) = grads(m,1)+1;
%             end
%         end
%         
%         if img(x,y-1) - img(x,y) > gap   %右边缘
%             if img(x,y-1) - img(x,y-2) > gap || img(x,y-2) - img(x,y-3) > gap || img(x,y-3) - img(x,y-4) > gap || img(x,y-4) - img(x,y-5) > gap %左边缘
%                 grads(m,2) = grads(m,2)+1;
%             end            
%         end
%     end
%     for n = 1:size(aa)
%         x = aa(n,1);
%         y = aa(n,2);
%         if grads(m,1)/num >4/5 
%             if img(x,y+1) - img(x,y+2) < gap 
%                 img5(x,y+1) = 255;
%             end
%             if img(x,y+2) - img(x,y+3) < gap 
%                 img5(x,y+2) = 255;
%             end
%             if img(x,y+3) - img(x,y+4) < gap 
%                 img5(x,y+3) = 255;
%             end
%             if img(x,y+4) - img(x,y+5) < gap 
%                 img5(x,y+4) = 255;
%             end
%         end
%         if grads(m,2)/num >4/5
%             if img(x,y-1) - img(x,y-2) < gap
%                 img5(x,y-1) = 255;
%             end
%             if img(x,y-2) - img(x,y-3) < gap
%                 img5(x,y-2) = 255;
%             end
%             if img(x,y-3) - img(x,y-4) < gap
%                 img5(x,y-3) = 255;
%             end
%             if img(x,y-4) - img(x,y-5) < gap
%                 img5(x,y-4) = 255;
%             end   
%         end
%     end
% end
% 
% img6 = img5(Msize+1:Msize+M,Msize+1:Msize+N);
% img6 = uint8(img6);
% figure('Name','直线拟合'),imshow(img6);

%% 斜率约束+梯度约束+直线拟合
img4 = zeros(M+2*Msize,N+2*Msize);
for m=1:dirlistT_lens
    aa=dirlist2{m};
    x = size(aa);
    x1 = x(1);
    p = polyfit(aa(4:x1-3,1),aa(4:x1-3,2),1);         %以60个点以上的点的斜率和起始点作为约束
    if p(1)<=max(slope5)+0.1 && p(1) >= min(slope5)-0.1 && grads(m,3)>0 
        if p(1)<1 && p(1) > -1   
            maxaa = max(aa(:,1));
            minaa = min(aa(:,1));
            for n = minaa:maxaa
                xx = n;
                yy =round(n*p(1)+p(2));
                if yy < N+2*Msize && yy >= 1
                    img4(xx,yy) = 255;
                end
            end
        else
            maxaa = max(aa(:,2));
            minaa = min(aa(:,2));
            for n = minaa:maxaa                 %线段拟合
                yy = n;
                xx = round((yy-p(2))/p(1));
                bb(n,1) = xx;
                bb(n,2) = yy;
                if xx < M+2*Msize && xx >= 1
                    img4(xx,yy) = 255;
                end
            end
        end
    end
end

figure('Name','斜率约束+梯度约束'),imshow(img4);




