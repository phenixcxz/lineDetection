%判断两段线条的方向是否具有一致性 bb是比aa长的线条
function   flag=is_Dirconsistent(aa,bb,dira,dirb,dis,type)
[deg1,vv1,rr1]=caleig(aa,0.1,0.45);
[deg2,vv2,rr2]=caleig(bb,0.1,0.45);
if deg1>0 && deg2>0 %如果是直线
    if abs(deg1-deg2)<15 || abs(deg1-deg2)>165
        flag=1;
        return;
    end
end
lena=length(dira);
lenb=length(dirb);
for j=1:lenb-lena
    ttb=dirb(j:j+lena-1);
    dirc=abs(ttb-dira);%方向一致
    kc1=length(find(dirc<=15));
    kc2=length(find(dirc>165));
    kc=kc1+kc2;
    if kc>10
       flag=1;
       return;
    end   
end
%判断起点
if type==1
   x=aa(1,1);
   y=aa(1,2); 
else
   x=aa(end,1);
   y=aa(end,2);
end
flag=0;
l=length(aa);
disbb=abs(sqrt((bb(:,1)-x).*(bb(:,1)-x)+(bb(:,2)-y).*(bb(:,2)-y))-dis);
r=find(disbb<0.001); %获得bb中与aa对应的点的位置
if length(r)>0
   l1=length(bb(1:r(1,1),:));
   l2=length(bb(r(1,1):end,:));
   if l1>=5
       if l1<l
          t1=bb(1:r(1,1),:);
          d1=dirb(1:r(1,1),:);
          if type==1
             t2=aa(1:l1);
             d2=dira(1:l1);
          else
             t2=aa(end-l1+1:end);
             d2=dira(end-l1+1:end);
          end
       else
          t1=bb(r(1,1)-l+1:r(1,1),:); 
          d1=dirb(r(1,1)-l+1:r(1,1),:); 
          t2=aa;
          d2=dira;
       end
       %判断一致性
       dirc=abs(d1-d2);%方向一致
       kc1=length(find(dirc<=15));
       kc2=length(find(dirc>165));
       kc=kc1+kc2;
       if kc>10|| kc/length(t1)>0.8
          flag=1;
          return;
       end
   end
   if l2>=5 && flag<1
       if l2<l
          t1=bb(r(1,1):end,:);
          d1=dirb(r(1,1):end,:);
          if type==1
              t2=aa(1:l2);
              d2=dira(1:l2);
          else
              t2=aa(end-l2+1:end);
              d2=dira(end-l2+1:end);
          end
       else
           t1=bb(r(1,1):r(1,1)+l-1,:); 
           d1=dirb(r(1,1):r(1,1)+l-1,:); 
           t2=aa;
           d2=dira;
       end
       %判断一致性
       dirc=abs(d1-d2); %方向一致 %也可用PCA判断方向一致
       kc1=length(find(dirc<=15));
       kc2=length(find(dirc>165));
       kc=kc1+kc2;
       if kc>10 || kc/length(t1)>0.8
          flag=1;
       end
   end
else
    flag=0;
end

