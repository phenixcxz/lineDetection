%%%%基于边缘生长的图像分割 Blist--封闭边缘列表

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
    [v,ix]=sort(dis); %寻找距离x,y最近的断点
    xx=rc(ix(2),1);
    yy=cc(ix(2),1);
    hold on
    plot([y,yy],[x,xx]);
end




