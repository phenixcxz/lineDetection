
function [result] = fitLine(Llist,grads,M,N,Msize,flag)
Lnum = length(Llist);
slope=zeros(Lnum,5);       %斜率计算
for m=1:Lnum
    aa=Llist{m};  %待处理线段
    x = length(aa);
    p = polyfit(aa(round(x*2/10):round(x*8/10),1),aa(round(x*2/10):round(x*8/10),2),1);     %线段斜率与起始点
    slope(m,1) = atan(p(1));
    if slope(m,1) < 0
        slope(m,1) = pi+slope(m,1);
    end
    slope(m,2) = round(p(2));       %起始点
    slope(m,5) = round(p(1)*(M/2+Msize)+p(2));      %中点
    slope(m,3) = x;                 %连续点个数
end

%% 线信息统计
devote = zeros(Lnum,6);
for n = 1:Lnum
    devote(n,1) = slope(n,5);   %中点
    devote(n,2) = slope(n,1);   %斜率
    devote(n,3) = slope(n,3);   %斜率票数
    devote(n,4) = grads(n,1);  %左边缘票数
    devote(n,5) = grads(n,2);  %右边缘票数
    devote(n,6) = round((grads(n,4)*1+grads(n,5)*2+grads(n,6)*3+grads(n,7)*4)/(grads(n,1)+grads(n,2)));
end
for m=1:Lnum
    slope(m,4) = grads(m,3);
end

%% 根据线宽确定区间
devoteFun = zeros(Lnum,5);
for m = 1:Lnum
    x = devote(m,6);
    if devote(m,4) > devote(m,5)
        devoteFun(m,1) = devote(m,1)+1;      %左区间
        devoteFun(m,2) = devoteFun(m,1)+x;
        devoteFun(m,3) = devote(m,3);
        devoteFun(m,4) = devote(m,2);
    else
        devoteFun(m,1) = devote(m,1)-x-1;    %右区间
        devoteFun(m,2) = devoteFun(m,1)+x;  
        devoteFun(m,3) = devote(m,3);
        devoteFun(m,4) = devote(m,2);
    end
end

%% 区间排序
[~,pos] = sort(devoteFun(:,1));
devoteFun(:,:) = devoteFun(pos,:);

%% 和并重复区间
numx = 1;
m = 1;
while(m<=Lnum)
    devoteFun(m,5) = numx;
    for n = m+1:Lnum
        if devoteFun(n,1)> devoteFun(m,2) && devoteFun(n,1)> devoteFun(n-1,2)
            m = n-1;
            break;
        else
           devoteFun(n,5) = numx; 
           if n ==Lnum
               m = Lnum;
           end
        end
    end
    numx = numx+1;
    m = m+1;
end
xy = max(devoteFun(:,5));
result = zeros(xy,4);
for m = 1:xy
    l = find(devoteFun(:,5) ==m );
    [~,maxDot] = max(devoteFun(l,3));
    result(m,1) = devoteFun(l(maxDot),1);
    result(m,2) = devoteFun(l(maxDot),2);
    result(m,4) = devoteFun(l(maxDot),4); 
    result(m,3) = sum(devoteFun(l,3));    
end
%% 去除不符合要求线
result(all(result(:,3)<300,2),:)=[];