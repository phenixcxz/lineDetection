% 将不构成封闭区域的线段或端点去除
% bw——区域合并后的边沿检测图像；
function Bw=Deleteendpoints(bw)
%Bw——处理后的边沿检测图像；

[M,N] = size(bw);
Bw = bw;

num3 = 1;
while num3>0
    
%寻找图像的端点
[re,ce,num1] = findendspoint(bw,1);   %----调用函数----
%搜索连续边缘并编号
[edgelist,edgeim] = edgelink(bw,2);   %----调用函数----

for i=1:num1
    x = re(i,1);
    y = ce(i,1);
    Bw(x,y) = 0;
end

for i=1:num1
    x = re(i,1);
    y = ce(i,1);
    pix = edgeim(x,y); %端点所在线条标号
    pix = uint16(pix);
    [m,n] = size(edgelist{pix});
    x1 = edgelist{pix}(1,1);
    y1 = edgelist{pix}(1,2);
    
    if x1==x && y1==y
        from  = 1;
        step = 1;
        to = m;
    else
        from = m;
        step = -1;
        to = 1;
    end 
    
    for j=from:step:to
        x = edgelist{pix}(j,1);
        y = edgelist{pix}(j,2);
        if x-1>0 && x+1<=M && y-1>0 && y+1<=N 
            Nei = bw(x-1:x+1,y-1:y+1);
            Total = sum(sum(Nei));
            if Total<=2
               Bw(x,y) = 0;
            end
            bw = Bw;
        end
    end
end
%imshow(Bw);
%figure;

%寻找图像的端点
[re2,ce2,num2] = findendspoint(bw,1);   %----调用函数----
%搜索连续边缘并编号
%[edgelist2,edgeim2] = edgelink(bw,2);   %----调用函数----

for i2=1:num2
    x = re2(i2,1);
    y = ce2(i2,1);
    Bw(x,y) = 0;
end
%imshow(Bw);
%figure;

%将边沿检测图除去独立点
%Bw = DeleteSingle(Bw,M,N);
Bw = bwmorph(Bw,'clean',1);
%imshow(Bw),title('除去独立点的边沿检测图0');
%figure;

%寻找图像的端点
[re3,ce3,num3] = findendspoint(Bw,1);   %----调用函数----
%搜索连续边缘并编号
%[edgelist2,edgeim2] = edgelink(Bw,2);   %----调用函数----
                                                              
bw = Bw;
end


        
        
        

