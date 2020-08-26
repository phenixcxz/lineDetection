% 确定——HSV——图像各区域的颜色主成分 
% HI，SI，VI——HSV图像对应三通道像素值；
function  [comH,comS,comV]=findcomHSV(HI,SI,VI)
% comH，comS，comV——HSV图像对应三通道的像素出现比例对应最大值；

Hhist = zeros(360,1);
Shist = zeros(100,1);
Vhist = zeros(100,1);

[X,Y] = find(HI);
for len=1:length(X)
    Hval = HI(X(len,1),Y(len,1));
    if Hval==0
        Hval = Hval+1;
    end
    Hhist(Hval,1) = Hhist(Hval,1)+1;
    Sval = SI(X(len,1),Y(len,1));
    if Sval==0
        Sval = Sval+1;
    end
    Shist(Sval,1) = Shist(Sval,1)+1;
    Vval = VI(X(len,1),Y(len,1));
    if Vval==0
        Vval = Vval+1;
    end
    Vhist(Vval,1) = Vhist(Vval,1)+1;
end

mainH = max(Hhist);
comH = find(Hhist==mainH);
comH = mean(comH)/360;

mainS = max(Shist);
comS = find(Shist==mainS);
comS = mean(comS)/100;

mainV = max(Vhist);
comV = find(Vhist==mainV);
comV = mean(comV)/100;

