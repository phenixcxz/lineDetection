%ͨ����������Ѱ����ʧ��
% vanishingpoint������ʧ��; vanimg--���й���·��ʧ���ֱ��  vanlist--���й���ʧ���ֱ���б�
function [vanishingpoint,vanimg,vanlist]=findvanpoint(tim,pylist,tlist)
%pbw=imread('5p.bmp');
% vanishingpoint������ʧ�����ꣻ
% crossline����������ʧ����ཻ��ţ�
%pbw=imread('p7.bmp');
num1 = length(pylist);   
pnum=0;
for i=1:num1
    aa = pylist{i};
    if length(aa)>10
      pnum=pnum+1;
      x = aa(:,1);
      y = aa(:,2);
      p1 = polyfit(x,y,1);  %һ����� 
      Ylist{pnum} = p1;
    end
end
crossnum = 1;
for i=1:pnum-1
    for j=i+1:pnum
        p1 = Ylist{i};
        p2 = Ylist{j};
        if abs(p1(1,1)-p2(1,1))>0.1 || abs(p1(1,2)-p2(1,2))>5 %ȷ�������߶β�����ͬһֱ��
           xcord = (p1(1,2)-p2(1,2))/(p2(1,1)-p1(1,1));
           ycord = p1(1,1)*xcord+p1(1,2);
           if xcord<10000 && ycord<10000
              crosspoint(crossnum,1) = xcord;
              crosspoint(crossnum,2) = ycord;
              crossnum = crossnum+1;
           end
        end
    end
end
plot(crosspoint(:,2),crosspoint(:,1),'r+');

crossnum = crossnum-1;
%Ѱ�Ҿ�������
if crossnum==1
    vanishingpoint = crosspoint;
 else
    %plot(crosspoint(:,1),crosspoint(:,2),'*','color','b');
    [C,U,obj_fcn] = fcm(crosspoint, 2);  %����һ
    maxU = max(U);
    index1 = find(U(1,:) == maxU);
    index2 = find(U(2, :) == maxU);
    plot(C(:,1),C(:,2),'rs','color','r');
    if length(index1)>length(index2)
        Cs = 1;
    else
        Cs = 2;
    end
    vanishingpoint = C(Cs,:);
end
[M,N]=size(tim);
vanimg=zeros(M,N);
vanlist={};
vannum=0;
for i=1:length(tlist)
    aa=tlist{i};
    x = aa(:,1);
    y = aa(:,2);
    p = polyfit(x,y,1);  %һ����� 
    dis=abs(p(1,1)*vanishingpoint(1,1)-vanishingpoint(1,2)+p(1,2))/sqrt(p(1,1)*p(1,1)+1);
    if dis<30
       vannum=vannum+1;
       vanlist{vannum}=aa;
       vanimg((aa(:,2)-1)*M+aa(:,1))=1;
    end
end
figure
imshow(vanimg);

