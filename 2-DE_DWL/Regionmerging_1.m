% 对边缘连接后的图像进行区域合并
% Gr——灰度图像；
% fBw——图像canny边沿检测结果；
% Bw——图像基于边缘连接后结果；
% L——标记图像；
% Msize——对灰度图像进行切割使其与分割图像大小一致的切割半径；
function Bw = Regionmerging_1(Gr,fBw,Bw,L,Msize)
% Bw——区域合并后的图像边沿结果；

[M,N] = size(Gr);
%切割图像，去除边缘端点
Gr = Gr(Msize:M-Msize,Msize:N-Msize);

fBw = fBw(Msize:M-Msize,Msize:N-Msize);
[nM,nN] = size(Bw);
fBw(:,1) = 1;
fBw(:,nN) = 1;
fBw(1,:) = 1;
fBw(nM,:) = 1;

Conline = Bw-fBw; 

%搜索连续边缘并编号
[edgelist,edgeim] = edgelink(Conline,2);   %----调用函数----

num = length(edgelist);
for i = 1:num
    [m,n] = size(edgelist{i});
    if m >= 8   %线段长度的判断
        x = edgelist{i}(fix(m/2),1);
        y = edgelist{i}(fix(m/2),2);
        Dom = L(x-1:x+1,y-1:y+1);
        ind = find(Dom~=1);
        num1 = length(ind);
        if length(ind) >= 2
            bh1 = Dom(ind(1));
            bh2 = Dom(ind(2));
        else
            continue;
        end
        
        %确定线段两旁的区域标号
        for j = 3:num1
            if bh1 ~= bh2
                break;
            end
            bh2 = Dom(ind(j));
        end
        sL1 = double(L==bh1);
        Gray1 = double(Gr).*sL1;  %矩阵操作
        gray1 = sum(sum(Gray1));
        [x1,y1] = find(L==bh1);
        len1 = length(x1);
        gray1 = fix(gray1/len1);
        
        sL2 = double(L==bh2);
        Gray2 = double(Gr).*sL2;
        gray2 = sum(sum(Gray2));
        [x2,y2] = find(L==bh2);
        len2 = length(x2);
        gray2 = fix(gray2/len2);
        
        if abs(gray1-gray2) <= 10   %阈值可以调整
            for h = 2:m-1  % 区别于Regionmerging.m 线段两端点不去除
                Bw(edgelist{i}(h,1),edgelist{i}(h,2)) = 0;
            end
        end
    end
end

%去除端点
Bw = Deleteendpoints(Bw);



        