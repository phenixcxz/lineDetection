% ��ֱ�߼��
% codeimg������Ե����ͼ��
function [Vim,Verlist] = F_VerLineDetection(codeimg)
% Vim������ֱ��ͼ��
% VerLlist�����Ƕ�Ϊ80-90��ֱ��Line��Ϣ�б�  ??���⡪����ֱ����Ϣ��������

[M,N] = size(codeimg);
codeimg(1,:) = 0;
codeimg(end,:) = 0;
codeimg(:,1) = 0;
codeimg(:,end) = 0;

pbw = double(codeimg~=0);
Vim = zeros(M,N);
Verlist = {};
[edgelist,edgeim] = edgelink(pbw,2);   %----���ú���----
num = length(edgelist);
j = 1;
for i=1:num
    Tnum = 0;
    aa = edgelist{i};
    len = length(aa(:,1));
    for j=1:len
        Paa = codeimg(aa(j,1),aa(j,2));
        if Paa<190 && Paa>140
            Tnum = Tnum+1;  %pbw(aa(j,1),aa(j,2))=0;
        %elseif Paa>75 && Paa<90
           % Tnum=Tnum+1;
        end
    end
    if (Tnum/len>0.75)
        Vim = Vim+double(edgeim==i);
        Verlist{j} = aa;
        j = j+1;
    end
end




