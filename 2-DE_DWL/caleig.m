%���룺aa ������Ե�ռ�����
%�����
% deg--ֱ�߽Ƕ�
% vv -- ��������
% rr -- ����ֵ
function  [deg,vv,rr]=caleig(aa,Thr1,Thr2)
deg=0;
CC=75; %�����������˴�ȡ75��180+75=255
Thr=0;
len=length(aa);
if len<9
    Thr=Thr1;
else
    Thr=Thr2;
end
rr=zeros(2,1);
xm=mean(aa(:,1));
ym=mean(aa(:,2)); 
s11=mean((aa(:,1)-xm).*(aa(:,1)-xm));
s12=mean((aa(:,1)-xm).*(aa(:,2)-ym));
s22=mean((aa(:,2)-ym).*(aa(:,2)-ym));
A=[s11,s12;s12,s22];
[vv,uu]=eig(A);        %%�������������ֵ����������
rr(1,1)=uu(1,1);
rr(2,1)=uu(2,2);
if min(rr)<Thr
    if abs(s12)>0.0001 %
        deg=fix(atan((max(rr)-s11)/s12)*180/pi+90);
    else
        if (aa(:,1)-xm)==0
           deg=0;
        else
           deg=90; 
        end  
    end
    if deg == 0
       deg=180;
    end
    deg=deg+CC;
else
   deg=0;
end

