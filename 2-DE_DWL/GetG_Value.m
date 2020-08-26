%计算连接线条的梯度值
% Ran——连接后的窗口；
% currBw——端点附近局部区域--边沿检测--图像；
% currGr——端点附近局部区域--灰度--图像；
function g_Value = GetG_Value(Ran,currBw,currGr)
% g_value——线条的梯度总和；

[M,N] = size(currGr);
Rbw = Ran-currBw;
[row,col] = find(Rbw);
g_Value = 0;
for i=1:length(row(:,1))
    x = row(i,1);
    y = col(i,1);
    if x+1<=M && y+1<=N
        detax = currGr(x+1,y)-currGr(x,y);
        detay = currGr(x,y+1)-currGr(x,y);
        Mag = sqrt(detax^2+detay^2);
        g_Value = g_Value+Mag;
    end
end
    
