clear all
close all

warning off
im=imread('DSC00172.jpg');
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
imgResult2 = img;
for m = 1:dirlistT_lens
    if slopeX(m,1) == 1 
        if grads1(m,3) >0
            temp = 0;
            numtemp = 0;
            if grads1(m,3)==1 %&& slope(m,3)>120
                aa = dirlist_lineT{m};
                aaMax = max(aa(:,1));
                aaMin = min(aa(:,1));
                for n = Msize+1:M+Msize
%                 for n = aaMin:aaMax
                    xx = n;
                    yy = round(n*tan(slope(m,1))+slope(m,2));
%                     temp
                    if yy < N+2*Msize && yy >= 1
                        imgResult2(xx,yy+1) = 255;
                    end
                end
            else 
                aa = dirlist_lineT{m};
                aaMax = max(aa(:,1));
                aaMin = min(aa(:,1));
                for n = Msize+1:M+Msize
%                 for n = aaMin:aaMax
                    xx = n;
                    yy = round(n*tan(slope(m,1))+slope(m,2));
                    if yy < N+2*Msize && yy > 1
                        imgResult2(xx,yy-1) = 255;
                    end
                end                
            end
        elseif grads2(m,3) > 0
            aa = dirlist_lineT{m};
            aaMax = max(aa(:,1));
            aaMin = min(aa(:,1));
            for n = aaMin:aaMax
                xx = n;
                yy = round(n*tan(slope(m,1))+slope(m,2));
                if yy < N+2*Msize && yy >= 1
                    imgResult2(xx,yy-1) = 255;
                    imgResult2(xx,yy-2) = 255;
                    imgResult2(xx,yy-3) = 255;
                end
            end 
        end
    elseif slopeX(m,1) == 2
        if grads1(m,3)>0 
        aa = dirlist_lineT{m};        
        aaMax = max(aa(:,2));
        aaMin = min(aa(:,2));
        for n = aaMin:aaMax
            yy = n;
            xx = round((yy-slope(m,2))/tan(slope(m,1)));
            if xx < M+2*Msize && xx >= 1
                imgResult2(xx+1,yy) = 255;
                imgResult2(xx+2,yy) = 255;
            end
        end
        elseif grads2(m,3)>0
            aa = dirlist_lineT{m};        
            aaMax = max(aa(:,2));
            aaMin = min(aa(:,2));
            for n = aaMin:aaMax
%             for n = aaMin:aaMax
                yy = n;
                xx = round((yy-slope(m,2))/tan(slope(m,1)));
                if xx < M+2*Msize && xx >= 1
                imgResult2(xx-1,yy) = 255;
                imgResult2(xx-2,yy) = 255;
                end
            end
        end 
    end
end
figure('Name','原图显示'),imshow(uint8(imgResult2));




