function [slope,slValueLeft,slValueRight,slopeX,slopeY]=slopeDetection(dirlist_lineT,dirlistT_lens,img,M,N,Msize)
%% 直线拟合+信息统计
% imgdown = zeros(M+2*Msize,N+2*Msize);
%斜率，起始点，连续点数，计算的起点，图像中点，
slope=zeros(dirlistT_lens,5);       %斜率计算
for m=1:dirlistT_lens
    aa=dirlist_lineT{m};  %待处理线段
    x = length(aa);
    p = polyfit(aa(round(x*2/10):round(x*8/10),1),aa(round(x*2/10):round(x*8/10),2),1);     %线段斜率与起始点
    slope(m,1) = atan(p(1));
    if slope(m,1) < 0
        slope(m,1) = pi+slope(m,1);
    end
    slope(m,2) = round(p(2));       %起始点
    slope(m,5) = round(p(1)*(M/2+Msize)+p(2));      %中点
    slope(m,3) = x;                 %连续点个数
    slope(m,4) = aa(1,1);
    
end

%% 斜率排序
slope2 = slope;
[~,pos] = sort(slope(:,3));
slope2(:,3) = slope(pos,3);
slope2(:,2) = slope(pos,2);
slope2(:,1)= slope(pos,1);

gap=0.03;
gaplen = ceil(pi/gap);

slopeR = zeros(1,gaplen);
for m = 1:length(slope2)
    num = ceil(slope2(m,1)/gap);
    slopeR(num) = slopeR(num)+1;
end
slopeR2 = zeros(1,gaplen);
for m = 2:gaplen-1
    slopeR2(m) = slopeR(m-1)+slopeR(m)+slopeR(m+1);
end
slopeR2(1) = slopeR(1)+slopeR(2)+slopeR(gaplen);
slopeR2(gaplen) = slopeR(1)+slopeR(gaplen-1)+slopeR(gaplen);

[~,maxDot]=max(slopeR2(:));
flag1 = 0;
slValueLeft = 0;
slValueRight = 0;
if maxDot ==1 
    slValueLeft=pi-gap;
    slValueRight = gap*2;
    flag1 = 1;
elseif maxDot == gaplen
        flag1 = 1;
    slValueLeft=pi-gap*2;
    slValueRight = gap;
else
    slValueLeft = gap*(maxDot-2);
    slValueRight = gap*(maxDot+1);   
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
% 
% imgSlope = zeros(M+2*Msize,N+2*Msize);
% for m = 1:dirlistT_lens
%     if slopeX(m,1) == 1
%         aa = dirlist_lineT{m};
%         aaMax = max(aa(:,1));
%         aaMin = min(aa(:,1));
%         for n = aaMin:aaMax
%             xx = n;
%             yy = round(n*tan(slope(m,1))+slope(m,2));
%             if yy < N+2*Msize & yy >= 1
%                 imgSlope(xx,yy) = 255;
%             end
%         end
%     elseif slopeX(m,1) == 2 
%         aa = dirlist_lineT{m};        
%         aaMax = max(aa(:,2));
%         aaMin = min(aa(:,2));
%         for n = aaMin:aaMax
%             yy = n;
%             xx = round((yy-slope(m,2))/tan(slope(m,1)));
%             if xx < M+2*Msize & xx >= 1
%                 imgSlope(xx,yy) = 255;
%             end
%         end 
%     end
% end
% figure('Name','斜率约束'),imshow(imgSlope);


end
