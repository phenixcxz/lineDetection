

% 完成两个孤立点的连接
function Ran = LineLink_1(x,y,xe,ye,currBw)
% currBw ——边沿检测图像窗口；
% (x,y)——窗口中心坐标；
% (xe,ye)——窗口内待连接端点坐标；
Ran = currBw;
k = (y-ye)/(x-xe);
deg = atan(k)*180/pi;

%%%%%连接端点
% 1
if deg>0 && x>xe &&y>ye
    xn = x;
    yn = y;
    while xn>xe && yn>ye
        xn = xn-1;
        yn = yn-1;
        Ran(xn,yn) = 1;
    end
    if xn==xe && yn>ye
        deg = 90;
        x = xn;
        y = yn;
    end
    if xn>xe && yn==ye
        deg = 0;
        x = xn;
        y = yn;
    end
end

% 3
if deg>0 && x<xe &&y<ye
    xn = x;
    yn = y;
    while xn<xe && yn<ye
        xn = xn+1;
        yn = yn+1;
        Ran(xn,yn) = 1;
    end
    if xn==xe && yn<ye
        deg = -90;
        x = xn;
        y = yn;
    end
    if xn<xe && yn==ye
        deg = 0;
        x = xn;
        y = yn;
    end
end

% 2
if deg<0 && x<xe && y>ye
    xn = x;
    yn = y;
    while xn<xe && yn>ye
        xn = xn+1;
        yn = yn-1;
        Ran(xn,yn) = 1;
    end
    if xn==xe && yn>ye
        deg = 90;
        x = xn;
        y = yn;
    end
    if xn<xe && yn==ye
        deg = 0;
        x = xn;
        y = yn;
    end
end

% 4
if deg<0 && x>xe &&y<ye
    xn = x;
    yn = y;
    while xn>xe && yn<ye
        xn = xn-1;
        yn = yn+1;
        Ran(xn,yn) = 1;
    end
    if xn==xe && yn<ye
        deg = -90;
        x = xn;
        y = yn;
    end
    if xn>xe && yn==ye
        deg = 0;
        x = xn;
        y = yn;
    end
end

% x轴正向
if deg==0 && x<xe   
    xn = x;
    yn = y;
    while xn<xe
        xn = xn+1;
        Ran(xn,yn) = 1;
    end
end

% x轴负向
 if deg==0 && x>xe 
        xn = x;
        yn = y;
        while xn>xe
            xn = xn-1;
            Ran(xn,yn) = 1;
        end
 end
 
% y轴正向
if deg==-90   
    xn = x;
    yn = y;
    while yn<ye
        yn = yn+1;
        Ran(xn,yn) = 1;
    end
end

% y轴负向
if deg==90   
    xn = x;
    yn = y;
    while yn>ye
        yn = yn-1;
        Ran(xn,yn)=1;
    end
end


