clear all
close all

warning off
im=imread('DSC00038.jpg');
lineT=20;
%%旋转图像
% im = imrotate(im,90);
% im = imresize(im,[640,480]);

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


% Img = imadjust(Img);      %增强对比度
% figure('Name','灰度图2'), imshow(Img);
[M,N]=size(Img);

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
%% 灰度图扩充边界
img = zeros(M+2*Msize,N+2*Msize); 
for i = 1:M
    for j=1:N
        img(Msize+i,Msize+j) = Img(i,j);
    end
end

%% 获取颜色梯度信息
[grads1,grads2] = gradsDetection(dirlist_lineT,dirlistT_lens,img,M,N,Msize);
%% 获取斜率信息
[slope,slValueLeft,slValueRight,slopeX] = slopeDetection(dirlist_lineT,dirlistT_lens,img,M,N,Msize);

imgResult = zeros(M+2*Msize,N+2*Msize);

lineNum = 0;
for m = 1:dirlistT_lens
%     if slopeX(m,1) == 1 && (grads2(m,3)>0 || grads1(m,3) >0)
    if slopeX(m,1) == 1 && grads1(m,3)>0 
        aa = dirlist_lineT{m};
        aaMax = max(aa(:,1));
        aaMin = min(aa(:,1));
        lineNum = lineNum+1;
        for n = aaMin:aaMax
            xx = n;
            yy = round(n*tan(slope(m,1))+slope(m,2));
            if yy < N+2*Msize && yy >= 1
                imgResult(xx,yy) = 255;
            end
        end
    elseif slopeX(m,1) == 2 && (grads2(m,3)>0 || grads1(m,3) >0)
        aa = dirlist_lineT{m};        
        aaMax = max(aa(:,2));
        aaMin = min(aa(:,2));
        lineNum = lineNum+1;
        for n = aaMin:aaMax
            yy = n;
            xx = round((yy-slope(m,2))/tan(slope(m,1)));
            if xx < M+2*Msize && xx >= 1
                imgResult(xx,yy) = 255;
            end
        end 
    end
end

figure('Name','斜率约束+梯度约束'),imshow(imgResult);

slope2 = zeros(lineNum,4);
lineNum = 0;
for m = 1:dirlistT_lens
    if slopeX(m,1) == 1 && (grads2(m,3)>0 || grads1(m,3) >0)
        lineNum = lineNum+1;
        slope2(lineNum,1) = slope(m,1);
        slope2(lineNum,2) = slope(m,2);
        slope2(lineNum,3) = slope(m,3);
        slope2(lineNum,4) = m;
    elseif slopeX(m,1) == 2 && (grads2(m,3)>0 || grads1(m,3) >0)
        lineNum = lineNum+1;
        slope2(lineNum,1) = slope(m,1);
        slope2(lineNum,2) = slope(m,2);
        slope2(lineNum,3) = slope(m,3);
        slope2(lineNum,4) = m;        
    end
end

[~,pos] = sort(slope2(:,3));
slope2(:,4) = slope2(pos,4);
slope2(:,3) = slope2(pos,3);
slope2(:,2) = slope2(pos,2);
slope2(:,1) = slope2(pos,1);

%% 由长线向两边延伸，直到碰到
imgResult3 = uint8(imgResult) ;
% lineNum = 0;
for m = lineNum:-1:1
    aa = dirlist_lineT{slope2(m,4)};
    xx1 = min(aa(:,1));
    xx2 = max(aa(:,1));
%     yy = round(*tan(slope2(m,1))+slope2(m,2));
    for xx = xx1-1:-1:Msize
        yy = round(xx*tan(slope2(m,1))+slope2(m,2));
        if yy < N+2*Msize && yy >1 
            if imgResult3(xx,yy)==0 &&imgResult3(xx,yy+1)==0 && imgResult3(xx,yy-1)==0
                imgResult3(xx,yy) = 255;
            else
                break;
            end
        end
    end
    for xx = xx2+1:M+Msize
        yy = round(xx*tan(slope2(m,1))+slope2(m,2));
        if yy < N+2*Msize && yy > 1 
            if imgResult3(xx,yy)==0 &&imgResult3(xx,yy+1)==0 && imgResult3(xx,yy-1)==0
                imgResult3(xx,yy) = 255;
            else
                break;
            end 
        end
    end  
end
figure('Name','延长线'),imshow(uint8(imgResult3));


%% 直线拟合
imgResult4 = uint8(img) ;
% lineNum = 0;
% for m = lineNum:-1:1
%     aa = dirlist_lineT{slope2(m,4)};
%     xx1 = min(aa(:,1));
%     xx2 = max(aa(:,1));
% %     yy = round(*tan(slope2(m,1))+slope2(m,2));
%     for xx = xx1-1:-1:Msize
%         yy = round(xx*tan(slope2(m,1))+slope2(m,2));
%         if yy < N+2*Msize && yy >1 
%             if imgResult3(xx,yy)==0 &&imgResult3(xx,yy+1)==0 && imgResult3(xx,yy-1)==0
%                 imgResult3(xx,yy) = 255;
%             else
%                 break;
%             end
%         end
%     end
%     for xx = xx2+1:M+Msize
%         yy = round(xx*tan(slope2(m,1))+slope2(m,2));
%         if yy < N+2*Msize && yy > 1 
%             if imgResult3(xx,yy)==0 &&imgResult3(xx,yy+1)==0 && imgResult3(xx,yy-1)==0
%                 imgResult3(xx,yy) = 255;
%             else
%                 break;
%             end 
%         end
%     end  
% end


