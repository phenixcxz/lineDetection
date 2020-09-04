clear all
close all

warning off

name = './data/DSC00100';

nameJpg = [name,'.jpg'];
nameJson = [name,'.json'];
im=imread(nameJpg);
% im = im(481:4320,721:6480,:);
lineT=20;
M = 480;
N = 720;
%% 旋转图像
% M = 720;
% N = 480;
% im = imrotate(im,90);

im = imresize(im,[M,N]);

%% 开始计时
tic
% figure('Name','缩略图'),imshow(im);

% 灰度化图像
% imHsv=rgb2hsv(im);
% imwrite(imHsv,'1imHsv.jpg');
% 
% Img=rgb2gray(imHsv);
% imwrite(Img,'1grayImg.jpg');

Img=im(:,:,3);
% figure('Name','灰度图'), imshow(Img);


% Img = imadjust(Img);      %增强对比度
% figure('Name','灰度图2'), imshow(Img);


% for m = 3:M-2
%     for n = 3:N-2
%         Img(m,n) = LTP(Img,m,n,5,0);
%     end
% end
% figure('Name','LTP'), imshow(Img);
%% canny算法
bw = edge(Img,'canny');
% figure('Name','边缘检测'),imshow(bw);

%% alinecoding算法
win=31;
Msize=fix(win/2);
bw1=zeros(M+2*Msize,N+2*Msize);
bw1(Msize+1:M+Msize,Msize+1:N+Msize)=bw;
[edgelist,edgeim,codeimg,dirlist,labelim] = alinecoding(bw1,0.01);
toc

% Cimg=codeimg(Msize+1:M+Msize,Msize+1:N+Msize);%编码图像
% Cimg=uint8(Cimg);
% figure('Name','Cimg'),imshow(Cimg);

%% 灰度图扩充边界
img = zeros(M+2*Msize,N+2*Msize); 
for i = 1:M
    for j=1:N
        img(Msize+i,Msize+j) = Img(i,j);
    end
end

%% 连续点数限制
dirlistT = dirlist;
for i=1:length(dirlistT)
    if length(dirlistT{i})<lineT
        dirlistT{i} = [];
    end
end
dirlistT(cellfun(@isempty,dirlistT))=[];



%% 获取颜色梯度信息,并滤波
[dirlistG1,gradsX,gradsY] = gradsDetection(dirlistT,img,M,N,Msize);
%% 获取斜率信息，并滤波
[dirlistS1,slope,flag] = slopeDetection(dirlistG1,img,M,N,Msize);
% 直线连接
[Llist,Lnum,slopeT]=lineConnection(dirlistS1,slope,img,M,N,Msize,lineT,flag);
% 
% %获取颜色梯度
[LlistG,grads]=gradsDetection(Llist,img,M,N,Msize);

% 拟合直线
[result] = fitLine(LlistG,grads,M,N,Msize,flag);
% [result] = fitLine(dirlistT,gradsY,M,N,Msize,flag);
toc %计时信息

%% 画出拟合直线
imgResult = uint8(img);
[lengthde,~] = size(result);
for m = 1:lengthde
    for n = result(m,1):result(m,2)
        b = n-tan(result(m,4))*(M/2+Msize);
        for xx = Msize:Msize+M
            yy = round(xx*tan(result(m,4))+b);
            if yy >=1 && yy < N+Msize
                imgResult(xx,yy) = 255;
            end
        end
    end
end   
figure('Name','直线拟合'),imshow(uint8(imgResult));


