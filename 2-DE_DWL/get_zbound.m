%得到区域分割结果 nroad--道路区域标号  Rpim--道路平行线图像
function [fx1,fy1,fx,fy,nroad,Rpim,Rtlist]=get_zbound(pzimg,pyimg,nbw,tlist)
xc=length(pzimg(1,:));  
yc=length(pzimg(:,1));
vv=1;
win1=20;
j=fix(xc/win1)-1;
m=1;
m1=m+win1;
maxxy=zeros(j,2);
minxy=zeros(j,2);
mnnum=0;
for nn=1:j
    f=pzimg(:,m:m1);
  %     imshow(f);
   [ix,jx]=find(f>0);
   tf=isempty(ix);
   if tf==1
      nn=nn+1;
   else
     [aax,I1]=max(ix);
     [bbx,I2]=min(ix);
     jx1=jx(I1)+m;
     jx2=jx(I2)+m;
     mnnum=mnnum+1;
     maxxy(mnnum,1)=aax;
     maxxy(mnnum,2)=jx1;
     minxy(mnnum,1)=bbx;
     minxy(mnnum,2)=jx2;
   end
   m=m+win1;m1=m1+win1;  
end
%    hold on; 
%    plot(maxxy(1:mnnum,2),maxxy(1:mnnum,1),'b',minxy(1:mnnum,2),minxy(1:mnnum,1),'g')
%    hold on;
%    plot([minxy(1,2),1,maxxy(1,2)],[minxy(1,1),maxxy(1,1),maxxy(1,1)],'y',[minxy(mnnum,2),xc,maxxy(mnnum,2)],[minxy(mnnum,1),maxxy(mnnum,1),maxxy(mnnum,1)],'r')
%    hold off;
 %    hold on;
 %    plot([minxy(1,2),1,maxxy(1,2)],[minxy(1,1),maxxy(1,1),maxxy(1,1)],'y',[minxy(mnnum,2),xc,maxxy(mnnum,2)],[minxy(mnnum,1),maxxy(mnnum,1),maxxy(mnnum,1)],'r')
% 

fx1=[1;1;maxxy(1:mnnum,2);xc;xc];
fy1=[yc;maxxy(1,1);maxxy(1:mnnum,1);maxxy(mnnum,1);yc];%

hold on
plot(fx1,fy1,'g');

fx=[1;1;minxy(1:mnnum,2);xc;xc];
fy=[1;minxy(1,1);minxy(1:mnnum,1);minxy(mnnum,1);1];%


hold on
plot(fx,fy,'r');

%填充道路区域
py=roipoly(pyimg,fx1,fy1);
figure
imshow(py);
Rpim=double(py).*pyimg;
yBW=double(py).*nbw;
my=max(max(yBW));
ny=min(min(yBW));
xxh=[];
for i=ny:my   
    hx=(yBW==i);
    x=find(hx>0);
    len=length(x);
    xxh=[xxh len];  
end
xxh(1,1)=0;
[mmy,iy]=max(xxh');
nroad=iy-1;

figure
imshow(Rpim);
Rim=double(nbw==nroad);
Roadpim=Rpim.*Rim; %道路区域包含的平行线
figure
imshow(Roadpim);
figure
imshow(Rim);
Rtlist={};
Rtnum=0;
for i=1:length(tlist)
    aa=tlist{i};
    tx=aa(1,2);
    ty=aa(1,1);
    if Roadpim(ty,tx)>0
        Rtnum=Rtnum+1;
        Rtlist{Rtnum}=aa;
    end
end