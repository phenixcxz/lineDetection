function NeRegion = find_neighborRegion( nL,ix )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
se=[0 1 1;1 0 1; 1 1 0];
idx=[];
index=[];
NeRegion={};
for i=1:length(ix)
    j=ix(i);
    if j>1
        Lx=double(nL==j);
        bw2 = imdilate(Lx,se);
        bw3 = imdilate(bw2,se);
        lab=(bw3-bw2).*nL;
        %���ҵ�ǰ����������Լ������Ե
        [r,c]=find(lab>0);
        for ii=1:length(r)
            if ii>1
               idx=[idx lab(r(ii,1),c(ii,1))];
               num=sum((idx(1,1:ii-1)-lab(r(ii,1),c(ii,1)))==0)
               if num==0 && lab(r(ii,1),c(ii,1))>1 && lab(r(ii,1),c(ii,1))~=j
                  index=[index lab(r(ii,1),c(ii,1))];
               end
            else
               idx=[lab(r(ii,1),c(ii,1))]; 
               if lab(r(ii,1),c(ii,1))>1 && lab(r(ii,1),c(ii,1))~=j
                  index=[lab(r(ii,1),c(ii,1))]; 
               end
            end
        end
        NeRegion{j}=index; %��ǰ���������������
        %����ÿһ���뵱ǰ�������ڵ�����
       % for jj=1:length(index)
        %     Ly=double(nL==index(jj));  
         %    mx=mean(mean(Gr.*Lx));
         %    my=mean(mean(Gr.*Ly));
          %   if abs(mx-my)<10
         %       nL(nL==index(jj))=j; 
          %   end
        %end
     end
end

end

