clear all
close all

warning off
im=imread('DSC00293.jpg');
lineT=30;
%%旋转图像
% im = imrotate(im,45);
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
figure('Name','边缘检测'),imshow(bw);

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
    if length(aa)>50
%     yy = round(*tan(slope2(m,1))+slope2(m,2));
%     for xx = xx1-1:-1:Msize     %向-x方向延长
        xx1length = xx1-length(aa)*2;
    for xx = xx1-1:-1:max(Msize,xx1length)     %向-x方向延长        
        yy = round(xx*tan(slope2(m,1))+slope2(m,2));
        if yy < N+2*Msize && yy >1 
            if imgResult3(xx+1,yy)==255 &&imgResult3(xx,yy)==0 &&imgResult3(xx,yy+1)==0 && imgResult3(xx,yy-1)==0
                imgResult3(xx,yy) = 255;
            elseif imgResult3(xx+1,yy)==0 && imgResult3(xx,yy)==0
                imgResult3(xx,yy) = 255;
            else
                break;
            end
        end
    end
    xx2length = xx2+length(aa)*2;
%     for xx = xx2+1:M+Msize      %向+x方向延长
    for xx = xx2+1:min(M+Msize,xx2length)     %向+x方向延长
        yy = round(xx*tan(slope2(m,1))+slope2(m,2));
        if yy < N+2*Msize && yy > 1 
            if imgResult3(xx-1,yy)==255 && imgResult3(xx,yy)==0 &&imgResult3(xx,yy+1)==0 && imgResult3(xx,yy-1)==0
                imgResult3(xx,yy) = 255;
            elseif imgResult3(xx-1,yy)==0 && imgResult3(xx,yy)==0
                imgResult3(xx,yy) = 255;
            else
                break;
            end 
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
    aveSlope = (slValueLeft +slValueRight-pi)/2;    
else
    aveSlope = (slValueLeft +slValueRight)/2; 
end
% for m = 1:lineNum
%     slNum = slNum+devote(m,3);
%     if slBorder >0 && devote(m,2)>3
%         slSum = slSum+(devote(m,2)-pi)*devote(m,3);
%     else
%         slSum = slSum+devote(m,2)*devote(m,3);
%     end
% end
% aveSlope = slSum/slNum;


% aveSlope = (slValueLeft+slValueRight)/2;
%% 归一化
% 左起始点，右起始点，票数
devoteFun = zeros(lineNum,4);
for m = lineNum:-1:1
%     [num,x] = max(devote(m,6:9));
    x = round((devote(m,6)*1+devote(m,7)*2+devote(m,8)*3+devote(m,9)*4)/(devote(m,6)+devote(m,7)+devote(m,8)+devote(m,9)));
    if devote(m,4) > devote(m,5)
        devoteFun(m,1) = devote(m,1)+1;
        devoteFun(m,2) = devoteFun(m,1)+x;
        devoteFun(m,3) = devote(m,3);
        devoteFun(m,4) = devote(m,2);
    else
        devoteFun(m,1) = devote(n,1)-x-1;
        devoteFun(m,2) = devoteFun(m,1)+x;  
        devoteFun(m,3) = devote(m,3);
        devoteFun(m,4) = devote(m,2);
    end
end

