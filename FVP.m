% Read the sample image in
% clear all
% close all 
% tic
    %str=sprintf('%.0f.jpg',i);
    %str1=sprintf('1-code%.0f.bmp',i);
    %str2=sprintf('1-p%.0f.bmp',i);
    %im = imread(str);
%     im=imread('15.jpg');
function [xd,yd]=FVP(im,lineT, win1)
    Img=rgb2gray(im);
    bw = edge(Img,'canny');
   %  bw=im2bw(Img);
    [M,N]=size(bw);
%     figure
%     imshow(bw);
    Model={};
    win=41;
    for ii=1:180
        Mv=GenVector(win,ii);
        Model{ii}=uint8(Mv);     
    end
    Msize=fix(win/2);
    bw1=zeros(M+2*Msize,N+2*Msize);
    bw1(Msize+1:M+Msize,Msize+1:N+Msize)=bw;
    [edgelist,edgeim,codeimg,dirlist,labelim] = alinecoding(bw1,0);

    pplist={};
    ppnum=0;
 
    Cimg=codeimg(Msize+1:M+Msize,Msize+1:N+Msize);%编码图像
    Cimg=uint8(Cimg);
   % figure
   % imshow(Cimg);
    %imwrite(Cimg,str1,'bmp');
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
    pimg=zeros(size(bw1));
    for i=rc(1,1):rc(end,1) 
          Lineim=zeros(size(bw1));
          aa=dirlist{ix(i,1)};
          [dd,ds]=size(aa);
          [PL,pnum,paralist,paraimg]=pca_ParallelLine(aa,dirlist,labelim,codeimg,Model,win);  
             for i=1:pnum
                 ppnum=ppnum+1;
                 pplist{ppnum}=paralist{i};
             end
    end
    pximg=zeros(M+2*Msize,N+2*Msize);
    pyimg=zeros(M+2*Msize,N+2*Msize);
    pylist={};
    pxlist={};
    pzlist={};
    pxnum=0;
    pynum=0;
    pznum=0;
    pzimg=zeros(M+2*Msize,N+2*Msize);
   for i=1:ppnum
        aa=pplist{i};
        [deg,vv,rr]=caleig(aa,100.1,100.35);
        if  rr(1,1) < 0.55 %近似直线 直接分类
            if deg-75<10 || deg-75>170
               pximg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;
               pxnum=pxnum+1;
               pxlist{pxnum}=aa;
            elseif deg-75>80&& deg-75<100
               pzimg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;
               pznum=pznum+1;
               pzlist{pznum}=aa;
            elseif rr(1,1)<0.85
               pyimg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;
                  pynum=pynum+1;
                  pylist{pynum}=aa;
            end

        end
  end
%    figure;%【得到竖直方向的平行线】
%    imshow(pzimg); 
   %imwrite(pzimg,'shuzhi.jpg')
    %李勇 %%%%%%%%%%%%%%%%%求包络
    xc=length(pzimg(1,:));  %图像的长度
    yc=length(pzimg(:,1));  %图像的宽度
%     win1=20;                %选取窗口大小
    j=fix(xc/win1)-1;       %图像被选取窗口分割的个数
    m=1;                    
    m1=m+win1;             
    maxxy=zeros(j,2);      %最大的X、Y的坐标
    minxy=zeros(j,2);
    mnnum=0; 
    for nn=1:j
        f=pzimg(:,m:m1);   %m到m1之间的图像
  %     imshow(f);
        [ix,jx]=find(f>0);
        tf=isempty(ix);   %是否有线段，有线段则为0.
        if tf==1
            nn=nn+1;
        else
           [aax,I1]=max(ix);  %aax表示每列的最大值，I1表示最大值的下标
           [bbx,I2]=min(ix);
           jx1=jx(I1)+m;      %ix所对应最大值的横坐标，求取最大值的纵坐标
           jx2=jx(I2)+m;
           mnnum=mnnum+1;
           maxxy(mnnum,1)=aax;%横坐标
           maxxy(mnnum,2)=jx1;
           minxy(mnnum,1)=bbx;
           minxy(mnnum,2)=jx2;
        end
        m=m+win1;m1=m1+win1;  
    end
%     hold on;
%     plot(maxxy(1:mnnum,2),maxxy(1:mnnum,1),'b',minxy(1:mnnum,2),minxy(1:mnnum,1),'g')
%     hold on;
%     plot([minxy(1,2),1,maxxy(1,2)],[minxy(1,1),maxxy(1,1),maxxy(1,1)],'y',[minxy(mnnum,2),xc,maxxy(mnnum,2)],[minxy(mnnum,1),maxxy(mnnum,1),maxxy(mnnum,1)],'r')
%剩余道路部分
    fx1=cat(1,1,maxxy(1:mnnum,2),xc,xc,1);
    fy1=cat(1,maxxy(1,1),maxxy(1:mnnum,1),maxxy(mnnum,1),yc,yc);

     py=roipoly(pyimg,fx1,fy1);%roifill
    % figure
    % imshow(py); 
     pim=py.*pyimg;
