% 获得曲线方向编码函数
% aa——曲线坐标；
% win——窗口半径；
function [flag,dir]=edgeangle(aa,win,Thr)
% flag——连续线条标记为1，角点处标记为0；
% dir——曲线方向编码；

[dd,ds]=size(aa);
dir=zeros(dd,1);
flag=zeros(dd,1);
if dd>2*win+1
   cp=win+1;
   for i=cp:dd-win
       bb=aa(i-win:i+win,:);
       b1=abs(bb(2:end,1)-bb(1:end-1,1));
       b2=abs(bb(2:end,2)-bb(1:end-1,2));
       b=b1+b2;
       dis=sum(double(b==1))+sum(double(b==2))*sqrt(2);
       disL=sqrt((bb(1,1)-bb(end,1))*(bb(1,1)-bb(end,1))+(bb(1,2)-bb(end,2))*(bb(1,2)-bb(end,2)));
       ss=disL/dis;
       flag(i,1)=ss;
       if  ss>Thr
           if abs(bb(end,2)-bb(1,2))>0.0001   %非水平状况
               dir(i,1)=fix(atan((bb(end,1)-bb(1,1))/(bb(end,2)-bb(1,2)))*180/pi+90);   %%加了括号
           else  %水平状况
               dir(i,1)=180;  %90->0
           end
           dir(i,1)=dir(i,1)+75;  %增加对比度
       else
           dir(i,1)=0;
       end
   end
   dir(1:win,1)=dir(cp);
   dir(dd-win+1:dd,1)=dir(dd-win);
   
else
    dir(:,1)=0;
    flag(:,1)=0;
end


