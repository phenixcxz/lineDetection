%图像各区域颜色主成分信息
%获得——HSV——图像区域的主导色彩
% I——RGB图像；
% Bw——图像分割后边缘检测图；
function nImg=F_Regioncolor(I,Bw)
% nI——区域赋予主导色彩后的图像；

Msize=5;
[nM,nN]=size(Bw);
[nB,nL]=bwboundaries(Bw);
[M,N] = size(I(:,:,1));

HSV = rgb2hsv(I);

%去除区域标好矩阵中的边缘标号
for p=1:nM
    for q=1:nN
        if Bw(p,q)==1
            nL(p,q) = 0;
        end    
    end
end

HI = HSV(:,:,1);
SI = HSV(:,:,2);
VI = HSV(:,:,3);

HImage = fix(360*HI);
SImage = fix(100*SI);  %255->100
VImage = fix(100*VI);  %255->100

nI = zeros(nM,nN,3);
num = max(max(nL));  % 图像封闭区域个数
for i=1:num
    sLi = double(nL==i); 
    feikong = find(sLi);
    if feikong~=0
        Hue = double(HImage).*sLi;
        Sat = double(SImage).*sLi;
        Val = double(VImage).*sLi;
        [comH,comS,comV] = FindcomHSV(Hue,Sat,Val); % 找最大值
        
        nI(:,:,1) = comH(1,1)*sLi+nI(:,:,1);
        nI(:,:,2) = comS(1,1)*sLi+nI(:,:,2);
        nI(:,:,3) = comV(1,1)*sLi+nI(:,:,3);  %不考虑Value
    end      
end
%nI(:,:,3) = VI(Msize:M-Msize,Msize:N-Msize);  %不考虑Value
nImg = hsv2rgb(nI);
