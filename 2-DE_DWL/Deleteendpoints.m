% �������ɷ��������߶λ�˵�ȥ��
% bw��������ϲ���ı��ؼ��ͼ��
function Bw=Deleteendpoints(bw)
%Bw���������ı��ؼ��ͼ��

[M,N] = size(bw);
Bw = bw;

num3 = 1;
while num3>0
    
%Ѱ��ͼ��Ķ˵�
[re,ce,num1] = findendspoint(bw,1);   %----���ú���----
%����������Ե�����
[edgelist,edgeim] = edgelink(bw,2);   %----���ú���----

for i=1:num1
    x = re(i,1);
    y = ce(i,1);
    Bw(x,y) = 0;
end

for i=1:num1
    x = re(i,1);
    y = ce(i,1);
    pix = edgeim(x,y); %�˵������������
    pix = uint16(pix);
    [m,n] = size(edgelist{pix});
    x1 = edgelist{pix}(1,1);
    y1 = edgelist{pix}(1,2);
    
    if x1==x && y1==y
        from  = 1;
        step = 1;
        to = m;
    else
        from = m;
        step = -1;
        to = 1;
    end 
    
    for j=from:step:to
        x = edgelist{pix}(j,1);
        y = edgelist{pix}(j,2);
        if x-1>0 && x+1<=M && y-1>0 && y+1<=N 
            Nei = bw(x-1:x+1,y-1:y+1);
            Total = sum(sum(Nei));
            if Total<=2
               Bw(x,y) = 0;
            end
            bw = Bw;
        end
    end
end
%imshow(Bw);
%figure;

%Ѱ��ͼ��Ķ˵�
[re2,ce2,num2] = findendspoint(bw,1);   %----���ú���----
%����������Ե�����
%[edgelist2,edgeim2] = edgelink(bw,2);   %----���ú���----

for i2=1:num2
    x = re2(i2,1);
    y = ce2(i2,1);
    Bw(x,y) = 0;
end
%imshow(Bw);
%figure;

%�����ؼ��ͼ��ȥ������
%Bw = DeleteSingle(Bw,M,N);
Bw = bwmorph(Bw,'clean',1);
%imshow(Bw),title('��ȥ������ı��ؼ��ͼ0');
%figure;

%Ѱ��ͼ��Ķ˵�
[re3,ce3,num3] = findendspoint(Bw,1);   %----���ú���----
%����������Ե�����
%[edgelist2,edgeim2] = edgelink(Bw,2);   %----���ú���----
                                                              
bw = Bw;
end


        
        
        

