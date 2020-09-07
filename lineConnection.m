function [Llist,Lnum,slopeT]=lineConnection(dirlistT,slope,img,M,N,Msize,lineT,flag)

imgResult = zeros(M+2*Msize,N+2*Msize);
for m = 1:length(slope)
    list = dirlistT{m};
    xxMax = max(list(:,1));
    xxMin = min(list(:,1));
    temp = 1;
    for xx =xxMin:xxMax
        yy =round(xx*tan(slope(m,1))+slope(m,2));
        list(temp,1) = xx;
        list(temp,2) = yy;
        temp = temp+1;
        imgResult(xx,yy) = 255;
    end
    dirlistT{m} = list;
end
slopeT = slope;
[~,pos] = sort(slopeT(:,3));
slopeT(:,:) = slopeT(pos,:);
dirlistT2 = dirlistT;

for i = 1:length(dirlistT)
    dirlistT{i} = dirlistT2{pos(i)};
end
%% 由长线向两边延伸
imgResult2 = uint8(imgResult);
for m = 1:length(dirlistT)
    aa = dirlistT{m};
    xx1 = min(aa(:,1));
    xx2 = max(aa(:,1));
    if length(aa)>lineT
        xx1length = xx1-length(aa);
        for xx = xx1-1:-1:max(Msize,xx1length)     %向-x方向延长        
            yy = round(xx*tan(slopeT(m,1))+slopeT(m,2));
            if yy < N+2*Msize && yy >1 
                if imgResult2(xx+1,yy)==255 &&imgResult2(xx,yy)==0 &&imgResult2(xx,yy+1)==0 && imgResult2(xx,yy-1)==0
                    imgResult2(xx,yy) = 255;
                elseif imgResult2(xx+1,yy)==0 && imgResult2(xx,yy)==0
                    imgResult2(xx,yy) = 255;
                else
                    break;
                end
            end
        end
        xx2length = xx2+length(aa);    %     for xx = xx2+1:M+Msize      %向+x方向延长
        for xx = xx2+1:min(M+Msize,xx2length)     %向+x方向延长
            yy = round(xx*tan(slopeT(m,1))+slopeT(m,2));
            if yy < N+2*Msize && yy > 1 
                if imgResult2(xx-1,yy)==255 && imgResult2(xx,yy)==0 &&imgResult2(xx,yy+1)==0 && imgResult2(xx,yy-1)==0
                    imgResult2(xx,yy) = 255;
                elseif imgResult2(xx-1,yy)==0 && imgResult2(xx,yy)==0
                    imgResult2(xx,yy) = 255;
                else
                    break;
                end 
            end
        end  
    end
end
figure('Name','延长线'),imshow(uint8(imgResult2));
% imgResult3 = imgResult2(Msize+1:M+Msize,Msize+1:N+Msize);
%% 二次提取边缘线
[L,Lnum] = bwlabel(imgResult2,8);
Llist = {Lnum};
for i = 1:Lnum
    [r,c]=find(L==i);
    Llist{i} = [r,c];
end