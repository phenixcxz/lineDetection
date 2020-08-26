function  Mv=GenVector(Msize,angle)
%Mv=����������Msize:���ڴ�С��angle,�������߷���
%�������Ե�����angle��ֱ�ķ��������÷���������Ϊ��ǰ��Եλ�ã����ڴ�СΪMsize
 Mv=zeros(Msize,Msize);
 cp=double(uint8(Msize/2)); %ģ�����ĵ�λ��
 if angle~=90&&angle~=180
        k=-1/tan(angle*pi/180);
        if angle>45&&angle<135
          for jj=1:Msize
            Ly=k*(-jj+cp)+cp;%�˴�ע������ϵ��ת������ͼ������ϵ�£����ĵ�����Ϊx=5,y=-5
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