% function [imgLBP]=LBP(img)
%     [m,n] = size(img);
%     imgLBP = zeros(m,n);
%     for i=2:m-1
%        for j=2:n-2 
%            if img(i-1,j-1)>img(i,j)
%                imgLBP(i,j)=imgLBP(i,j)+1;
%            end
%            if img(i-1,j)>img(i,j)
%                imgLBP(i,j)=imgLBP(i,j)+2;
%            end
%            if img(i-1,j+1)>img(i,j)
%                imgLBP(i,j)=imgLBP(i,j)+4;
%            end
%            if img(i,j+1)>img(i,j)
%                imgLBP(i,j)=imgLBP(i,j)+8;
%            end
%            if img(i+1,j+1)>img(i,j)
%                imgLBP(i,j)=imgLBP(i,j)+16;
%            end
%            if img(i+1,j)>img(i,j)
%                imgLBP(i,j)=imgLBP(i,j)+32;
%            end
%            if img(i+1,j-1)>img(i,j)
%                imgLBP(i,j)=imgLBP(i,j)+64;
%            end
%            if img(i,j-1)>img(i,j)
%                imgLBP(i,j)=imgLBP(i,j)+128;
%            end      
%         end
%     end
% end


function [val]=LBP(img,i,j)
    val = 0;
    if img(i-1,j-1)>img(i,j)
       val = val +1;
    end
    if img(i-1,j)>img(i,j)
       val = val+2;
    end
    if img(i-1,j+1)>img(i,j)
       val = val+4;
    end
    if img(i,j+1)>img(i,j)
       val = val+8;
    end
    if img(i+1,j+1)>img(i,j)
       val = val+16;
    end
    if img(i+1,j)>img(i,j)
       val = val+32;
    end
    if img(i+1,j-1)>img(i,j)
       val = val+64;
    end
    if img(i,j-1)>img(i,j)
       val = val+128;
    end      
end
