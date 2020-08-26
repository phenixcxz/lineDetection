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
 
    Cimg=codeimg(Msize+1:M+Msize,Msize+1:N+Msize);%����ͼ��
    Cimg=uint8(Cimg);
   % figure
   % imshow(Cimg);
    %imwrite(Cimg,str1,'bmp');
%��ƽ���߼�⡿
    %�Ա���ı�Ե���г�������
    len=length(dirlist);
    dirlen=zeros(len,0);
    for i=1:len
        dirx=dirlist{i};
        dirlen(i,1)=length(dirx);
    end
    [t,ix]=sort(dirlen); %�Ա���ı�Ե���г�������
    rc=find(t>=lineT); %ֻ���ǳ��ȴ���10�����ص����� lineT=10
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
        if  rr(1,1) < 0.55 %����ֱ�� ֱ�ӷ���
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
%    figure;%���õ���ֱ�����ƽ���ߡ�
%    imshow(pzimg); 
   %imwrite(pzimg,'shuzhi.jpg')
    %���� %%%%%%%%%%%%%%%%%�����
    xc=length(pzimg(1,:));  %ͼ��ĳ���
    yc=length(pzimg(:,1));  %ͼ��Ŀ��
%     win1=20;                %ѡȡ���ڴ�С
    j=fix(xc/win1)-1;       %ͼ��ѡȡ���ڷָ�ĸ���
    m=1;                    
    m1=m+win1;             
    maxxy=zeros(j,2);      %����X��Y������
    minxy=zeros(j,2);
    mnnum=0; 
    for nn=1:j
        f=pzimg(:,m:m1);   %m��m1֮���ͼ��
  %     imshow(f);
        [ix,jx]=find(f>0);
        tf=isempty(ix);   %�Ƿ����߶Σ����߶���Ϊ0.
        if tf==1
            nn=nn+1;
        else
           [aax,I1]=max(ix);  %aax��ʾÿ�е����ֵ��I1��ʾ���ֵ���±�
           [bbx,I2]=min(ix);
           jx1=jx(I1)+m;      %ix����Ӧ���ֵ�ĺ����꣬��ȡ���ֵ��������
           jx2=jx(I2)+m;
           mnnum=mnnum+1;
           maxxy(mnnum,1)=aax;%������
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
%ʣ���·����
    fx1=cat(1,1,maxxy(1:mnnum,2),xc,xc,1);
    fy1=cat(1,maxxy(1,1),maxxy(1:mnnum,1),maxxy(mnnum,1),yc,yc);

     py=roipoly(pyimg,fx1,fy1);%roifill
    % figure
    % imshow(py); 
     pim=py.*pyimg;
%      figure
%      imshow(pim);     
%      %��ȡpim�е�����
     pnimg=zeros(M+2*Msize,N+2*Msize);
     lens=length(pylist);
     yylen=0;%����ʦ��
     yylist={};
     for ii=1:lens
         aa=pylist{ii};
         x1=aa(1,2);
         y1=aa(1,1);
         x2=aa(end,2);
         y2=aa(end,1);
         [deg,vv,rr]=caleig(aa,100.1,100.35);
         if pim(y1,x1)>0|| pim(y2,x2)>0%��ii���߶εĶ����β�㶼����1
             if (deg-75>5)&&(deg-75<175)&&rr(1,1)<0.8
             yylen=yylen+1; %����ʦ��
             yylist{yylen}=pylist{ii}; %����ʦ��
             pnimg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;%����ʦ��
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
    p1 = polyfit(x,y,1);  %һ����� ���Ϊ����ʽϵ������
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
    xcord = find(err==min(err));  %�󽻵� (��ͼ�������еĵ�xcord��λ��)
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
    [C,U,obj_fcn] = fcm(X, 2);  %����һC-means ģ��C��ֵ����
     maxU = max(U);
     index1 = find(U(1,:) == maxU);
     index2 = find(U(2, :) == maxU);
%    [IDX,C1] = kmeans(X,3);   %������
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
  di=find(sdd==sd); %�ȽϽǵ�֮��ľ��룬�ҳ��������������������С�ĵ㣬��Ϊ�õ�Ϊ��ʧ��
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


    
    




    