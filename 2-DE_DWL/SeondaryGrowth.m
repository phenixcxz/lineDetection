%�������Ե��������Ƚ�
%�����ж�����������ֻ���ӳ�
% Bw
% fbw
function nBw = SeondaryGrowth(Bw,fbw,Msize)
% nBw

nBw = Bw;
[M,N] = size(fbw);
%�и������Ե�����
fbw = fbw(Msize:M-Msize,Msize:N-Msize);
[nM,nN] = size(Bw);
fbw(:,1) = 1;
fbw(:,nN) = 1;
fbw(1,:) = 1;
fbw(nM,:) = 1;

%�������Ե��������Ƚϣ�����������

cbw = fbw-Bw;
%����������Ե�����
[edgelist,edgeim] = edgelink(cbw,2);   %----���ú���----
for i = 1:length(edgelist);
    Elist = edgelist{i};
    len = length(Elist(:,1));
    if len >= 30
        for j=1:len
            Bw(Elist(j,1),Elist(j,2)) = 1; %������ɾ�ĳ�����
        end
    end
end
Bw = bwmorph(Bw,'clean',1);

%������������ֻ���ӳ�
%Ѱ��ͼ��Ķ˵�
[re,ce,num1] = findendspoint(Bw,1);   %----���ú���----
%����������Ե�����
[edgelist,edgeim] = edgelink(Bw,2);   %----���ú���----

for k = 1:num1
    x = re(k,1);
    y = ce(k,1);
    pix = edgeim(x,y);  % ȡ���˵����ڵ��������
    pix = uint16(pix);    %pix = uint8(pix);����
    if pix~=0    
        Elist = edgelist{pix};  % ȡ���˵����ڵ����������б� 
        nBw = BaseDegGrowth(x,y,Bw,Msize,Elist);  % �����ж˵��������
        Bw = nBw;
    end
end
        
