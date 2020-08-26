function node = get_crosspoint(aa,bb)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x = aa(:,2);
y = aa(:,1);
xx = bb(:,2);
yy = bb(:,1);
len1=length(x);
len2=length(xx);
if len1<2 || len2<2
    node=[];
    return;
end
X1=[x(1) y(1)];
Y1=[x(end) y(end)];
X2=[xx(1) yy(1)];
Y2=[xx(end) yy(end)];
if X1(1)==Y1(1)
    X=X1(1);
    k2=(Y2(2)-X2(2))/(Y2(1)-X2(1));
    b2=X2(2)-k2*X2(1); 
    Y=k2*X+b2;
end
if X2(1)==Y2(1)
    X=X2(1);
    k1=(Y1(2)-X1(2))/(Y1(1)-X1(1));
    b1=X1(2)-k1*X1(1);
    Y=k1*X+b1;
end
if X1(1)~=Y1(1)&X2(1)~=Y2(1)
    k1=(Y1(2)-X1(2))/(Y1(1)-X1(1));
    k2=(Y2(2)-X2(2))/(Y2(1)-X2(1));
    b1=X1(2)-k1*X1(1);
    b2=X2(2)-k2*X2(1);
    if k1==k2
       X=[];
       Y=[];
    else
    X=(b2-b1)/(k1-k2);
    Y=k1*X+b1;
    end
end

node=[X,Y];
end

