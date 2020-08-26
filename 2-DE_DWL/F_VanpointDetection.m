%消失点检测
% Pim——平行线图像
function vanpoint = F_VanpointDetection(Pim)
%vanpoint——消失点坐标

%去除水平线和垂直线
pbw = double(Pim~=0);
[edgelist,edgeim] = edgelink(pbw,2);   %----调用函数----
num = length(edgelist);
for i=1:num
    Tnum = 0;
    aa = edgelist{i};
    len = length(aa(:,1));
    for j=1:len
        Paa = Pim(aa(j,1),aa(j,2));
        if Paa>75 && Paa<89
            Tnum = Tnum+1;  %pbw(aa(j,1),aa(j,2))=0;
        elseif Paa>240 && Paa<=255
                Tnum = Tnum+1; %pbw(aa(j,1),aa(j,2))=0;
        elseif Paa>155 && Paa<=175
                     Tnum = Tnum+1;  %pbw(aa(j,1),aa(j,2))=0;
        end
    end
    if (Tnum/len>0.75) || len<=15
        pbw(aa(:,1),aa(:,2)) = 0;
    end
end
figure;
imshow(pbw);
%imwrite(pbw,'px14.bmp');
figure;

%拟合找消失点
[vanpoint,crossline] = findvanpoint(pbw);
vanpoint = fix(vanpoint);









