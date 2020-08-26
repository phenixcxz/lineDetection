%与最初边缘检测结果作比较
%并进行二次增长——只作延长
% Bw
% fbw
function nBw = SeondaryGrowth(Bw,fbw,Msize)
% nBw

nBw = Bw;
[M,N] = size(fbw);
%切割最初边缘检测结果
fbw = fbw(Msize:M-Msize,Msize:N-Msize);
[nM,nN] = size(Bw);
fbw(:,1) = 1;
fbw(:,nN) = 1;
fbw(1,:) = 1;
fbw(nM,:) = 1;

%与最初边缘检测结果作比较，保留长线条

cbw = fbw-Bw;
%搜索连续边缘并编号
[edgelist,edgeim] = edgelink(cbw,2);   %----调用函数----
for i = 1:length(edgelist);
    Elist = edgelist{i};
    len = length(Elist(:,1));
    if len >= 30
        for j=1:len
            Bw(Elist(j,1),Elist(j,2)) = 1; %保留误删的长线条
        end
    end
end
Bw = bwmorph(Bw,'clean',1);

%二次增长——只作延长
%寻找图像的端点
[re,ce,num1] = findendspoint(Bw,1);   %----调用函数----
%搜索连续边缘并编号
[edgelist,edgeim] = edgelink(Bw,2);   %----调用函数----

for k = 1:num1
    x = re(k,1);
    y = ce(k,1);
    pix = edgeim(x,y);  % 取出端点所在的线条标号
    pix = uint16(pix);    %pix = uint8(pix);不行
    if pix~=0    
        Elist = edgelist{pix};  % 取出端点所在的连续线条列表 
        nBw = BaseDegGrowth(x,y,Bw,Msize,Elist);  % 对所有端点进行延伸
        Bw = nBw;
    end
end
        
