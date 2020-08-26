function [ss,dir]=edgecoding(aa,win)
[dd,ds]=size(aa);
dir=zeros(dd,1);
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
       if  ss>0.8
           if abs(bb(end,1)-bb(1,1))>0.0001
               dir(i,1)=fix(atan(bb(end,2)-bb(1,2))/(bb(end,1)-bb(1,1))*180/pi+90);
           else
               dir(i,1)=90;
           end
           if dir(i,1)==0
              dir(i,1)=180;
           end
           dir(i,1)=dir(i,1)+75;
       else
           dir(i,1)=0;
       end
   end
   dir(1:win,1)=dir(cp);
   dir(dd-win+1:dd,1)=dir(dd-win);
else
    dir(:,1)=0;
end
ss=double(dir>0);