%      figure
%      imshow(pim);     
%      %提取pim中的线条
     pnimg=zeros(M+2*Msize,N+2*Msize);
     lens=length(pylist);
     yylen=0;%丁老师加
     yylist={};
     for ii=1:lens
         aa=pylist{ii};
         x1=aa(1,2);
         y1=aa(1,1);
         x2=aa(end,2);
         y2=aa(end,1);
         [deg,vv,rr]=caleig(aa,100.1,100.35);
         if pim(y1,x1)>0|| pim(y2,x2)>0%第ii段线段的顶点和尾点都大于1
             if (deg-75>5)&&(deg-75<175)&&rr(1,1)<0.8
             yylen=yylen+1; %丁老师加
             yylist{yylen}=pylist{ii}; %丁老师改
             pnimg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;%丁老师改
             end
         end
     end
  % figure
  % imshow(pnimg); 
  % imwrite(double(pnimg),'112.jpg');
  ly=0;
  lz=0;
  lx=0;
  lylen={};
  lzlen={};
  lyimg=zeros(M+2*Msize,N+2*Msize);
  lzimg=zeros(M+2*Msize,N+2*Msize);
  for i=1:yylen
         aa=yylist{i};
         lg=length(aa);
     if lg>10   
         [deg,vv,rr]=caleig(aa,100.1,100.35);
        if  deg-75<90
             ly=ly+1;
             lylen{ly}=yylist{i};
             lyimg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;
        else 
            lz=lz+1;
            lzlen{lz}=yylist{i};
            lzimg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;
        end
      end
  end
%   figure
%   imshow(lyimg);
%   figure
%   imshow(lzimg); 
  num1 = length(lylen);
  num2 = length(lzlen);
 crossnum = 1;
for i=1:num1
  for j=1:num2
    aa = lylen{i};
    x = aa(:,1);
    y = aa(:,2);
    bb = lzlen{j};
    xx = bb(:,1);
    yy = bb(:,2);
%     plot(x,y,'m');
%     hold on
%     plot(xx,yy,'m');
%     hold on
    p1 = polyfit(x,y,1);  %一次拟合 输出为多项式系数向量
    p2 = polyfit(xx,yy,1);
    P1=atan(p1(1))/pi*180;
    P2=atan(p2(1))/pi*180;
    if abs(P1+P2)<60
    x1 = 1:M;
    xx1 = 1:M;
    y1 = polyval(p1,x1);
    yy1 = polyval(p2,xx1);
    y2 = y1';
    yy2 = yy1';
    err = abs(y2-yy2);
    xcord = find(err==min(err));  %求交点 (在图像数组中的第xcord的位置)
    if (xcord<N)&&(xcord>1)
    crosspoint(crossnum,1) = xcord;
    crosspoint(crossnum,2) = fix((y2(xcord,1)+yy2(xcord,1))/2);
    cline(crossnum,1) = i;
    cline(crossnum,2) = j;
    crossnum = crossnum+1;
%     plot(x1',y1,'g');
%     hold on
%     plot(xx1',yy1,'g');
%     hold on
    end
    end
  end
end
    k=length(crosspoint);
    X = crosspoint;
%     plot(X(:,1),X(:,2),'*','color','b');
%     hold on 
 if k<3
    crossline = cline;
    vanishingpoint = X;
%     figure
%     imshow(bw1);
%     hold on
%     plot(vanishingpoint(:,2),vanishingpoint(:,1),'+','color','r');
 elseif k<10
    [C,U,obj_fcn] = fcm(X, 2);  %方法一C-means 模糊C均值聚类
     maxU = max(U);
     index1 = find(U(1,:) == maxU);
     index2 = find(U(2, :) == maxU);
%    [IDX,C1] = kmeans(X,3);   %方法二
%    plot(X(:,1),X(:,2),'*','color','b');
%    hold on 
%      plot(C(:,1),C(:,2),'rs','color','r');
%      hold on 
%    plot(C1(:,1),C1(:,2),'o','color','r');
     if length(index1)>length(index2)
        Cs = 1;
        crossline = cline(index1(1,:)',:);
     else
        Cs = 2;
        crossline = cline(index2(1,:)',:);
     end
     if (length(index1)-length(index2))<5
        XX=min(C(:,2));
        YY=min(C(:,1));
%         figure
%         imshow(bw1);
%         hold on
%         plot(XX,YY,'*','color','r'); 
     else
     vanishingpoint = C(Cs,:);
%      figure
%      imshow(bw1);
%      hold on
%      plot(vanishingpoint(:,2),vanishingpoint(:,1),'+','color','r');  
    end
else
   r=10;
  for i=1:k
    js=0;
    for j=1:k
       if sqrt((X(j,1)-X(i,1))^2+(X(j,2)-X(i,2))^2)< r
          js=js+1;
       end
    end
    sdd(i,1)=js;
  end
 if js<5
    r=50;
  for i=1:k
    js=0;
    for j=1:k
       if sqrt((X(j,1)-X(i,1))^2+(X(j,2)-X(i,2))^2)< r
          js=js+1;
       end
    end
    sdd(i,1)=js;
  end
 end
  sd=max(sdd);
  di=find(sdd==sd); %比较角点之间的距离，找出交点距离其他点距离和最小的点，认为该点为消失点
    %crossline = cline;
   gs=length(di);
   % xd=median(X(di,2));
   % yd=median(X(di,1));
    xd=sum(X(di,2))/gs-20;
    yd=sum(X(di,1))/gs-20;
%     figure
%     imshow(im);
%     hold on
%     plot(xd,yd,'o','color','r');
 end
%  toc


    
    




    