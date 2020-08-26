%与窗口内所有端点连接，选择连接梯度最大的一条作为最优路径
% 如果不存在孤立端点则按原角度延长
% (X,Y)——待检测端点原图像中的坐标；
% Dd——孤立端点图像；
% Bw——边沿检测图像；
% Msize——设置的窗口半径；
% Elist——端点(X,Y)所在连续线条坐标列表；
function [nbw,newDd]=BaseOptRouGrowth(X,Y,Dd,Bw,Gr,Msize,Elist)
% nbw——连接或延长后新的边沿检测图像；
% newDd——连接或延长后新的端点检测图像；

nbw = Bw;
[M,N] = size(Bw);
currDd = Dd(X-Msize:X+Msize,Y-Msize:Y+Msize);   % 取出端点附近局部区域--端点--图像
currBw = Bw(X-Msize:X+Msize,Y-Msize:Y+Msize);      % 取出端点附近局部区域--边沿检测--图像
currGr = Gr(X-Msize:X+Msize,Y-Msize:Y+Msize);     % 取出端点附近局部区域--灰度--图像
% newBw = currBw;
newDd = currDd;
x = Msize+1;
y = Msize+1;  %  窗口中心坐标，待连接端点
[row,col] = find(currDd);   % 找到孤立端点
[p,q] = size(row);          % 孤立端点个数
[m,n] = size(currDd);       
G_Value = zeros(m,n);    % 存放与各孤立端点连接线条的梯度值
if p>1    % 确定有端点才连接
    for i=1:p
         xi = row(i,1);
         yi = col(i,1);
         Ran = LineLink(x,y,xi,yi,currBw);  %  孤立端点连接函数
         G_Value(xi,yi) = GetG_Value(Ran,currBw,currGr);
    end
    MaxG = max(max(G_Value));
    [xe,ye] = find(G_Value==MaxG);
    fRan = LineLink(x,y,xe(1,1),ye(1,1),currBw);
    nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = fRan;   % newBw;
    newDd(x,y) = 0;     % 消除原来的孤立端点
    newDd(xe,ye) = 0;
end

if p==1   % 无孤立端点则按原角度延长
    fl = 0;   %终止延长的标志
    while fl==0 && X-Msize>0 && Y-Msize>0 && X+Msize<=M && Y+Msize<=N
        [nbw,flag,nX,nY,nElist] = Extend(x,y,X,Y,Bw,Msize,Elist);  % 线条延长函数
        fl = flag;
        Bw = nbw;
        X = nX;
        Y = nY;
        Elist = nElist;
    end
    newDd(x,y) = 0;    % 消除原来的孤立端点
end