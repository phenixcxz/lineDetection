%ͼ���������ɫ���ɷ���Ϣ
%��á���HSV����ͼ�����������ɫ��
% I����RGBͼ��
% Bw����ͼ��ָ���Ե���ͼ��
function nImg=F_Regioncolor(I,Bw)
% nI��������������ɫ�ʺ��ͼ��

Msize=5;
[nM,nN]=size(Bw);
[nB,nL]=bwboundaries(Bw);
[M,N] = size(I(:,:,1));

HSV = rgb2hsv(I);

%ȥ�������þ����еı�Ե���
for p=1:nM
    for q=1:nN
        if Bw(p,q)==1
            nL(p,q) = 0;
        end    
    end
end

HI = HSV(:,:,1);
SI = HSV(:,:,2);
VI = HSV(:,:,3);

HImage = fix(360*HI);
SImage = fix(100*SI);  %255->100
VImage = fix(100*VI);  %255->100

nI = zeros(nM,nN,3);
num = max(max(nL));  % ͼ�����������
for i=1:num
    sLi = double(nL==i); 
    feikong = find(sLi);
    if feikong~=0
        Hue = double(HImage).*sLi;
        Sat = double(SImage).*sLi;
        Val = double(VImage).*sLi;
        [comH,comS,comV] = FindcomHSV(Hue,Sat,Val); % �����ֵ
        
        nI(:,:,1) = comH(1,1)*sLi+nI(:,:,1);
        nI(:,:,2) = comS(1,1)*sLi+nI(:,:,2);
        nI(:,:,3) = comV(1,1)*sLi+nI(:,:,3);  %������Value
    end      
end
%nI(:,:,3) = VI(Msize:M-Msize,Msize:N-Msize);  %������Value
nImg = hsv2rgb(nI);
