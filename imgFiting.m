clear all
close all
warning off


name = 'test18.png';

im=imread(name);
lineT=10;
M = 480;
N = 720;
win=31;
Msize=fix(win/2);

% function [result2]=imgFiting(nameJpg,lineT,M,N,Msize)
% im=imread(nameJpg);


%% 旋转图像
% M = 480;
% N = 720;
% im = imrotate(im,90);

im = imresize(im,[M,N]);

%% 开始计时
% tic
% figure('Name','缩略图'),imshow(im);

% 灰度化图像
% Im=rgb2hsv(im);
% Img3=rgb2gray(Im);
% figure('Name','灰度图Hsv'), imshow(Img3);


% Img2=rgb2gray(im);
% figure('Name','灰度图'), imshow(Img2);
% figure('Name','灰度图'), imshow(Img);
%  figure(1),imhist(Img2);
% imwrite(Img,'1grayImg.jpg');

Img=im(:,:,3);
% figure('Name','蓝原色'), imshow(Img);

% figure(2),imhist(Img);

% Img = imadjust(Img);      %增强对比度
% figure('Name','灰度图2'), imshow(Img);
% imhist(Img);

% for m = 3:M-2
%     for n = 3:N-2
%         Img(m,n) = LTP(Img,m,n,5,0);
%     end
% end
% figure('Name','LTP'), imshow(Img);
%% canny算法
bw = edge(Img,'canny',0.25);

figure('Name','边缘检测'),imshow(bw);

% 
% [L,Lnum] = bwlabel(bw,8);
% Llist = {Lnum};
% for i = 1:Lnum
%     [r,c]=find(L==i);
%     Llist{i} = [r,c];
% end

% imggradsX = zeros(M,N);
% for m = 1:length(Llist)
%     aa = Llist{m};
%     if length(aa) > 30
%         for n = 1:size(aa)
%             imggradsX(aa(n,1),aa(n,2)) = 255;
%         end
%     else
%         continue;
%     end
% %     end
% end
% figure('Name','横向梯度约束'),imshow(imggradsX);



%% alinecoding算法
% tic
bw1=zeros(M+2*Msize,N+2*Msize);
bw1(Msize+1:M+Msize,Msize+1:N+Msize)=bw;
[edgelist,edgeim,codeimg,dirlist,labelim] = alinecoding(bw1,lineT);
% toc

% imggrads= zeros(M+2*Msize,N+2*Msize);
% for m = 1:length(dirlist)
%     aa = dirlist{m};
% %     [x,y] = size(aa);
%     for n=1:length(aa)
%         xx = aa(n,1);
%         yy = aa(n,2);
%         imggrads(xx,yy) = 255;
%     end
% end

% figure('Name','梯度约束'),imshow(imggrads);  

% figure('Name','Cimg'),imshow(codeimg);

%% 灰度图扩充边界
img = zeros(M+2*Msize,N+2*Msize); 
for i = 1:M
    for j=1:N
        img(Msize+i,Msize+j) = Img(i,j);
    end
end

% %% 连续点数限制
% dirlistT = dirlist;
% for i=1:length(dirlistT)
%     if length(dirlistT{i})<lineT
%         dirlistT{i} = [];
%     end
% end
% dirlistT(cellfun(@isempty,dirlistT))=[];


%% 获取颜色梯度信息,并滤波
[dirlistG1,gradsX,gradsY] = gradsDetection(dirlist,img,M,N,Msize);
%% 获取斜率信息，并滤波
[dirlistS1,slope,flag] = slopeDetection(dirlistG1,img,M,N,Msize);
% 直线连接
[Llist,Lnum,slopeT]=lineConnection(dirlistS1,slope,img,M,N,Msize,lineT,flag);
% 
% %获取颜色梯度
[LlistG,grads]=gradsDetection2(Llist,img,M,N,Msize);

% 拟合直线
[result] = fitLine(LlistG,grads,M,N,Msize,flag);
% toc
result2 = zeros(length(result),3);
for m = 1:length(result)
    result2(m,1) = result(m,1)-Msize-1;
    result2(m,2) = result(m,2)-result(m,1);
    result2(m,3) = result(m,4);
end

%% 画出拟合直线
imgResult = Img;
for m = 1:length(result2)
    b = result2(m,1)-tan(result2(m,3))*(M/2+Msize);
    for xx = 1:M
        y = round(xx*tan(result2(m,3))+b);
        if y >=1 && y < N-result2(m,2)
            for yy = y:y+result2(m,2)
                imgResult(xx,yy) = 255;
            end
        end
    end
end   
figure('Name','直线拟合'),imshow(uint8(imgResult));


% %% 画出拟合直线
% imgResult = uint8(img);
% [lengthde,~] = size(result);
% for m = 1:lengthde
%     for n = result(m,1):result(m,2)
%         b = n-tan(result(m,4))*(M/2+Msize);
%         for xx = Msize:Msize+M
%             yy = round(xx*tan(result(m,4))+b);
%             if yy >=1 && yy < N+Msize
%                 imgResult(xx,yy) = 255;
%             end
%         end
%     end
% end   
% figure('Name','直线拟合'),imshow(uint8(imgResult));
