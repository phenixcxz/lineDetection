%��ȡ��Ե���ͼ���е�ƽ������Ϣ
%bw������Ե���ͼ��
function [dislist,Pim]=F_ParaLineDetection(bw)
%dislist����ƽ�����б�
%Pim����ֻ����ƽ���ߵ�ͼ��

[M,N] = size(bw);
T =fix(max(M,N)/5);  %ֱ�߳�����ֵȡͼ��ߴ��20%
Model = {};
win = 41;  % ����ƽ���߼���� ��������Ӱ��ƽ��������
for ii=1:180
    Mv = GenVector(win,ii);
    Model{ii} = uint8(Mv);     
end
Msize = fix(win/2);
bw1 = zeros(M+2*Msize,N+2*Msize);
bw1(Msize+1:M+Msize,Msize+1:N+Msize) = bw;
[edgelist,edgeim,codeimg,dirlist,labelim] = linecoding(bw1,0);
    
%�Ա���ı�Ե���г�������
len = length(dirlist);
dirlen = zeros(len,0);
 for i=1:len
     dirx = dirlist{i};
     dirlen(i,1) = length(dirx);
 end
[t,ix] = sort(dirlen); %�Ա���ı�Ե���г�������
rc = find(t>=T); %ֻ���ǳ��ȴ���T�����ص�����
dislist = {};
paranum = 0;        
pimg = zeros(size(bw1));
for i=rc(1,1):rc(end,1) 
    aa=dirlist{ix(i,1)};
    [PL,pnum,paralist,paraimg] = pca_ParallelLine(aa,dirlist,labelim,codeimg,Model,win);  
    if pnum>0
        paranum = paranum+1;
        dislist{paranum} = PL;  %ƽ�����б�
        pimg = pimg+paraimg;
    end
end 
pL = double(pimg~=0);
pimg = pL.*codeimg;
Pim = pimg(Msize+1:M+Msize,Msize+1:N+Msize);

    




