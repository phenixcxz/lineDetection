% �˵㰴ԭ�Ƕ��ӳ�
% (X,Y)���������˵�ԭͼ���е����ꣻ
% Dd���������˵�ͼ��
% Bw�������ؼ��ͼ��
% Msize�������õĴ��ڰ뾶��
% Elist�����˵�(X,Y)�����������������б�
function nBw= BaseDegGrowth(X,Y,Bw,Msize,Elist)
% nbw����ֻ���ӳ����µı��ؼ��ͼ��
% newDd����ֻ���ӳ����µĶ˵���ͼ��
nBw = Bw;
[M,N] = size(Bw);
x = Msize+1;
y = Msize+1;  %  ������������

 % ��ԭ�Ƕ��ӳ�
 fl = 0;   %��ֹ�ӳ��ı�־
 while fl==0 && X-Msize>0 && Y-Msize>0 && X+Msize<=M && Y+Msize<=N
     [nBw,flag,nX,nY,nElist] = Extend(x,y,X,Y,Bw,Msize,Elist);
     fl = flag;
     Bw = nBw;
     X = nX;
     Y = nY;
     Elist = nElist;                                                     
 end