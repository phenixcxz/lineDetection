%输入：aa 连续边缘空间坐标
%输出：
% deg--直线角度
% vv -- 特征向量
% rr -- 特征值
function  [deg,vv,rr]=caleig(aa,Thr1,Thr2)
deg=0;
CC=75; %常数余量，此处取75，180+75=255
Thr=0;
len=length(aa);
rr=zeros(2,1);
xm=mean(aa(:,1));
ym=mean(aa(:,2));
s11=mean((aa(:,1)-xm).*(aa(:,1)-xm));
s12=mean((aa(:,1)-xm).*(aa(:,2)-ym));
s22=mean((aa(:,2)-ym).*(aa(:,2)-ym));
A=[s11,s12;s12,s22];
[vv,uu]=eig(A);        %%求出的两个特征值及特征向量
rr(1,1)=uu(1,1);
rr(2,1)=uu(2,2);
if len<9
    Thr=Thr1;
else
    Thr=Thr2;
end
if min(rr)<Thr
    if vv(1,2)==0
        deg=0; 
    elseif vv(1,1)==0
        deg=90;
    else
        deg=fix(atan(vv(1,2)/vv(1,1))*180/pi);
        if deg<0
            deg=deg+180;
        end
    end
    if deg == 0
       deg=180;
    end
    deg=deg+CC;
else
   deg=0;
end

