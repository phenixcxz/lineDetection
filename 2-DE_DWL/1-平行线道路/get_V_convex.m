function [up,down,RoadRegion]=get_V_convex(Vimg)
    %���� %%%%%%%%%%%%%%%%%�����
    [M,N]=size(Vimg);
    fa=[1,((N+1)/2),N];
    fb=[M,(3/5*M),M];
    fa=uint16(fix(fa));
    fb=uint16(fix(fb));
 %   figure
  %  imshow(Vimg); 
  %  hold on;
 %   plot(fa,fb,'g'); %��ʾ�����͸��������
    fimage=roipoly(Vimg,fa,fb);

    vimage= (1-fimage).*Vimg;
    xc=N;  %ͼ��ĳ���
    yc=M;  %ͼ��Ŀ��
    win1=10;                %ѡȡ���ڴ�С
    j=fix(xc/win1)-1;       %ͼ��ѡȡ���ڷָ�ĸ���
    m=1;                    
    m1=m+win1;             
    maxxy=zeros(j,2);      %����X��Y������
    minxy=zeros(j,2);
    mnnum=0; 
    for nn=1:j
        f=vimage(:,m:m1);   %m��m1֮���ͼ��
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
    down=[maxxy(1:mnnum,2);maxxy(1:mnnum,1)];
    up=[minxy(1:mnnum,2);minxy(1:mnnum,1)];
  %  hold on;
  %  plot(maxxy(1:mnnum,2),maxxy(1:mnnum,1),'b',minxy(1:mnnum,2),minxy(1:mnnum,1),'g')
 %   hold on;
 %   plot([minxy(1,2),1,1,maxxy(1,2)],[minxy(1,1),minxy(1,1),maxxy(1,1),maxxy(1,1)],'y',[minxy(mnnum,2),N,N,maxxy(mnnum,2)],[minxy(mnnum,1),minxy(mnnum,1),maxxy(mnnum,1),maxxy(mnnum,1)],'y')
   %ʣ���·����
    fx1=cat(1,1,maxxy(1:mnnum,2),xc,xc,1);
    fy1=cat(1,maxxy(1,1),maxxy(1:mnnum,1),maxxy(mnnum,1),yc,yc);
    RoadRegion=double(roipoly(Vimg,fx1,fy1));%roipolyѡ�����Ȥ����  roifill���ѡ������

