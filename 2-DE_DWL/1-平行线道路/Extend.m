

% 将待检测点按原方向延长,如果相交则停止——————可以彻底延长，仍有新产生新端点
% (x,y)——窗口中心坐标；
% Bw——边沿检测图像；
% (X,Y)——待检测端点在原图像中的坐标；
% Elist——原图像中端点(X,Y)所在的连续线条坐标列表；
function [nbw,flag,nX,nY,nElist]= Extend(x,y,X,Y,Bw,Msize,Elist)
% nbw——新形成的边沿检测图像；
% flag——端点进行延长并形成相交点的标志；
% (nX,nY)——新更新端点在原图像中的坐标；
% nElist——端点延长同时更新线条坐标列表；
flag = 0;
nbw = Bw;
currBw = Bw(X-Msize:X+Msize,Y-Msize:Y+Msize);      % 取出端点附近局部区域--边沿检测--图像
newBw = currBw;
[p,q] = size(Elist);
[m,n] = size(currBw);

x1 = Elist(1,1);
y1 = Elist(1,2);
%x2 = Elist(p,1);
%y2 = Elist(p,2);
if x1==X && y1==Y
    from = 2;  % from = 2不能解决Elist只有一组元素的情况
    step = 1;
    to = p;
else
    from =p-1;
    step = -1;
    to = 1;
end
if p>1
    j = 1;
    nElist(j,1) = X;
    nElist(j,2) = Y;
    for i=from:step:to
    Xe = Elist(i,1);
    Ye = Elist(i,2);
    
    detax = X-Xe;
    detay = Y-Ye;
    
    xn = x+detax;
    yn = y+detay;
    j = j+1;
    if  xn>0 && xn<=m && yn>0 && yn<=n
        if newBw(xn,yn)==1    
            flag = 1;    % 端点进行延长并形成相交点的标志
            nX = xn-x+X;
            nY = yn-y+Y;
            nElist = Elist;
            nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = newBw;
            break;
        end
        flag = 0;  %继续延长的标志
        newBw(xn,yn) = 1; 
        nX = xn-x+X;
        nY = yn-y+Y; 
        nElist(j,1) = nX;
        nElist(j,2) = nY;
        nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = newBw;
        
        if  xn-1>0 && xn+1<=m && yn-1>0 && yn+1<=n
            Pd = newBw(xn-1:xn+1,yn-1:yn+1);
            fl = sum(sum(Pd));    
            if fl>=3       % 设置终止条件:该点8邻域内有至少3个值即相交 
                flag = 1;     % 端点进行延长并形成相交点的标志
                nX = xn-x+X;
                nY = yn-y+Y;
                nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = newBw;
                break;
            end
        end
    else
        flag = 0;    %继续延长的标志
        %nX = X;
        %nY = Y;
        % break;
    end
    end
else
    flag = 1;
    nX = X;
    nY = Y;
    nElist = Elist;
    nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = newBw;

end


   