

% ������������������
function Ran = LineLink_1(x,y,xe,ye,currBw)
% currBw �������ؼ��ͼ�񴰿ڣ�
% (x,y)���������������ꣻ
% (xe,ye)���������ڴ����Ӷ˵����ꣻ
Ran = currBw;
k = (y-ye)/(x-xe);
deg = atan(k)*180/pi;

%%%%%���Ӷ˵�
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

% x������
if deg==0 && x<xe   
    xn = x;
    yn = y;
    while xn<xe
        xn = xn+1;
        Ran(xn,yn) = 1;
    end
end

% x�Ḻ��
 if deg==0 && x>xe 
        xn = x;
        yn = y;
        while xn>xe
            xn = xn-1;
            Ran(xn,yn) = 1;
        end
 end
 
% y������
if deg==-90   
    xn = x;
    yn = y;
    while yn<ye
        yn = yn+1;
        Ran(xn,yn) = 1;
    end
end

% y�Ḻ��
if deg==90   
    xn = x;
    yn = y;
    while yn>ye
        yn = yn-1;
        Ran(xn,yn)=1;
    end
end


