

function  [dir,dirc]=get_curvecoding(aa,dd,thr,win)
dir=zeros(dd,1);
dirc=zeros(dd,1);
%此为判断起始点
if dd <2*win+1
   return
end
cp=win+1;
s=1;     
%判断中间点  
bb=zeros(2*win+1,2);
while(s<=dd)
    if s<win+1 %封闭曲线
       bb(1:s,:)=fliplr(aa(1:s,:));
       bb((s+1):min((2*win+1),dd),:)=aa((dd-2*win+s):dd,:); 
    elseif s>dd-win %封闭曲线
       bb(1:dd-s+1,:)=aa(s:dd,:);
       bb((dd-s+2):(2*win+1),:)=aa(1:(2*win-dd+s),:);  
    elseif s>win && s<=dd-win
       bb=aa(s-win:s+win,:);
    end
    [deg,vv,rr]=caleig(bb,1000,1000);
    dir(s)=deg;
    if min(rr)<thr
        dirc(s)=deg;
        s=s+1;
    else
        dirc(s)=0;
        s=s+1;        
    end
end

















    
    
