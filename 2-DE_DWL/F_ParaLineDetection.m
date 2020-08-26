%获取边缘检测图像中的平形线信息
%bw——边缘检测图像；
function [dislist,Pim]=F_ParaLineDetection(bw)
%dislist——平行线列表；
%Pim——只包含平行线的图像；

[M,N] = size(bw);
T =fix(max(M,N)/5);  %直线长度阈值取图像尺寸的20%
Model = {};
win = 41;  % 决定平形线间距离 ？？？？影响平行线数量
for ii=1:180
    Mv = GenVector(win,ii);
    Model{ii} = uint8(Mv);     
end
Msize = fix(win/2);
bw1 = zeros(M+2*Msize,N+2*Msize);
bw1(Msize+1:M+Msize,Msize+1:N+Msize) = bw;
[edgelist,edgeim,codeimg,dirlist,labelim] = linecoding(bw1,0);
    
%对编码的边缘进行长度排序
len = length(dirlist);
dirlen = zeros(len,0);
 for i=1:len
     dirx = dirlist{i};
     dirlen(i,1) = length(dirx);
 end
[t,ix] = sort(dirlen); %对编码的边缘进行长度排序
rc = find(t>=T); %只考虑长度大于T个像素的线条
dislist = {};
paranum = 0;        
pimg = zeros(size(bw1));
for i=rc(1,1):rc(end,1) 
    aa=dirlist{ix(i,1)};
    [PL,pnum,paralist,paraimg] = pca_ParallelLine(aa,dirlist,labelim,codeimg,Model,win);  
    if pnum>0
        paranum = paranum+1;
        dislist{paranum} = PL;  %平行线列表
        pimg = pimg+paraimg;
    end
end 
pL = double(pimg~=0);
pimg = pL.*codeimg;
Pim = pimg(Msize+1:M+Msize,Msize+1:N+Msize);

    




