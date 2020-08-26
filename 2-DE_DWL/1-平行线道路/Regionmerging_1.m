% �Ա�Ե���Ӻ��ͼ���������ϲ�
% Gr�����Ҷ�ͼ��
% fBw����ͼ��canny���ؼ������
% Bw����ͼ����ڱ�Ե���Ӻ�����
% L�������ͼ��
% Msize�����ԻҶ�ͼ������и�ʹ����ָ�ͼ���Сһ�µ��и�뾶��
function Bw = Regionmerging_1(Gr,fBw,Bw,L,Msize)
% Bw��������ϲ����ͼ����ؽ����

[M,N] = size(Gr);
%�и�ͼ��ȥ����Ե�˵�
Gr = Gr(Msize:M-Msize,Msize:N-Msize);

fBw = fBw(Msize:M-Msize,Msize:N-Msize);
[nM,nN] = size(Bw);
fBw(:,1) = 1;
fBw(:,nN) = 1;
fBw(1,:) = 1;
fBw(nM,:) = 1;

Conline = Bw-fBw; 

%����������Ե�����
[edgelist,edgeim] = edgelink(Conline,2);   %----���ú���----

num = length(edgelist);
for i = 1:num
    [m,n] = size(edgelist{i});
    if m >= 8   %�߶γ��ȵ��ж�
        x = edgelist{i}(fix(m/2),1);
        y = edgelist{i}(fix(m/2),2);
        Dom = L(x-1:x+1,y-1:y+1);
        ind = find(Dom~=1);
        num1 = length(ind);
        if length(ind) >= 2
            bh1 = Dom(ind(1));
            bh2 = Dom(ind(2));
        else
            continue;
        end
        
        %ȷ���߶����Ե�������
        for j = 3:num1
            if bh1 ~= bh2
                break;
            end
            bh2 = Dom(ind(j));
        end
        sL1 = double(L==bh1);
        Gray1 = double(Gr).*sL1;  %�������
        gray1 = sum(sum(Gray1));
        [x1,y1] = find(L==bh1);
        len1 = length(x1);
        gray1 = fix(gray1/len1);
        
        sL2 = double(L==bh2);
        Gray2 = double(Gr).*sL2;
        gray2 = sum(sum(Gray2));
        [x2,y2] = find(L==bh2);
        len2 = length(x2);
        gray2 = fix(gray2/len2);
        
        if abs(gray1-gray2) <= 10   %��ֵ���Ե���
            for h = 2:m-1  % ������Regionmerging.m �߶����˵㲻ȥ��
                Bw(edgelist{i}(h,1),edgelist{i}(h,2)) = 0;
            end
        end
    end
end

%ȥ���˵�
Bw = Deleteendpoints(Bw);



        