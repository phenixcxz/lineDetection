function [slope,slValueLeft,slValueRight,slopeX,slopeY]=slopeDetection(dirlist_lineT,dirlistT_lens,img,M,N,Msize)
%% 直线拟合+信息统计
% imgdown = zeros(M+2*Msize,N+2*Msize);
%斜率，中点，连续点数
slope=zeros(dirlistT_lens,5);       %斜率计算
for m=1:dirlistT_lens
    aa=dirlist_lineT{m};  %待处理线段
    x = length(aa);
    p = polyfit(aa(round(x*2/10):round(x*8/10),1),aa(round(x*2/10):round(x*8/10),2),1);     %线段斜率与起始点
    slope(m,1) = atan(p(1));
    if slope(m,1) < 0
        slope(m,1) = 3.1415+slope(m,1);
    end
    slope(m,2) = round(p(2));       %起始点
    slope(m,5) = round(p(1)*(M/2+Msize)+p(2));
    slope(m,3) = x;                 %连续点个数
    
end


%% 斜率排序
slope2 = slope;
[~,pos] = sort(slope(:,3));
slope2(:,3) = slope(pos,3);
slope2(:,2) = slope(pos,2);
slope2(:,1)= slope(pos,1);


%% 寻找适合斜率
% [slsize,y] = size(slope);
slsize = length(slope);
dotNum = 20;
figure(21)
slHist = histogram(slope2(slsize-dotNum+1:slsize,1),6);   %斜率直方图

slValue = slHist.Values;
slEdge = slHist.BinEdges;

slEdgeLeft = 0;
slEdgeRight = 0;

for i = 1:length(slValue)
    if slValue(i) >= dotNum/5
        slEdgeLeft = slEdge(i);
        break;
    end
end
for i = length(slValue):-1:1
    if slValue(i) >= dotNum/5
        slEdgeRight = slEdge(i+1);
        break;
    end
end

flag1 = 0;
if slEdgeRight-slEdgeLeft > 2
    for i = 1:length(slValue)
        if slValue(i) >= dotNum/5
            slEdgeRight = slEdge(i+1);
            break;
        end
    end
    for i = length(slValue):-1:1
        if slValue(i) >= dotNum/5
            slEdgeLeft = slEdge(i);
            break;
        end
    end 
    flag1 =1;
    meanNum1 = 0;
    meanValue1 = 0;
    meanNum2 = 0;
    meanValue2 = 0;
    for i = slsize-dotNum+1:slsize
        if slope2(i,1)>slEdgeLeft 
            meanNum1 = meanNum1+1;
            meanValue1 = meanValue1 + slope2(i,1);
        elseif slope2(i,1) < slEdgeRight
            meanNum2 = meanNum2+1;
            meanValue2 = meanValue2 + slope2(i,1);
        end
    end
    slValueLeft = meanValue1/meanNum1-0.05; %%斜率边界    
    slValueRight = meanValue2/meanNum2+0.05;    
    
else
    meanValue = 0;
    meanNum = 0;
    for i = slsize-dotNum+1:slsize
        if slope2(i,1)>slEdgeLeft && slope2(i,1) < slEdgeRight
            meanNum = meanNum+1;
            meanValue = meanValue + slope2(i,1);
        end
    end
    slValueLeft = meanValue/meanNum-0.05; %%斜率边界
    slValueRight = meanValue/meanNum+0.05; 
end


%% 弧度约束
slopeX = zeros(dirlistT_lens,1);
pi1 = pi/4;
pi2 = pi*3/4;
for m = 1:dirlistT_lens
    aaSlope = slope(m,1);       
    if flag1 == 1
        if aaSlope > slValueLeft | aaSlope < slValueRight
            slopeX(m,1) = 1;
        end
    else
        if aaSlope >pi1 & aaSlope < pi2
            if aaSlope>=slValueLeft & aaSlope <= slValueRight
                slopeX(m,1) = 2;
            end
        else
            if aaSlope >= slValueLeft & aaSlope <= slValueRight
                slopeX(m,1) = 1;
            end
        end
    end
end

imgSlope = zeros(M+2*Msize,N+2*Msize);
for m = 1:dirlistT_lens
    if slopeX(m,1) == 1
        aa = dirlist_lineT{m};
        aaMax = max(aa(:,1));
        aaMin = min(aa(:,1));
        for n = aaMin:aaMax
            xx = n;
            yy = round(n*tan(slope(m,1))+slope(m,2));
            if yy < N+2*Msize & yy >= 1
                imgSlope(xx,yy) = 255;
            end
        end
    elseif slopeX(m,1) == 2 
        aa = dirlist_lineT{m};        
        aaMax = max(aa(:,2));
        aaMin = min(aa(:,2));
        for n = aaMin:aaMax
            yy = n;
            xx = round((yy-slope(m,2))/tan(slope(m,1)));
            if xx < M+2*Msize & xx >= 1
                imgSlope(xx,yy) = 255;
            end
        end 
    end
end
% figure('Name','斜率约束'),imshow(imgSlope);
% %% 延长线
% imgSlope = zeros(M+2*Msize,N+2*Msize);
% for m = 1:dirlistT_lens
%     if slopeX(m,1) == 1
%         aa = dirlist_lineT{m};
%         aaMax = max(aa(:,1));
%         aaMin = min(aa(:,1));
%         for n = Msize:M+Msize
%             xx = n;
%             yy = round(n*slope(m,1)+slope(m,2));
%             if yy < N+2*Msize && yy >= 1
%                 imgSlope(xx,yy) = 255;
%             end
%         end
%     elseif slopeY(m,1) == 1 
%         aa = dirlist_lineT{m};        
%         aaMax = max(aa(:,2));
%         aaMin = min(aa(:,2));
%         for n = Msize:N+Msize
%             yy = n;
%             xx = round((yy-slope(m,2))/slope(m,1));
%             if xx < M+2*Msize && xx >= 1
%                 imgSlope(xx,yy) = 255;
%             end
%         end 
%     end
% end
% figure('Name','斜率约束'),imshow(imgSlope);

end
