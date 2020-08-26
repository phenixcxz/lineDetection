%计算暗原色图像
function win_dark=get_darkimg(I,win_size)
[h,w,c]=size(I);
win_dark=ones(h,w);
%计算分块darkchannel
 for j=1:w
    for i=1:h
        i1=max(1,i-win_size);
        i2=min(h,i+win_size);
        j1=max(1,j-win_size);
        j2=min(w,j+win_size);
        Idark=I(i1:i2,j1:j2,:);
        Ir=min(min(Idark(:,:,1)));
        Ig=min(min(Idark(:,:,2)));
        Ib=min(min(Idark(:,:,3)));
        win_dark(i,j)=min(min(Ir,Ig),Ib);
    end
 end
 
 %选定精确dark value坐标
% win_b = zeros(img_size,1);
