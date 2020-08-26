%%%%基于边缘生长的图像分割 Blist--封闭边缘列表

function [nBw,L1,Blist]=F_Segmentation(I)

%I = imread('j75.jpg'); 

gr = rgb2gray(I);
Gr = double(gr);       % uint8转换为double类型
[M,N] = size(Gr);

%imwrite(Gr,str2,'bmp');

%canny算子边沿检测
bw = edge(Gr,'canny');
bw = bwmorph(bw,'clean',1);  %将边沿检测图除去独立点
%imshow(bw),title('canny边沿检测图');
%figure;

%imwrite(bw,str3,'bmp');

fbw=bw;

%寻找图像的端点
[re,ce,num1] = findendspoint(bw,1);   %----调用函数----
%搜索连续边缘并编号
[edgelist,edgeim] = edgelink(bw,2);   %----调用函数----

Msize = 5;

%生成孤立端点图像
Dd = zeros(M,N);
for i =1:num1
   Dd(re(i,1),ce(i,1)) = 1;
end

for k=1:num1
    x = re(k,1);
    y = ce(k,1);
    if Dd(x,y)==1 && x-Msize>0 && y-Msize>0 && x+Msize<=M && y+Msize<=N      % 非边界端点
        pix = edgeim(x,y);  % 取出端点所在的线条标号
        pix = uint16(pix);    %pix = uint8(pix);不行
        if pix~=0    
            Elist = edgelist{pix};  % 取出端点所在的连续线条列表 
            
            [nbw,newDd] = BaseOptRouGrowth(x,y,Dd,bw,Gr,Msize,Elist);  %选择累加梯度最大值作为最优路径
            
            bw = nbw;
            Dd(x-Msize:x+Msize,y-Msize:y+Msize) = newDd;
        end
    end
end

%切割图像，去除边缘端点
bw = bw(Msize:M-Msize,Msize:N-Msize);
[nM,nN] = size(bw);
bw(:,1) = 1;
bw(:,nN) = 1;
bw(1,:) = 1;
bw(nM,:) = 1;
%imshow(bw),title('切割后图像1');
%figure;

%imwrite(bw,str4,'bmp');

%标记
[B,L] = bwboundaries(bw);
%区域合并
Bw=Regionmerging(gr,fbw,bw,L,Msize);  

%imshow(Bw),title('区域合并后边缘检测图');
%figure;

nBw = SeondaryGrowth(Bw,fbw,Msize);
nBw=Regionmerging_1(gr,fbw,nBw,L,Msize);  
%imwrite(nBw,str5,'bmp');

bbw=zeros(M,N);
bbw(Msize:M-Msize,Msize:N-Msize)=nBw;
nBw=bbw;
%标记
[Blist,L1] = bwboundaries(nBw);
Wei = label2rgb(L1, @jet, 'r','shuffle');
%imwrite(Wei,str6,'bmp');


