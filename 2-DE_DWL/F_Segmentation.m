%%%%���ڱ�Ե������ͼ��ָ� Blist--��ձ�Ե�б�

function [nBw,L1,Blist]=F_Segmentation(I)

%I = imread('j75.jpg'); 

gr = rgb2gray(I);
Gr = double(gr);       % uint8ת��Ϊdouble����
[M,N] = size(Gr);

%imwrite(Gr,str2,'bmp');

%canny���ӱ��ؼ��
bw = edge(Gr,'canny');
bw = bwmorph(bw,'clean',1);  %�����ؼ��ͼ��ȥ������
%imshow(bw),title('canny���ؼ��ͼ');
%figure;

%imwrite(bw,str3,'bmp');

fbw=bw;

%Ѱ��ͼ��Ķ˵�
[re,ce,num1] = findendspoint(bw,1);   %----���ú���----
%����������Ե�����
[edgelist,edgeim] = edgelink(bw,2);   %----���ú���----

Msize = 5;

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
            
            bw = nbw;
            Dd(x-Msize:x+Msize,y-Msize:y+Msize) = newDd;
        end
    end
end

%�и�ͼ��ȥ����Ե�˵�
bw = bw(Msize:M-Msize,Msize:N-Msize);
[nM,nN] = size(bw);
bw(:,1) = 1;
bw(:,nN) = 1;
bw(1,:) = 1;
bw(nM,:) = 1;
%imshow(bw),title('�и��ͼ��1');
%figure;

%imwrite(bw,str4,'bmp');

%���
[B,L] = bwboundaries(bw);
%����ϲ�
Bw=Regionmerging(gr,fbw,bw,L,Msize);  

%imshow(Bw),title('����ϲ����Ե���ͼ');
%figure;

nBw = SeondaryGrowth(Bw,fbw,Msize);
nBw=Regionmerging_1(gr,fbw,nBw,L,Msize);  
%imwrite(nBw,str5,'bmp');

bbw=zeros(M,N);
bbw(Msize:M-Msize,Msize:N-Msize)=nBw;
nBw=bbw;
%���
[Blist,L1] = bwboundaries(nBw);
Wei = label2rgb(L1, @jet, 'r','shuffle');
%imwrite(Wei,str6,'bmp');