% addpath('./jsonlab-1.5');
% data=loadjson(nameJson);
% multiple = 1920/480;
% shapes = data.shapes;
% sLength = length(shapes);
% points = {sLength};
% for i = 1:sLength
%     temp = shapes(i);
%     points{i} = temp{1,1}.points;
% end
% 
% result = zeros(6,4);
% for i = 1:6
%    temp = points{i};
%    p1 = polyfit(temp(1:2,2),temp(1:2,1),1);
%    p2 = polyfit(temp(3:4,2),temp(3:4,1),1);
%    
%    slope1 = atan(p1(1));
%    slope2 = atan(p2(1));
%    startdot1 = round(p1(2)/multiple)+2;
%    startdot2 = round(p2(2)/multiple)+2;
%     if slope1 < 0
%         slope1 = pi+slope1;
%     end
%     if slope2 < 0
%         slope2 = pi+slope2;
%     end
%     slope = (slope1+slope2)/2;
% 
%     result(i,1) = startdot1;
%     result(i,2) =startdot2;
% %     result(i,3) = 
%     result(i,4) = slope;
% end
% 
% test = zeros(M+2*Msize,N+2*Msize);
% for m = 1:sLength
%     slope = result(m,:);
%     for n = slope(1,1):slope(1,2)
%         for xx = Msize+1:Msize+M
%             yy = round(xx*tan(slope(1,4))+n+Msize);
%             if yy >=1 && yy < N+Msize
%                 test(xx,yy) = 255;
%             end
%         end
%     end
% end
% 
% figure('Name','数据标注'),imshow(uint8(test));



% addpath('./jsonlab-1.5');
% data=loadjson(nameJson);
% multiple = 1920/480;
% shapes = data.shapes;
% sLength = length(shapes);
% points = {sLength};
% for i = 1:sLength
%     temp = shapes(i);
%     points{i} = temp{1,1}.points;
% end
% 
% result = zeros(6,4);
% for i = 1:6
%    temp = points{i};
%    p1 = polyfit(temp(1:2,2),temp(1:2,1),1);
%    p2 = polyfit(temp(3:4,2),temp(3:4,1),1);
%    
%    slope1 = atan(p1(1));
%    slope2 = atan(p2(1));
%    startdot1 = round(p1(2)/multiple)+2;
%    startdot2 = round(p2(2)/multiple)+2;
%     if slope1 < 0
%         slope1 = pi+slope1;
%     end
%     if slope2 < 0
%         slope2 = pi+slope2;
%     end
%     slope = (slope1+slope2)/2;
% 
%     result(i,1) = startdot1;
%     result(i,2) =startdot2;
% %     result(i,3) = 
%     result(i,4) = slope;
% end
% 
% test = zeros(M+2*Msize,N+2*Msize);
% for m = 1:sLength
%     slope = result(m,:);
%     for n = slope(1,1):slope(1,2)
%         for xx = Msize+1:Msize+M
%             yy = round(xx*tan(slope(1,4))+n+Msize);
%             if yy >=1 && yy < N+Msize
%                 test(xx,yy) = 255;
%             end
%         end
%     end
% end
% 
% figure('Name','数据标注'),imshow(uint8(test));
% 
% 
% 
% 
% % 1.面积重合率，2，斜率偏差率
% precision = zeros(6,6);
% 
% 
% for m = 1:length(result)
%     testNum1 = 0;
%     testNum2 = 0;
%     for n = result(m,1):result(m,2)
%         b = n-tan(result(m,4))*(M/2+Msize);
%         for xx = Msize:Msize+M
%             yy = round(xx*tan(result(m,4))+b);
%             if test(xx,yy)==255
%                 testNum1 = testNum1+1;
%             else
%                 testNum2 = testNum2+1;
%             end
%         end
%     end
% end 


% for m = 1:length(result)
%     testNum1 = 0;
%     testNum2 = 0;
%     for n = result(m,1):result(m,2)
%         b = n-tan(result(m,4))*(M/2+Msize);
%         for xx = Msize:Msize+M
%             yy = round(xx*tan(result(m,4))+b);
%             if test(xx,yy)==255
%                 testNum1 = testNum1+1;
%             else
%                 testNum2 = testNum2+1;
%             end
%         end
%     end
%     precision(m,1) = testNum1/(testNum1+testNum2);
%     precision(m,2) = testNum2/(testNum1+testNum2);
% end 





