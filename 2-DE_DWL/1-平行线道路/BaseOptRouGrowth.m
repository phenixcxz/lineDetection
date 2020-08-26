%�봰�������ж˵����ӣ�ѡ�������ݶ�����һ����Ϊ����·��
% ��������ڹ����˵���ԭ�Ƕ��ӳ�
% (X,Y)���������˵�ԭͼ���е����ꣻ
% Dd���������˵�ͼ��
% Bw�������ؼ��ͼ��
% Msize�������õĴ��ڰ뾶��
% Elist�����˵�(X,Y)�����������������б�
function [nbw,newDd]=BaseOptRouGrowth(X,Y,Dd,Bw,Gr,Msize,Elist)
% nbw�������ӻ��ӳ����µı��ؼ��ͼ��
% newDd�������ӻ��ӳ����µĶ˵���ͼ��

nbw = Bw;
[M,N] = size(Bw);
currDd = Dd(X-Msize:X+Msize,Y-Msize:Y+Msize);   % ȡ���˵㸽���ֲ�����--�˵�--ͼ��
currBw = Bw(X-Msize:X+Msize,Y-Msize:Y+Msize);      % ȡ���˵㸽���ֲ�����--���ؼ��--ͼ��
currGr = Gr(X-Msize:X+Msize,Y-Msize:Y+Msize);     % ȡ���˵㸽���ֲ�����--�Ҷ�--ͼ��
% newBw = currBw;
newDd = currDd;
x = Msize+1;
y = Msize+1;  %  �����������꣬�����Ӷ˵�
[row,col] = find(currDd);   % �ҵ������˵�
[p,q] = size(row);          % �����˵����
[m,n] = size(currDd);       
G_Value = zeros(m,n);    % �����������˵������������ݶ�ֵ
if p>1    % ȷ���ж˵������
    for i=1:p
         xi = row(i,1);
         yi = col(i,1);
         Ran = LineLink(x,y,xi,yi,currBw);  %  �����˵����Ӻ���
         G_Value(xi,yi) = GetG_Value(Ran,currBw,currGr);
    end
    MaxG = max(max(G_Value));
    [xe,ye] = find(G_Value==MaxG);
    fRan = LineLink(x,y,xe(1,1),ye(1,1),currBw);
    nbw(X-Msize:X+Msize,Y-Msize:Y+Msize) = fRan;   % newBw;
    newDd(x,y) = 0;     % ����ԭ���Ĺ����˵�
    newDd(xe,ye) = 0;
end

if p==1   % �޹����˵���ԭ�Ƕ��ӳ�
    fl = 0;   %��ֹ�ӳ��ı�־
    while fl==0 && X-Msize>0 && Y-Msize>0 && X+Msize<=M && Y+Msize<=N
        [nbw,flag,nX,nY,nElist] = Extend(x,y,X,Y,Bw,Msize,Elist);  % �����ӳ�����
        fl = flag;
        Bw = nbw;
        X = nX;
        Y = nY;
        Elist = nElist;
    end
    newDd(x,y) = 0;    % ����ԭ���Ĺ����˵�
end