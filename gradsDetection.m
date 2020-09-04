%% 寻找横向梯度
function [grads1,grads2]=gradsDetection(dirlist_lineT,dirlistT_lens,img,M,N,Msize)
%左和，右和，边缘标志，左1，左2，左3，左4，右1，右2，右3，右4
grads1 = zeros(dirlistT_lens,12);
gap = 5;
for m=1:dirlistT_lens
    aa = dirlist_lineT{m};
    num = length(aa);
    for n = 1:size(aa)
        x=aa(n,1);
        y=aa(n,2);
        if img(x,y+1) - img(x,y) > gap   %左边缘
%             if img(x,y+1)-img(x,y+2)>gap
%                 grads1(m,4) = grads1(m,4)+1;
            if img(x,y+2)-img(x,y+3)>gap
                grads1(m,5) = grads1(m,5)+1;
            elseif img(x,y+3)-img(x,y+4) > gap
                grads1(m,6) = grads1(m,6)+1;
            elseif img(x,y+4)-img(x,y+5) > gap
                grads1(m,7) = grads1(m,7)+1;
            end
            
                
        end
        if img(x,y-1) - img(x,y) > gap   %右边缘
%             if img(x,y-1)-img(x,y-2)>gap
%                 grads1(m,8) = grads1(m,8)+1;
            if img(x,y-2)-img(x,y-3)>gap
                grads1(m,9) = grads1(m,9)+1;
            elseif img(x,y-3)-img(x,y-4) > gap
                grads1(m,10) = grads1(m,10)+1;
            elseif img(x,y-4)-img(x,y-5)>gap
                grads1(m,11) = grads1(m,11)+1;
            end
        end
    end
    grads1(m,1) = grads1(m,4)+grads1(m,5)+grads1(m,6)+grads1(m,7);
    grads1(m,2) = grads1(m,8)+grads1(m,9)+grads1(m,10)+grads1(m,11);
    if grads1(m,1)/num >3/5 
        grads1(m,3) = 1;
    elseif grads1(m,2)/num > 3/5
        grads1(m,3) = 2;
    end
end

%% 寻找纵向梯度
grads2 = zeros(dirlistT_lens,3);
gap = 10;
for m=1:dirlistT_lens
    aa = dirlist_lineT{m};
    num = length(aa);
    for n = 1:size(aa)
        x=aa(n,1);
        y=aa(n,2);
        if img(x+1,y) - img(x,y) > gap   %上边缘
            if  img(x+2,y) - img(x+3,y) > gap || img(x+3,y) - img(x+4,y) > gap %右边缘
                grads2(m,1) = grads2(m,1)+1;
            end
        end
        if img(x-1,y) - img(x,y) > gap   %右边缘
            if img(x-2,y) - img(x-3,y) > gap || img(x-3,y) - img(x-4,y) > gap %左边缘
                grads2(m,2) = grads2(m,2)+1;
            end            
        end
    end
    if grads2(m,1)/num >3/5 || grads2(m,2)/num > 3/5
        grads2(m,3) = 1;
    end
end
%% 梯度约束图形化显示
% 横向梯度约束 
% imgGrads1 = zeros(M+2*Msize,N+2*Msize);
% for m = 1:dirlistT_lens
%     aa = dirlist_lineT{m};
% %     [x,y] = size(aa);
%     if grads1(m,3)>0
%         for n = 1:size(aa)
%             imgGrads1(aa(n,1),aa(n,2)) = 255;
%         end
%     end
% end
% figure('Name','横向梯度约束'),imshow(imgGrads1);
% 
% %% 纵向梯度约束 
% imgGrads2 = zeros(M+2*Msize,N+2*Msize);
% for m = 1:dirlistT_lens
%     aa = dirlist_lineT{m};
% %     [x,y] = size(aa);
%     if grads2(m,3)>0
%         for n = 1:size(aa)
%             imgGrads2(aa(n,1),aa(n,2)) = 255;
%         end
%     end
% end
% figure('Name','纵向梯度约束'),imshow(imgGrads2);

end