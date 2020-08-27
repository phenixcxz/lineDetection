function [slope,slValueLeft,slValueRight,slopeX,slopeY]=slopeDetection(dirlist_lineT,dirlistT_lens,img,M,N,Msize)
%% 直线拟合+信息统计
% imgdown = zeros(M+2*Msize,N+2*Msize);
slope=zeros(dirlistT_lens,3);       %斜率计算
for m=1:dirlistT_lens
    aa=dirlist_lineT{m};  %待处理线段
    x = length(aa);
    p = polyfit(aa(3:x-3,1),aa(3:x-3,2),1);     %线段斜率与起始点
    slope(m,1) = p(1);              %斜率
    slope(m,2) = round(p(2));       %起始点
    slope(m,3) = x;                 %连续点个数
end

% 
% %% 直线拟合+信息统计
% imgdown = zeros(M+2*Msize,N+2*Msize);
% slope=zeros(dirlistT_lens,3);       %斜率计算
% for m=1:dirlistT_lens
%     aa=dirlist_lineT{m};  %待处理线段
%     x = length(aa);
%     p = polyfit(aa(3:x-3,1),aa(3:x-3,2),1);     %线段斜率与起始点
%     slope(m,1) = p(1);
%     slope(m,2) = round(p(2));
%     slope(m,3) = x;     %点数记录 
% 
%     if p(1)<1 && p(1) > -1   
%         maxaa = max(aa(:,1));
%         minaa = min(aa(:,1));
%         for n = minaa:maxaa
%             xx = n;
%             yy =round(n*p(1)+p(2));
%             if yy < N+2*Msize && yy >= 1
%                 imgdown(xx,yy) = 255;
%             end
%         end
%     else
%         maxaa = max(aa(:,2));
%         minaa = min(aa(:,2));
%         for n = minaa:maxaa                 %线段拟合
%             yy = n;
%             xx = round((yy-p(2))/p(1));
%             if xx < M+2*Msize && xx >= 1
%                 imgdown(xx,yy) = 255;
%             end
%         end
%     end
% end
% figure('Name','直线拟合'),imshow(imgdown);
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
slHist = histogram(slope2(slsize-dotNum+1:slsize,1));   %斜率直方图

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

slValueLeft = 0;
slValueRight = 0;
for i = slsize-dotNum+1:slsize
    if slope2(i,1)>slEdgeLeft && slope2(i,1) < slEdgeRight
        if slValueLeft>slope2(i,1)
           slValueLeft=slope2(i,1);
        end
        if slValueRight < slope2(i,1)
            slValueRight = slope2(i,1);
        end
    end
end

if slValueLeft >= 0
    slValueLeft = slValueLeft*1/2;
    slValueRight = slValueRight*3/2;
elseif slValueRight<=0
    slValueLeft = slValueLeft*3/2;
    slValueRight = slValueRight*1/2;
else
    slValueLeft = slValueLeft*3/2;
    slValueRight = slValueRight*3/2;
end


    


% 
% if slEdgeLeft<0 && slEdgeRight>0
%     meanNum1 = 0;
%     meanValue1 = 0;
%     meanNum2 = 0;
%     meanValue2 = 0;
%     for i = slsize-dotNum+1:slsize
%         if slope2(i,1)>slEdgeLeft && slope2(i,1)<0
%             meanNum1 = meanNum1+1;
%             meanValue1 = meanValue1 + slope2(i,1);
%         elseif slope2(i,1) < slEdgeRight && slope2(i,1) >=0
%             meanNum2 = meanNum2+1;
%             meanValue2 = meanValue2 + slope2(i,1);
%         end
%     end
%     slValueLeft = meanValue1/meanNum1*3/2; %%斜率边界    
%     slValueRight = meanValue2/meanNum2*3/2;    
%     
% elseif slEdgeRight<=0
%     meanValue = 0;
%     meanNum = 0;
%     for i = slsize-dotNum+1:slsize
%         if slope2(i,1)>slEdgeLeft && slope2(i,1) < slEdgeRight
%             meanNum = meanNum+1;
%             meanValue = meanValue + slope2(i,1);
%         end
%     end
%     slValueLeft = meanValue/meanNum*3/2; %%斜率边界
%     slValueRight = meanValue/meanNum*1/2; 
% else
%     meanValue = 0;
%     meanNum = 0;
%     for i = slsize-dotNum+1:slsize
%         if slope2(i,1)>slEdgeLeft && slope2(i,1) < slEdgeRight
%             meanNum = meanNum+1;
%             meanValue = meanValue + slope2(i,1);
%         end
%     end 
%     slValueLeft = meanValue/meanNum*1/2; %%斜率边界
%     slValueRight = meanValue/meanNum*3/2;
% end



% if meanValue>0
%     slValueLeft = meanValue/meanNum+*1/2; %%斜率边界
%     slValueRight = meanValue/meanNum*3/2;
% else
%     slValueLeft = meanValue/meanNum*3/2; %%斜率边界
%     slValueRight = meanValue/meanNum*1/2; 
% end

slopeX = zeros(dirlistT_lens,1);
slopeY = zeros(dirlistT_lens,1);
for m = 1:dirlistT_lens
    aa = dirlist_lineT{m};
    aaLen = length(aa);
    p = polyfit(aa(4:aaLen-3,1),aa(4:aaLen-3,2),1);
    aaSlope = p(1);
    if aaSlope(1) <1 && aaSlope > -1 
        if aaSlope>slValueLeft && aaSlope < slValueRight
            slopeX(m,1) = 1;
        end
    else
        if aaSlope > slValueLeft && aaSlope < slValueRight
            slopeY(m,1) = 1;
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
            yy = round(n*slope(m,1)+slope(m,2));
            if yy < N+2*Msize && yy >= 1
                imgSlope(xx,yy) = 255;
            end
        end
    elseif slopeY(m,1) == 1 
        aa = dirlist_lineT{m};        
        aaMax = max(aa(:,2));
        aaMin = min(aa(:,2));
        for n = aaMin:aaMax
            yy = n;
            xx = round((yy-slope(m,2))/slope(m,1));
            if xx < M+2*Msize && xx >= 1
                imgSlope(xx,yy) = 255;
            end
        end 
    end
end
figure('Name','斜率约束'),imshow(imgSlope);
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
