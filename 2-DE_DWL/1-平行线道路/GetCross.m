function [node,flag] = GetCross(aa,bb)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    x = aa(:,1);
    y = aa(:,2);
    xx = bb(:,1);
    yy = bb(:,2);
    if y(1,1)==mean(y) && y(end,1)==mean(y)
       a1=1;
       b1=0;
       c1= -y(1,1);
       k1=90;
    else
       a1= y(end,1)- y(1,1);
       b1= x(1,1)- x(end,1);
       c1=-x(1,1)*a1-y(1,1)*b1;   
       k1=atan(-a1/b1)/pi*180;
    end
    if yy(1,1)==mean(yy) && yy(end,1)==mean(yy)
       a2=1;
       b2=0;
       c2 = -yy(1,1);
       k2=90;
    else
       a2= yy(end,1)- yy(1,1);
       b2= xx(1,1)- xx(end,1);
       c2=-xx(1,1)*a1-yy(1,1)*b1;   
       k2=atan(-a2/b2)/pi*180;
    end
    if abs(k1-k2)<1 && abs(b1-b2)<1
         flag=0;
    elseif abs(k1-k2)<1 && b1~=b2
       flag=0;
    else
       cx=(b2*c1-b1*c2)/(a2*b1-a1*b2);
       cy=(-a1*cx-c1)/b1;
       node=[cx cy];
       flag=1;
    end
end

