%%%%���ڱ�Ե������ͼ��ָ� Blist--��ձ�Ե�б�

function bw=LineSegmentation(edge,Plist)
Msize = 40;
[M,N]=size(edge);


figure;
imshow(edge);


for i = 1:length(Plist)
    aa=Plist{i};
    bw=edge;
    bw((aa(:,2)-1)*M+aa(:,1))=0;
    figure;
imshow(bw);
    x = aa(1,2);
    y = aa(1,1);
    [rc,cc]=find(bw>0);
    dis=(rc(:,1)-x).^2+(cc(:,1)-y).^2;
    [v,ix]=sort(dis); %Ѱ�Ҿ���x,y����Ķϵ�
    xx=rc(ix(2),1);
    yy=cc(ix(2),1);
    hold on
    plot([y,yy],[x,xx]);
end




