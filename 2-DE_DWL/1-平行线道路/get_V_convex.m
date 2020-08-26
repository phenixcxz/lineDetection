function [up,down,RoadRegion]=get_V_convex(Vimg)
    %李勇 %%%%%%%%%%%%%%%%%求包络
    [M,N]=size(Vimg);
    fa=[1,((N+1)/2),N];
    fb=[M,(3/5*M),M];
    fa=uint16(fix(fa));
    fb=uint16(fix(fb));
 %   figure
  %  imshow(Vimg); 
  %  hold on;
 %   plot(fa,fb,'g'); %显示定义的透视三角形
    fimage=roipoly(Vimg,fa,fb);

    vimage= (1-fimage).*Vimg;
    xc=N;  %图像的长度
    yc=M;  %图像的宽度
    win1=10;                %选取窗口大小
    j=fix(xc/win1)-1;       %图像被选取窗口分割的个数
    m=1;                    
    m1=m+win1;             
    maxxy=zeros(j,2);      %最大的X、Y的坐标
    minxy=zeros(j,2);
    mnnum=0; 
    for nn=1:j
        f=vimage(:,m:m1);   %m到m1之间的图像
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
    down=[maxxy(1:mnnum,2);maxxy(1:mnnum,1)];
    up=[minxy(1:mnnum,2);minxy(1:mnnum,1)];
  %  hold on;
  %  plot(maxxy(1:mnnum,2),maxxy(1:mnnum,1),'b',minxy(1:mnnum,2),minxy(1:mnnum,1),'g')
 %   hold on;
 %   plot([minxy(1,2),1,1,maxxy(1,2)],[minxy(1,1),minxy(1,1),maxxy(1,1),maxxy(1,1)],'y',[minxy(mnnum,2),N,N,maxxy(mnnum,2)],[minxy(mnnum,1),minxy(mnnum,1),maxxy(mnnum,1),maxxy(mnnum,1)],'y')
   %剩余道路部分
    fx1=cat(1,1,maxxy(1:mnnum,2),xc,xc,1);
    fy1=cat(1,maxxy(1,1),maxxy(1:mnnum,1),maxxy(mnnum,1),yc,yc);
    RoadRegion=double(roipoly(Vimg,fx1,fy1));%roipoly选择感兴趣区域  roifill填充选中区域。

