function  Mv=GenVector(Msize,angle)
%Mv=法向量矩阵，Msize:窗口大小，angle,曲线切线方向
%生成与边缘方向角angle垂直的法向量，该法向量中心为当前边缘位置，窗口大小为Msize
 Mv=zeros(Msize,Msize);
 cp=double(uint8(Msize/2)); %模板中心点位置
 if angle~=90&&angle~=180
        k=-1/tan(angle*pi/180);
        if angle>45&&angle<135
          for jj=1:Msize
            Ly=k*(-jj+cp)+cp;%此处注意坐标系的转换，在图像坐标系下，中心点坐标为x=5,y=-5
            Ty=uint8(Ly);
            if Ly>0&&Ly<=Msize
               Mv(Ty,jj)=1;
            end
          end
         else
            for jj=1:Msize
            Lx=(-jj+cp)/k+cp;
            Tx=uint8(Lx);
               if Lx>0&&Lx<=Msize
                  Mv(jj,Tx)=1;
               end
            end
        end
else
        if angle==90
            Mv(cp,:)=1;  
        else
            Mv(:,cp)=1;  
        end
 end