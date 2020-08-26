
%检测边缘图像直线中的平行线和矩形，linelist--直线列表,labeledline--直线标号图像 Model--线条模板 win--模板窗口
%paralist -- 平行线列表
function   [PL,pnum,paralist,paraimg] = pca_ParallelLine(aa,dirlist,labeldir,codeimg,Model,win) %只考虑封闭线条
[m,n] = size(codeimg);
paralist = {};
PL = 0;
pnum = 0;
paraimg = zeros(m,n);
x1 = aa(1,1);
y1 = aa(1,2);
x2 = aa(end,1);
y2 = aa(end,2);
%不考虑边缘点
Msize = fix(win/2);
if x1<=Msize || y1<=Msize || x1>(m-Msize) || y1>(n-Msize)
   return;            
end
if x2<=Msize || y2<=Msize || x2> (m-Msize) || y2>(n-Msize)
   return;            
end  
%判断端点1    
p1 = codeimg(x1,y1);
currM1dir = labeldir(x1-Msize:x1+Msize,y1-Msize:y1+Msize);
if p1-75 > 0
   M1 = Model{p1-75};
   XX1 = double(M1).*currM1dir;
   [PL1,paraimg,paralist,index1] = get_ParaLabel(XX1,aa,dirlist,codeimg,paraimg,1);
   if index1 > 0
      pnum = pnum+1;
      PL = PL1;
   else
      %判断端点2
      p2 = codeimg(x2,y2);
      currM2dir = labeldir(x2-Msize:x2+Msize,y2-Msize:y2+Msize);
      if p2-75 > 0
         M2 = Model{p2-75};
         XX2 = double(M2).*currM2dir;
         [PL2,paraimg,paralist,index2] = get_ParaLabel(XX2,aa,dirlist,codeimg,paraimg,2);
         if index2 > 0
            pnum = pnum+1;
            PL = PL2;
         else
            pnum = 0;
         end 
      end
   end
end


