clear all
close all
im=imread('DSC00222.JPG');
lineT=10;
% im = imresize(im,[480,640]);
figure
imshow(im)


% imageb = im(:,:,3);
% figure
% imshow(imageb)

BW = edge(imageb,'canny');%Canny方法提取图像边界，返回二值图像(边界1,否则0)
[H,T,R] = hough(BW);%计算二值图像的标准霍夫变换，H为霍夫变换矩阵，I,R为计算霍夫变换的角度和半径值
subplot(1,3,2);
figure
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');%hough变换的图像
xlabel('\theta'), ylabel('\rho');
axis on,axis square,hold on;
P  = houghpeaks(H,3);%提取3个极值点
x = T(P(:,2)); 
y = R(P(:,1));
plot(x,y,'s','color','white');%标出极值点
lines=houghlines(BW,T,R,P);%提取线段
subplot(1,3,3);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          imshow(imageb), hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');%画出线段
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');%起点
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');%终点
end