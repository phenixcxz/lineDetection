%垂直区域推理
%利用利用区域轮廓中的垂直线
% Vim——垂直线图像；
% Bw——分割图像；
function ver_regionimg = F_VerRegionDetection(Vim,Bw)
% ver_regionimg——垂直区域标记图像；

[B,L] = bwboundaries(Bw);
[edgelist,edgeim] = edgelink(Vim,2);   %----调用函数----
num = length(edgelist);
ver_regionnum = zeros(max(max(L)),1);
for i=1:num
    aa = edgelist{i};
    len = length(aa(:,1));
    mid = fix((len+1)/2);
    x = aa(mid,1);
    y = aa(mid,2);
    
    win = L(x-1:x+1,y-1:y+1);
    [xf,yf] = find(win~=L(x,y));  
    bh1 = win(xf(1,1),yf(1,1));
    for j=2:length(xf)
        bh2 = L(xf(j,1),yf(j,1));
        if bh2~=bh1;
            break;
        end
    end
    if bh1~=0
        sL = double(L==bh1);
        [xx,yy] = find(sL);
        area = length(xx);
        ver_regionnum(bh1,1) = 1;
        ver_regionnum(bh1,2) = area;
    end
    if bh2~=0
        sL = double(L==bh2);
        [xx,yy] = find(sL);
        area = length(xx);
        ver_regionnum(bh2,1) = 1;
        ver_regionnum(bh2,2) = area;
    end
end
[A,idx] = sort(ver_regionnum(:,2));
idx1 = idx(end,1);
idx2 = idx(end-1,1);

ver_regionimg = zeros(size(Bw));
for l=1:max(max(L))
    if ver_regionnum(l,1)==1 && l~=idx1 
        sL = double(L==l);
        ver_regionimg = ver_regionimg+sL;
    end
end

