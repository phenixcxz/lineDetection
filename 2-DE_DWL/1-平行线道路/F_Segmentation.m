%%%%基于边缘生长的图像分割 Blist--封闭边缘列表
%ix 按面积由大到小排序的区域标号
function [nbw,nL,LC,Blist,ix]=F_Segmentation(bw,edgeSegments,Gr)
Msize = 5;
[M,N] = size(Gr);
edgelist={};
edgeim=zeros(M,N);
for i = 1:length(edgeSegments)
    aa=edgeSegments{i};
    edgeim((aa(:,1)-1)*M+aa(:,2))=i;
    edgelist{i}=[aa(:,2),aa(:,1)];
end
fbw=bw;
%寻找图像的端点
[re,ce,num1] = findendspoint(bw,0);   %----调用函数----

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
            num=sum(sum(nbw-bw));
            if num>30
                bw=bw;
            else
               bw = nbw;
            end
            Dd(x-Msize:x+Msize,y-Msize:y+Msize) = newDd; 
        end
    end

end

%寻找图像的端点
%[re,ce,num1] = findendspoint(bw,0);   %----调用函数----
%搜索连续边缘并编号
%[edgelist,edgeim] = edgelink(bw,2);   %----调用函数----

%for k = 1:num1
 %   x = re(k,1);
 %   y = ce(k,1);
  %  pix = edgeim(x,y);  % 取出端点所在的线条标号
   % pix = uint16(pix);    %pix = uint8(pix);不行
  %  if pix~=0    
    %    Elist = edgelist{pix};  % 取出端点所在的连续线条列表 
     %   nBw = BaseDegGrowth(x,y,bw,Msize,Elist);  % 对所有端点进行延伸
     %   num=sum(sum(nBw-bw));
      %  if num>30
      %          bw=bw;
       % else
       %        bw = nBw;
       % end
    %end
%end

%切割图像，去除边缘端点
bw = bw(Msize:M-Msize,Msize:N-Msize);
[nM,nN] = size(bw);
bw(:,1) = 1;
bw(:,nN) = 1;
bw(1,:) = 1;
bw(nM,:) = 1;

%标记
[Blist,L] = bwboundaries(bw);
%区域合并
%Bw=Regionmerging(Gr,fbw,bw,L,Msize);  

%imshow(Bw),title('区域合并后边缘检测图');
%figure;
%标记
%[Blist,L] = bwboundaries(Bw);
%LC= label2rgb(L1, @jet, 'r','shuffle');
%figure
%imshow(LC)

%nBw = SeondaryGrowth(Bw,fbw,Msize);
%nBw=Regionmerging_1(Gr,fbw,nBw,L,Msize);  
%标记
%[Blist,L] = bwboundaries(nBw);
stats = regionprops(L, 'Area');
allArea = [stats.Area];
[B,ix]=sort(allArea,'descend');

nbw=zeros(M,N);
nbw(Msize:M-Msize,Msize:N-Msize)=bw;
nL=zeros(M,N);
nL(Msize:M-Msize,Msize:N-Msize)=L;
%NeRegion = find_neighborRegion( nL,ix );
LC= label2rgb(nL, @jet, 'r','shuffle');
figure
imshow(LC)
