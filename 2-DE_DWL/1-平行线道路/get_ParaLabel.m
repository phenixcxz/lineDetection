%��ù̶�������ƽ�е�������ż���Ŀ
%PL--��ž���paraimg--ƽ������ͼ��paralist--ƽ�����������б�index--��־ 0 ��ƽ���� 1 ��ƽ����
function   [PL,paraimg,paralist,index]=get_ParaLabel(XX,aa,dirlist,codeimg,paraimg,type)
Msize=fix(length(XX)/2);
cp=Msize+1; %ģ�����ĵ�λ��
Cnum=XX(cp,cp);
XX(cp,cp)=0;
len1=length(aa); %����1�ĳ���
[m,n]=size(codeimg);
[r,c]=find(XX>0);
[dr,dc]=size(r);
Img=zeros(size(codeimg));
paraimg=zeros(size(codeimg));
paralist={};
Dir=codeimg((aa(:,2)-1)*m+aa(:,1));
PL=[];
index=0;
paralist{1}=aa;
if dr==1 %���ֻ��һ���ཻ��
   Lnum=XX(r(1,1),c(1,1));  %ȡ���õ���  
   bb=dirlist{Lnum};  
   len2=length(bb); %����2�ĳ���
   dis=sqrt((r(1,1)-cp).*(r(1,1)-cp)+(c(1,1)-cp).*(c(1,1)-cp));
   if Lnum==Cnum||len1>len2  %�����Ǳ�1���ȶ̵���������1�����ͬ������
       index=0;
       return
   end
   Dirb=codeimg((bb(:,2)-1)*m+bb(:,1)); %ȡ����Ŷ�Ӧ�ķ���ֲ�
   Img((bb(:,2)-1)*m+bb(:,1))=Dirb;
   Img((aa(:,2)-1)*m+aa(:,1))=Dir;
  % figure
  % imshow(Img);

   flag=is_Dirconsistent(aa,bb,Dir,Dirb,dis,type);
   if flag>0
      index=1;
      PL=[Cnum,Lnum];
      paralist{2}=bb;
      paraimg((bb(:,2)-1)*m+bb(:,1))=Dirb;
      paraimg((aa(:,2)-1)*m+aa(:,1))=Dir;
   else
      index=0;
      PL=0;
   end
elseif dr>1
   dis=sqrt((r-cp).*(r-cp)+(c-cp).*(c-cp));
   [tdis,ixdis]=sort(dis); %����������
   %��ѡ��������������   ȡ���������ж������������ĵ��Ƿ���ͬһ��
   fl=1; %��־
   cx=zeros(2,1);
   discx=zeros(2,1);
   for ki=1:dr
       cx(fl)=r(ixdis(ki,1),1);
       cy(fl)=c(ixdis(ki,1),1);
       Lnum=XX(cx(fl),cy(fl));  %ȡ���õ���
       if fl==1
          Lnum1=Lnum;
          bb1=dirlist{Lnum};
          len2=length(bb1); %����2�ĳ���
       else
          Lnum2=Lnum;
          bb2=dirlist{Lnum};
          len2=length(bb2); %����2�ĳ���
       end
       discx(fl)=tdis(ki,1);
       if len1<len2 && Lnum ~= Cnum
          fl=fl+1;
          if fl==3 
             break;
          end
       end
   end
   
   if fl==2
        Dirb=codeimg((bb1(:,2)-1)*m+bb1(:,1)); %ȡ����Ŷ�Ӧ�ķ���ֲ�
        Img((bb1(:,2)-1)*m+bb1(:,1))=Dirb;
        Img((aa(:,2)-1)*m+aa(:,1))=Dir;
    %    figure
    %    imshow(Img);
        flag=is_Dirconsistent(aa,bb1,Dir,Dirb,discx(1),type);
        if flag>0
           index=1;
           PL=[Cnum,Lnum];
           paralist{2}=bb1;
           paraimg((bb1(:,2)-1)*m+bb1(:,1))=Dirb;
           paraimg((aa(:,2)-1)*m+aa(:,1))=Dir;
        else
           index=0;
           PL=0;
        end
        return;
   end
   if fl<2
         index=0;
         PL=0;
         return;
   end
   fcos=(cx(1)-cp)*(cx(2)-cp)+(cy(1)-cp)*(cy(2)-cp)/(discx(1)*discx(2));
   if fcos>=0 %��ͬ�࣬ȡ��С��
      Dirb=codeimg((bb1(:,2)-1)*m+bb1(:,1)); %ȡ����Ŷ�Ӧ�ķ���ֲ�
      Img((bb1(:,2)-1)*m+bb1(:,1))=Dirb;
      Img((aa(:,2)-1)*m+aa(:,1))=Dir;
    %  figure
    %  imshow(Img);
      flag=is_Dirconsistent(aa,bb1,Dir,Dirb,discx(1),type);
      if flag>0
          index=1;
          PL=[Cnum,Lnum1];
          paralist{2}=bb1;
          paraimg((bb1(:,2)-1)*m+bb1(:,1))=Dirb;
          paraimg((aa(:,2)-1)*m+aa(:,1))=Dir;
      else
          index=0;
          PL=0;
      end
   else  %����࣬������ȡ
      Dirb1=codeimg((bb1(:,2)-1)*m+bb1(:,1)); %ȡ����Ŷ�Ӧ�ķ���ֲ�
      flag1=is_Dirconsistent(aa,bb1,Dir,Dirb1,discx(1),type);
      Dirb2=codeimg((bb2(:,2)-1)*m+bb2(:,1)); %ȡ����Ŷ�Ӧ�ķ���ֲ�
      Img((bb1(:,2)-1)*m+bb1(:,1))=Dirb1;
      Img((bb2(:,2)-1)*m+bb2(:,1))=Dirb2;
      Img((aa(:,2)-1)*m+aa(:,1))=Dir;
   %   figure
   %   imshow(Img);
      flag2=is_Dirconsistent(aa,bb2,Dir,Dirb2,discx(2),type);
      if flag1>0 && flag2>0
          index=2;
          PL=[Cnum,Lnum1,Lnum2];
          paralist{2}=bb1;
          paralist{3}=bb2;
          paraimg((bb1(:,2)-1)*m+bb1(:,1))=Dirb1;
          paraimg((bb2(:,2)-1)*m+bb2(:,1))=Dirb2;
          paraimg((aa(:,2)-1)*m+aa(:,1))=Dir;
      else
          if flag1>0
             index=1;
             PL=[Cnum,Lnum1];
             paralist{2}=bb1;
             paraimg((bb1(:,2)-1)*m+bb1(:,1))=Dirb1;
             paraimg((aa(:,2)-1)*m+aa(:,1))=Dir;
          elseif flag2>0
             index=1;
             PL=[Cnum,Lnum2];
             paralist{2}=bb2;
             paraimg((bb2(:,2)-1)*m+bb2(:,1))=Dirb2;
             paraimg((aa(:,2)-1)*m+aa(:,1))=Dir;
          else
             index=0;
             PL=0;
          end
      end
   end
else
   index=0;
   PL=0;
end