%% 投票选出直线
%中点，斜率，斜率票数，左边缘票数，右边缘票数，线宽1票数，线宽2票数，线宽3票数，线宽4票数
% devote = zeros(dirlistT_lens,9);
% imgResult4 = uint8(imgResult) ;
% lineNum = 0;
% for m = 1:dirlistT_lens
%     devote(m,1) = slope(m,5);   %中点
%     devote(m,2) = slope(m,1);   %斜率
%     devote(m,3) = slope(m,3);   %斜率票数
%     devote(m,4) = grads1(m,1);  %左边缘票数
%     devote(m,5) = grads1(m,2);  %右边缘票数
%     devote(m,6) = grads1(m,4)+grads1(m,8);      %线宽1票数
%     devote(m,7) = grads1(m,5)+grads1(m,9);      %线宽2票数
%     devote(m,8) = grads1(m,6)+grads1(m,10);     %线宽3票数
%     devote(m,9) = grads1(m,7)+grads1(m,11);     %线宽4票数
% end
% figure('Name','延长线'),imshow(uint8(imgResult3));



%% 线信息统计
devote = zeros(lineNum,9);
for n = 1:lineNum
    m = slope2(n,4);
    devote(n,1) = slope(m,5);   %中点
    devote(n,2) = slope(m,1);   %斜率
    devote(n,3) = slope(m,3);   %斜率票数
    devote(n,4) = grads1(m,1);  %左边缘票数
    devote(n,5) = grads1(m,2);  %右边缘票数
    devote(n,6) = grads1(m,4)+grads1(m,8);      %线宽1票数
    devote(n,7) = grads1(m,5)+grads1(m,9);      %线宽2票数
    devote(n,8) = grads1(m,6)+grads1(m,10);     %线宽3票数
    devote(n,9) = grads1(m,7)+grads1(m,11);     %线宽4票数
end

%% 平均弧度
slNum = 0;
slSum = 0;
slBorder = 0;
aveSlope = 0;
if slValueLeft> slValueRight
    slBorder = 1;
%     aveSlope = (slValueLeft +slValueRight-pi)/2;    
% else
%     aveSlope = (slValueLeft +slValueRight)/2; 
end

    
for m = 1:lineNum
    slNum = slNum+devote(m,3);
    if slBorder >0 && devote(m,2)>3
        slSum = slSum+(devote(m,2)-pi)*devote(m,3);
    else
        slSum = slSum+devote(m,2)*devote(m,3);
    end
end
aveSlope = slSum/slNum;


% aveSlope = (slValueLeft+slValueRight)/2;
%% 归一化
% 左起始点，右起始点，票数
devoteFun = zeros(lineNum,3);
for m = lineNum:-1:1
    [num,x] = max(devote(m,6:9));
    if devote(m,4) > devote(m,5)
        devoteFun(m,1) = devote(m,1)+1;
        devoteFun(m,2) = devoteFun(m,1)+x;
        devoteFun(m,3) = devote(m,3);
    else
        devoteFun(m,1) = devote(n,1)-x-1;
        devoteFun(m,2) = devoteFun(m,1)+x;  
        devoteFun(m,3) = devote(m,3);
    end
end

% 区间排序
[~,pos] = sort(devoteFun(:,1));
devoteFun(:,1) = devoteFun(pos,1);
devoteFun(:,2) = devoteFun(pos,2);
devoteFun(:,3) = devoteFun(pos,3);
%和并重复区间
devote2 = zeros(lineNum,3);
num = 0;
m = 1;
while(m <=lineNum) 
    num = num+1;
    devote2(num,1) = devoteFun(m,1);
    devote2(num,2) = devoteFun(m,2);
    devote2(num,3) = devoteFun(m,3);
    for n = m+1:lineNum
        if devoteFun(n,1) <= devote2(num,2)  %区间重合合并
            devote2(num,3) = devote2(num,3)+devoteFun(n,3);        %统计票数        
            if devoteFun(n,2) > devote2(num,2)
                devote2(num,2) = devoteFun(n,2);   
            else
                continue;
            end
        else
            m = n;
            break;
        end
    end
    if devote2(num,2) >= devoteFun(lineNum,2)
        break;
    end
    m = m+1;
end

%% 画出拟合直线

imgResult4 = uint8(img) ;
for m = 1:lineNum
    if devote2(m,3)>100
        for n = devote2(m,1):devote2(m,2)
            b = n-tan(aveSlope)*(M/2+Msize);
            for xx = Msize:Msize+M
                yy = round(xx*tan(aveSlope)+b);
                if yy >=1 && yy < N+Msize
                    imgResult4(xx,yy) = 255;
                end
            end
        end
    end
end
        
figure('Name','直线拟合'),imshow(uint8(imgResult4));



    








