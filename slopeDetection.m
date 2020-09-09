function [dirlistT,slope,flag]=slopeDetection(dirlistT,img,M,N,Msize)
%% 直线拟合+信息统计
% imgdown = zeros(M+2*Msize,N+2*Msize);
%斜率，起始点，连续点数，计算的起点，图像中点，
dirlistT_lens = length(dirlistT);
slope=zeros(dirlistT_lens,5);       %斜率计算
for m=1:dirlistT_lens
    aa=dirlistT{m};  %待处理线段
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
% 
% [Idx,C,sumD,D]=kmeans(slope(:,1),8);
% 
% test =zeros(1,8);
% for m = 1:dirlistT_lens
%     test(Idx(m)) = test(Idx(m))+1;
% end
% 
% slope2 = slope;
% [~,maxText] = max(test);
% slValueLeft = C(maxText)-0.02;
% slValueRight = C(maxText)+0.02;
% 
% for m = 1:dirlistT_lens
%     aaSlope = slope(m,1); 
% %     if aaSlope <=slValueRight && aaSlope >= slValueLeft
% %     if flag == 1
% %         if aaSlope < slValueLeft && aaSlope > slValueRight
% %             dirlistT{m} = {};
% %             slope(m,1) = 10;
% %         end
% %     else
%         if aaSlope < slValueLeft || aaSlope > slValueRight
%             dirlistT{m} = {};
%             slope(m,1) = 10;
%         end
% %         if aaSlope >pi1 || aaSlope < pi2
% %             if aaSlope>=slValueLeft & aaSlope <= slValueRight
% %                 slopeXY(m,1) = 2;
% %             end
% %         else
% %             if aaSlope >= slValueLeft & aaSlope <= slValueRight
% %                 slopeXY(m,1) = 1;
% %             end
% %         end
% %     end
% end
% 
% dirlistT(cellfun(@isempty,dirlistT))=[];
% slope(all(slope(:,1)==10,2),:)=[];

% slope2(all(Idx(:,1)~=maxText,2),:)=[];
% for m = 1:dirlistT_lens
%     if Idx(m,1)~=maxText
%         dirlistT{m} = {};
%     end
% end
% dirlistT(cellfun(@isempty,dirlistT))=[];
% for m = 1:dirlistT_lens
% 
% slope(all(slope(:,1)==10,2),:)=[];


%% 斜率排序
slope2 = slope;
[~,pos] = sort(slope2(:,3));
slope2(:,:) = slope2(pos,:);

gap=0.02;
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
flag = 0;
slValueLeft = 0;
slValueRight = 0;
if maxDot ==1 
    slValueLeft=pi-gap;
    slValueRight = gap*2;
    flag = 1;
elseif maxDot == gaplen
        flag= 1;
    slValueLeft=pi-gap*2;
    slValueRight = gap;
else
    slValueLeft = gap*(maxDot-2);
    slValueRight = gap*(maxDot+1);   
end

for m = 1:dirlistT_lens
    aaSlope = slope(m,1);       
    if flag == 1
        if aaSlope < slValueLeft && aaSlope > slValueRight
            dirlistT{m} = {};
            slope(m,1) = 10;
        end
    else
        if aaSlope < slValueLeft || aaSlope > slValueRight
            dirlistT{m} = {};
            slope(m,1) = 10;
        end
%         if aaSlope >pi1 || aaSlope < pi2
%             if aaSlope>=slValueLeft & aaSlope <= slValueRight
%                 slopeXY(m,1) = 2;
%             end
%         else
%             if aaSlope >= slValueLeft & aaSlope <= slValueRight
%                 slopeXY(m,1) = 1;
%             end
%         end
    end
end
dirlistT(cellfun(@isempty,dirlistT))=[];
slope(all(slope(:,1)==10,2),:)=[];

% imggrads= zeros(M+2*Msize,N+2*Msize);
% for m = 1:length(dirlistT)
%     aa = dirlistT{m};
% %     [x,y] = size(aa);
%     for n=1:length(aa)
%         xx = aa(n,1);
%         yy = aa(n,2);
%         imggrads(xx,yy) = 255;
%     end
% end
% % flag = 0;
% figure('Name','斜率约束'),imshow(imggrads);  
% 
% imgSlope = zeros(M+2*Msize,N+2*Msize);
% for m = 1:length(dirlistT)
% %     if slopeXY(m,1) == 1
%         aa = dirlistT{m};
%         aaMax = max(aa(:,1));
%         aaMin = min(aa(:,1));
%         for n = aaMin:aaMax
%             xx = n;
%             yy = round(n*tan(slope(m,1))+slope(m,2));
%             if yy < N+2*Msize & yy >= 1
%                 imgSlope(xx,yy) = 255;
%             end
%         end
% %     elseif slopeXY(m,1) == 2 
% %         aa = dirlistT{m};        
% %         aaMax = max(aa(:,2));
% %         aaMin = min(aa(:,2));
% %         for n = aaMin:aaMax
% %             yy = n;
% %             xx = round((yy-slope(m,2))/tan(slope(m,1)));
% %             if xx < M+2*Msize & xx >= 1
% %                 imgSlope(xx,yy) = 255;
% %             end
% %         end 
% %     end
% end
% figure('Name','斜率约束'),imshow(imgSlope);


end
