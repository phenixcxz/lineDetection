%��ʧ����
% Pim����ƽ����ͼ��
function vanpoint = F_VanpointDetection(Pim)
%vanpoint������ʧ������

%ȥ��ˮƽ�ߺʹ�ֱ��
pbw = double(Pim~=0);
[edgelist,edgeim] = edgelink(pbw,2);   %----���ú���----
num = length(edgelist);
for i=1:num
    Tnum = 0;
    aa = edgelist{i};
    len = length(aa(:,1));
    for j=1:len
        Paa = Pim(aa(j,1),aa(j,2));
        if Paa>75 && Paa<89
            Tnum = Tnum+1;  %pbw(aa(j,1),aa(j,2))=0;
        elseif Paa>240 && Paa<=255
                Tnum = Tnum+1; %pbw(aa(j,1),aa(j,2))=0;
        elseif Paa>155 && Paa<=175
                     Tnum = Tnum+1;  %pbw(aa(j,1),aa(j,2))=0;
        end
    end
    if (Tnum/len>0.75) || len<=15
        pbw(aa(:,1),aa(:,2)) = 0;
    end
end
figure;
imshow(pbw);
%imwrite(pbw,'px14.bmp');
figure;

%�������ʧ��
[vanpoint,crossline] = findvanpoint(pbw);
vanpoint = fix(vanpoint);