% 区间排序
[~,pos] = sort(devoteFun(:,1));
devoteFun(:,1) = devoteFun(pos,1);
devoteFun(:,2) = devoteFun(pos,2);
devoteFun(:,3) = devoteFun(pos,3);
devoteFun(:,4) = devoteFun(pos,4);
%和并重复区间
devote2 = zeros(lineNum,4);
num = 0;
m = 1;
% while(m <=lineNum) 
%     num = num+1;
%     devote2(num,1) = devoteFun(m,1);
%     devote2(num,2) = devoteFun(m,2);
%     devote2(num,3) = devoteFun(m,3);
%     for n = m+1:lineNum
%         if devoteFun(n,1) <= devote2(num,2)  %区间重合合并
%             devote2(num,3) = devote2(num,3)+devoteFun(n,3);        %统计票数        
%             if devoteFun(n,2) > devote2(num,2)
%                 devote2(num,2) = devoteFun(n,2);   
%             else
%                 continue;
%             end
%         else
%             m = n;
%             break;
%         end
%     end
%     if devote2(num,2) >= devoteFun(lineNum,2)
%         break;
%     end
%     m = m+1;
% end
while(m <=lineNum) 
    num = num+1;
    devote2(num,1) = devoteFun(m,1);
    devote2(num,2) = devoteFun(m,2);
    devote2(num,3) = devoteFun(m,3);
    devote2(num,4) = devoteFun(m,4);
    ind = find(devote2(num,2)<devoteFun(:,1));
    if length(ind) == 0     %合并最后一条线
        for n = m+1:lineNum
           devote2(num,3) = devote2(num,3)+devoteFun(n,3);
        end
        break;
    end
    
    %% 统计票数
    for n = m+1:ind(1)-1    %统计票数
        devote2(num,3) = devote2(num,3)+devoteFun(n,3);
    end
    m = ind(1);
end


%% 画出拟合直线

imgResult4 = uint8(img) ;
for m = 1:lineNum
    if devote2(m,3)>100
        for n = devote2(m,1):devote2(m,2)
            b = n-tan(aveSlope)*(M/2+Msize);
%             b = n-tan(devote2(m,4))*(M/2+Msize);
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

[L,Lnum] = bwlabel(imgResult3,8);
Llist = {Lnum};
for i = 1:Lnum
    [r,c]=find(L==i);
    Llist{i} = [r,c];
end
 
[grads3,grads4]=gradsDetection2(Llist,Lnum,img,M,N,Msize);


% imgResult6 = uint8(img) ;
% for m = 1:Lnum
%     aa = Llist{m};
%     for n = 1:length(aa)
%         xx = aa(n,1);
%         yy = aa(n,2);
%         imgResult6(xx,yy) = 255;
%     end
% end
% figure('Name','直线拟合3'),imshow(uint8(imgResult6));




slope5=zeros(Lnum,5);       %斜率计算
for m=1:Lnum
    aa=Llist{m};  %待处理线段
    x = length(aa);
    p = polyfit(aa(round(x*2/10):round(x*8/10),1),aa(round(x*2/10):round(x*8/10),2),1);     %线段斜率与起始点
    slope5(m,1) = atan(p(1));
    if slope5(m,1) < 0
        slope5(m,1) = pi+slope5(m,1);
    end
    slope5(m,2) = round(p(2));       %起始点
%     slope(m,5) = round(p(2));
    slope5(m,5) = round(p(1)*(M/2+Msize)+p(2));      %中点
    slope5(m,3) = x;                 %连续点个数
end

%% 线信息统计
devote10 = zeros(Lnum,9);
for n = 1:Lnum
%     m = slope2(n,4);
    devote10(n,1) = slope5(n,5);   %中点
    devote10(n,2) = slope5(n,1);   %斜率
    devote10(n,3) = slope5(n,3);   %斜率票数
    devote10(n,4) = grads3(n,1);  %左边缘票数
    devote10(n,5) = grads3(n,2);  %右边缘票数
    devote10(n,6) = grads3(n,4)+grads3(n,8);      %线宽1票数
    devote10(n,7) = grads3(n,5)+grads3(n,9);      %线宽2票数
    devote10(n,8) = grads3(n,6)+grads3(n,10);     %线宽3票数
    devote10(n,9) = grads3(n,7)+grads3(n,11);     %线宽4票数
end
for m=1:Lnum
    slope5(m,4) = grads3(m,3);
end

