% 端点按原角度延长
% (X,Y)——待检测端点原图像中的坐标；
% Dd——孤立端点图像；
% Bw——边沿检测图像；
% Msize——设置的窗口半径；
% Elist——端点(X,Y)所在连续线条坐标列表；
function nBw= BaseDegGrowth(X,Y,Bw,Msize,Elist)
% nbw——只作延长后新的边沿检测图像；
% newDd——只作延长后新的端点检测图像；
nBw = Bw;
[M,N] = size(Bw);
x = Msize+1;
y = Msize+1;  %  窗口中心坐标

 % 按原角度延长
 fl = 0;   %终止延长的标志
 while fl==0 && X-Msize>0 && Y-Msize>0 && X+Msize<=M && Y+Msize<=N
     [nBw,flag,nX,nY,nElist] = Extend(x,y,X,Y,Bw,Msize,Elist);
     fl = flag;
     Bw = nBw;
     X = nX;
     Y = nY;
     Elist = nElist;                                                     
 end