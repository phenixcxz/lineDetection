%%%%���ڱ�Ե������ͼ��ָ� Blist--��ձ�Ե�б�
%ix ������ɴ�С�����������
function [nbw,nL,LC,Blist,ix]=F_Segmentation(bw,edgeSegments,Gr)
Msize = 5;
[M,N] = size(Gr);
edgelist={};
edgeim=zeros(M,N);
for i = 1:length(edgeSegments)
    aa=edgeSegments{i};
    edgeim((aa(:,1)-1)*M+aa(:,2))=i;
    edgelist{i}=[aa(:,2),aa(:,1)];
end
fbw=bw;
%Ѱ��ͼ��Ķ˵�
[re,ce,num1] = findendspoint(bw,0);   %----���ú���----

%���ɹ����˵�ͼ��
Dd = zeros(M,N);
for i =1:num1
   Dd(re(i,1),ce(i,1)) = 1;
end

for k=1:num1
    x = re(k,1);
    y = ce(k,1);
    if Dd(x,y)==1 && x-Msize>0 && y-Msize>0 && x+Msize<=M && y+Msize<=N      % �Ǳ߽�˵�
        pix = edgeim(x,y);  % ȡ���˵����ڵ��������
        pix = uint16(pix);    %pix = uint8(pix);����
        if pix~=0    
            Elist = edgelist{pix};  % ȡ���˵����ڵ����������б� 
            [nbw,newDd] = BaseOptRouGrowth(x,y,Dd,bw,Gr,Msize,Elist);  %ѡ���ۼ��ݶ����ֵ��Ϊ����·��         
            num=sum(sum(nbw-bw));
            if num>30
                bw=bw;
            else
               bw = nbw;
            end
            Dd(x-Msize:x+Msize,y-Msize:y+Msize) = newDd; 
        end
    end

end

%Ѱ��ͼ��Ķ˵�
%[re,ce,num1] = findendspoint(bw,0);   %----���ú���----
%����������Ե�����
%[edgelist,edgeim] = edgelink(bw,2);   %----���ú���----

%for k = 1:num1
 %   x = re(k,1);
 %   y = ce(k,1);
  %  pix = edgeim(x,y);  % ȡ���˵����ڵ��������
   % pix = uint16(pix);    %pix = uint8(pix);����
  %  if pix~=0    
    %    Elist = edgelist{pix};  % ȡ���˵����ڵ����������б� 
     %   nBw = BaseDegGrowth(x,y,bw,Msize,Elist);  % �����ж˵��������
     %   num=sum(sum(nBw-bw));
      %  if num>30
      %          bw=bw;
       % else
       %        bw = nBw;
       % end
    %end
%end

%�и�ͼ��ȥ����Ե�˵�
bw = bw(Msize:M-Msize,Msize:N-Msize);
[nM,nN] = size(bw);
bw(:,1) = 1;
bw(:,nN) = 1;
bw(1,:) = 1;
bw(nM,:) = 1;

%���
[Blist,L] = bwboundaries(bw);
%����ϲ�
%Bw=Regionmerging(Gr,fbw,bw,L,Msize);  

%imshow(Bw),title('����ϲ����Ե���ͼ');
%figure;
%���
%[Blist,L] = bwboundaries(Bw);
%LC= label2rgb(L1, @jet, 'r','shuffle');
%figure
%imshow(LC)

%nBw = SeondaryGrowth(Bw,fbw,Msize);
%nBw=Regionmerging_1(Gr,fbw,nBw,L,Msize);  
%���
%[Blist,L] = bwboundaries(nBw);
stats = regionprops(L, 'Area');
allArea = [stats.Area];
[B,ix]=sort(allArea,'descend');

nbw=zeros(M,N);
nbw(Msize:M-Msize,Msize:N-Msize)=bw;
nL=zeros(M,N);
nL(Msize:M-Msize,Msize:N-Msize)=L;
%NeRegion = find_neighborRegion( nL,ix );
LC= label2rgb(nL, @jet, 'r','shuffle');
figure
imshow(LC)
