

% �������㰴ԭ�����ӳ�,����ཻ��ֹͣ���������������Գ����ӳ��������²����¶˵�
% (x,y)���������������ꣻ
% Bw�������ؼ��ͼ��
% (X,Y)���������˵���ԭͼ���е����ꣻ
% Elist����ԭͼ���ж˵�(X,Y)���ڵ��������������б�
function [nbw,flag,nX,nY,nElist]= Extend(x,y,X,Y,Bw,Msize,Elist)
% nbw�������γɵı��ؼ��ͼ��
% flag�����˵�����ӳ����γ��ཻ��ı�־��
% (nX,nY)�����¸��¶˵���ԭͼ���е����ꣻ
% nElist�����˵��ӳ�ͬʱ�������������б�
flag = 0;
nbw = Bw;
currBw = Bw(X-Msize:X+Msize,Y-Msize:Y+Msize);      % ȡ���˵㸽���ֲ�����--���ؼ��--ͼ��
newBw = currBw;
[p,q] = size(Elist);
[m,n] = size(currBw);

x1 = Elist(1,1);
y1 = Elist(1,2);
%x2 = Elist(p,1);
%y2 = Elist(p,2);
if x1==X && y1==Y
    from = 2;  % from = 2���ܽ��Elistֻ��һ��Ԫ�ص����
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
            flag = 1;    % �˵�����ӳ����γ��ཻ��ı�־
            nX = xn-x+X;
            nY = yn-y+Y;
            nElist = Elist;
            nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = newBw;
            break;
        end
        flag = 0;  %�����ӳ��ı�־
        newBw(xn,yn) = 1; 
        nX = xn-x+X;
        nY = yn-y+Y; 
        nElist(j,1) = nX;
        nElist(j,2) = nY;
        nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = newBw;
        
        if  xn-1>0 && xn+1<=m && yn-1>0 && yn+1<=n
            Pd = newBw(xn-1:xn+1,yn-1:yn+1);
            fl = sum(sum(Pd));    
            if fl>=3       % ������ֹ����:�õ�8������������3��ֵ���ཻ 
                flag = 1;     % �˵�����ӳ����γ��ཻ��ı�־
                nX = xn-x+X;
                nY = yn-y+Y;
                nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = newBw;
                break;
            end
        end
    else
        flag = 0;    %�����ӳ��ı�־
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


   