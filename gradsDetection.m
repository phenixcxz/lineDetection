%% 寻找横向梯度
function [dirlistT,gradsX,gradsY]=gradsDetection(dirlistT,img,M,N,Msize)
dirlistT_lens = length(dirlistT);
%左和，右和，边缘标志，1，2，3，4
gradsX = zeros(dirlistT_lens,12);
gap = 5;
for m=1:dirlistT_lens
    aa = dirlistT{m};
    for n = 1:size(aa)
        x=aa(n,1);
        y=aa(n,2);
        if img(x,y+1) - img(x,y) > gap   %左边缘
            gradsX(m,1) = gradsX(m,1)+1;
%             if img(x,y+1)-img(x,y+2)>gap
%                 gradsX(m,4) = gradsX(m,4)+1;
            if img(x,y+2)-img(x,y+3)>gap
                gradsX(m,5) = gradsX(m,5)+1;
            elseif img(x,y+3)-img(x,y+4) > gap
                gradsX(m,6) = gradsX(m,6)+1;
            elseif img(x,y+4)-img(x,y+5) > gap
                gradsX(m,7) = gradsX(m,7)+1;
            end  
        end
        if img(x,y-1) - img(x,y) > gap   %右边缘
            gradsX(m,2) = gradsX(m,2)+1;
%             if img(x,y-1)-img(x,y-2)>gap
%                 gradsX(m,8) = gradsX(m,8)+1;
            if img(x,y-2)-img(x,y-3)>gap
                gradsX(m,5) = gradsX(m,5)+1;
            elseif img(x,y-3)-img(x,y-4) > gap
                gradsX(m,6) = gradsX(m,6)+1;
            elseif img(x,y-4)-img(x,y-5)>gap
                gradsX(m,7) = gradsX(m,7)+1;
            end
        end
    end
    if gradsX(m,1)/length(aa)>3/5 
        gradsX(m,3) = 1;
    elseif gradsX(m,2)/length(aa)> 3/5
        gradsX(m,3) = 2;
    end
end

%% 寻找纵向梯度
gradsY = zeros(dirlistT_lens,12);
gap = 5;
for m=1:dirlistT_lens
    aa = dirlistT{m};
    for n = 1:size(aa)
        x=aa(n,1);
        y=aa(n,2);
        if img(x+1,y) - img(x,y) > gap   %上边缘
            gradsY(m,1) = gradsY(m,1)+1;
%             if img(x,y+1)-img(x,y+2)>gap
%                 gradsX(m,4) = gradsX(m,4)+1;y
            if img(x+2,y)-img(x+3,y)>gap
                gradsY(m,5) = gradsY(m,5)+1;
            elseif img(x+3,y)-img(x+4,y) > gap
                gradsY(m,6) = gradsY(m,6)+1;
            elseif img(x+4,y)-img(x+5,y) > gap
                gradsY(m,7) = gradsY(m,7)+1;
            end  
        end
        if img(x-1,y) - img(x,y) > gap   %下边缘
            gradsY(m,2) = gradsY(m,2)+1;
%             if img(x,y-1)-img(x,y-2)>gap
%                 gradsX(m,8) = gradsX(m,8)+1;
            if img(x-2,y)-img(x-3,y)>gap
                gradsY(m,5) = gradsY(m,5)+1;
            elseif img(x-3,y)-img(x-4,y) > gap
                gradsY(m,6) = gradsY(m,6)+1;
            elseif img(x-4,y)-img(x-5,y)>gap
                gradsY(m,7) = gradsY(m,7)+1;
            end
        end
    end
    if gradsY(m,1)/length(aa)>3/5 
        gradsY(m,3) = 1;
    elseif gradsY(m,2)/length(aa)> 3/5
        gradsY(m,3) = 2;
    end
end

% 去除颜色梯度不符合要求的线
for m = 1:length(dirlistT)
    if gradsX(m,3)< 1 && gradsY(m,3)<1
        dirlistT{m} = {};
    end
end
dirlistT(cellfun(@isempty,dirlistT))=[];
gradsX(all(gradsX(:,3)==0,2),:)=[];
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
% 
% figure('Name','梯度约束'),imshow(imggrads);        

% 梯度约束图形化显示
% 横向梯度约束 
% imggradsX = zeros(M+2*Msize,N+2*Msize);
% for m = 1:length(dirlistT)
%     aa = dirlistT{m};
% %     [x,y] = size(aa);
% %     if gradsX(m,3)>0
%         for n = 1:size(aa)
%             imggradsX(aa(n,1),aa(n,2)) = 255;
%         end
% %     end
% end
% figure('Name','横向梯度约束'),imshow(imggradsX);
% 
% %% 纵向梯度约束 
% imggradsY = zeros(M+2*Msize,N+2*Msize);
% for m = 1:dirlistT_lens
%     aa = dirlist_lineT{m};
% %     [x,y] = size(aa);
%     if gradsY(m,3)>0
%         for n = 1:size(aa)
%             imggradsY(aa(n,1),aa(n,2)) = 255;
%         end
%     end
% end
% figure('Name','纵向梯度约束'),imshow(imggradsY);

end