devoteFun2 = zeros(Lnum,4);
for m = 1:Lnum
%     [num,x] = max(devote(m,6:9));
    x = round((devote10(m,6)*1+devote10(m,7)*2+devote10(m,8)*3+devote10(m,9)*4)/(devote10(m,6)+devote10(m,7)+devote10(m,8)+devote10(m,9)));
    if devote10(m,4) > devote10(m,5)
        devoteFun2(m,1) = devote10(m,1)+1;      %左区间
        devoteFun2(m,2) = devoteFun2(m,1)+x;
        devoteFun2(m,3) = devote10(m,3);
        devoteFun2(m,4) = devote10(m,2);
    else
        devoteFun2(m,1) = devote10(m,1)-x-1;    %右区间
        devoteFun2(m,2) = devoteFun2(m,1)+x;  
        devoteFun2(m,3) = devote10(m,3);
        devoteFun2(m,4) = devote10(m,2);
    end
end

% [~,pos] = sort(slope5(:,5));
% slope5(:,5) = slope5(pos,5);
% slope5(:,4) = slope5(pos,4);
% slope5(:,3) = slope5(pos,3);
% slope5(:,2) = slope5(pos,2);
% slope5(:,1) = slope5(pos,1);

% 区间排序
[~,pos] = sort(devoteFun2(:,1));
devoteFun2(:,1) = devoteFun2(pos,1);
devoteFun2(:,2) = devoteFun2(pos,2);
devoteFun2(:,3) = devoteFun2(pos,3);
devoteFun2(:,4) = devoteFun2(pos,4);
%和并重复区间
devote11 = zeros(Lnum,4);
num = 0;
m = 1;
while(m <=Lnum) 
    num = num+1;
    devote11(num,1) = devoteFun2(m,1);
    devote11(num,2) = devoteFun2(m,2);
    devote11(num,3) = devoteFun2(m,3);
    devote11(num,4) = devoteFun2(m,4);
    ind = find(devote11(num,2)<devoteFun2(:,1));
    if isempty(ind)     %合并最后一条线
        for n = m+1:Lnum
           devote11(num,3) = devote11(num,3)+devoteFun2(n,3);
        end
        break;
    end
    
    %% 统计票数
    for n = m+1:ind(1)-1    %统计票数
        devote11(num,3) = devote11(num,3)+devoteFun2(n,3);
    end
    m = ind(1);
end


%% 画出拟合直线

imgResult10 = uint8(img) ;
for m = 1:Lnum
    if devote11(m,3)>100
        for n = devote11(m,1):devote11(m,2)
            b = n-tan(aveSlope)*(M/2+Msize);
%             b = n-tan(devote2(m,4))*(M/2+Msize);
            for xx = Msize:Msize+M
                yy = round(xx*tan(aveSlope)+b);
                if yy >=1 && yy < N+Msize
                    imgResult10(xx,yy) = 255;
                end
            end
        end
    end
end
        
figure('Name','直线拟合3'),imshow(uint8(imgResult10));

% imgResult5 = uint8(img) ;
% m = 1;
% while(m <=Lnum)
%     if slope5(m,3) > 300 && slope5(m,3) <800
%         for i = m+1:Lnum
%             if slope5(m,3) > 300 && slope5(m,3) < 800
%                 ind = i;
%                 break;
%             end
%         end    
%         for n = slope5(m,5)+1:slope5(ind,5)-1
%             b = n-tan(aveSlope)*(M/2+Msize);
%             for xx = Msize:M+Msize
%                 yy = round(xx*tan(aveSlope)+b);
%                 if yy >=1 && yy < N+Msize
%                     imgResult5(xx,yy) = 255;
%                 end
%             end
%         end
%         m = ind+1;
%     elseif slope5(m,3) > 800
%         for n = slope5(m,5)-1:slope5(m,5)+1
%                 b = n-tan(aveSlope)*(M/2+Msize);
%                 for xx = Msize:M+Msize
%                     yy = round(xx*tan(aveSlope)+b);
%                     if yy >=1 && yy < N+Msize
%                         imgResult5(xx,yy) = 255;
%                     end
%                 end
%         end
%         m = m+1;
%         
% %     else
%     else
%         m = m+1;
%     end
% end
% 
% figure('Name','直线拟合2'),imshow(uint8(imgResult5));
%     








