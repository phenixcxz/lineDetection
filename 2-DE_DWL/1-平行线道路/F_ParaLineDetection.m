%��ȡ��Ե���ͼ���е�ƽ������Ϣ
%bw������Ե���ͼ��
%PLabel--�໥ƽ�е��߱��һ��
%Labelim--ƽ���߱��ͼ���Plistһһ��Ӧ
function [dislist,Pim,RoadRegion,Plist,PLabel,Labelim]=F_ParaLineDetection(EDGE,codeimage,dirlist,labim)
%dislist����ƽ�����б�
%Pim����ֻ����ƽ���ߵ�ͼ��

[M,N] = size(EDGE);
T =fix(max(M,N)/5);  %ֱ�߳�����ֵȡͼ��ߴ��20%
Model = {};
win = 81;  % ����ƽ���߼���� ��������Ӱ��ƽ��������
for ii=1:180
    Mv = GenVector(win,ii);
    Model{ii} = uint8(Mv);     
end
Msize = fix(win/2);
%���µ���ͼ���С
codeimg = zeros(M+2*Msize,N+2*Msize);
codeimg(Msize+1:M+Msize,Msize+1:N+Msize) = codeimage;
labelim = zeros(M+2*Msize,N+2*Msize);
labelim(Msize+1:M+Msize,Msize+1:N+Msize) = labim;
 
%figure
%imshow(uint8(codeimg));
Vimg=(codeimg>150) .* (codeimg<180);
[down,up,RoadRegion]=get_V_convex(Vimg);%��ֱ�߰����Լ���·����
%figure
%imshow(RoadRegion);
%�Ա���ı�Ե���г�������
len=length(dirlist);
dirlen=zeros(len,0);
for i=1:len
    dirx=dirlist{i};
    dirx=dirx+Msize;%����ȷ������λ��
    dirlist{i}=[dirx(:,2) dirx(:,1)];
    dirlen(i,1)=length(dirx);
end
[t,ix]=sort(dirlen); %�Ա���ı�Ե���г�������
rc=find(t>=10); %ֻ���ǳ��ȴ���10�����ص�����
dislist=[];
paranum=0;        
pimg=zeros(M+2*Msize,N+2*Msize);
crosspoint=[];
paralist={};
p1list={};
p1num=0;
p2num=0;
p2list={};
pl=0;

PLabel=zeros(M,N);
Labelim=zeros(M,N);
Plist={};
pmimg=zeros(M,N);
for i=rc(1,1):rc(end,1) 
    pnimg=zeros(M+2*Msize,N+2*Msize);
    aa=dirlist{ix(i,1)};
    pnimg((aa(:,2)-1)*(M+2*Msize)+aa(:,1))=1;
    pmimg((aa(:,2)-Msize-1)*M+aa(:,1)-Msize)=1;
    flag0=sum(sum(pmimg.*PLabel));
    flag=sum(sum(RoadRegion.*pnimg));
    pmimg((aa(:,2)-Msize-1)*M+aa(:,1)-Msize)=0;
    if flag>0  && flag0==0  %�����ڵ�·������ ���ҵ�ǰ���������Ѽ���ƽ�����ཻ
          [PL,pnum,paralist,paraimg]=pca_ParallelLine(aa,dirlist,labelim,codeimg,Model,win); 
          if pnum>0
              pl=pl+1;
             % PLable{pl}=PL;%��¼��ȡ��ƽ���ߵı��
              dir=[];
              for jj=1:length(paralist)
                  tt=paralist{jj};
                  dirtt=codeimg((tt(:,2)-1)*(M+2*Msize)+tt(:,1));
                  dir=[dir;dirtt];
                  paranum=paranum+1;  
                  Plist{paranum}=tt-Msize;
                  Labelim((tt(:,2)-Msize-1)*M+(tt(:,1)-Msize))=paranum;
                  if PLabel((tt(1,2)-Msize-1)*M+(tt(1,1)-Msize))==0
                     PLabel((tt(:,2)-Msize-1)*M+(tt(:,1)-Msize))=pl;
                  end
                  dislist=[dislist;length(tt)];
              end
              sh=double(dir>83)+double(dir<247);%ˮƽ��
              indexh=sum(double(sh==2))/length(dir);
              sv=double(dir>155)+double(dir<175); %��ֱ��
              indexv=sum(double(sv==2))/length(dir);
              if indexh>0.5 && indexv<0.5 %��ˮƽ�ʹ�ֱ��ƽ����
                  %ȷ�����ִ������ķ���,���ݴ˷���ƽ���߷�Ϊ2��
                 ni=hist(dir,[min(dir):5:max(dir)]);
                 [t,ti]=max(ni);
                 deg=min(dir)+5*(ti-1);
                 if deg-75<90
                      for jj=1:length(paralist) 
                           p1num=p1num+1;
                           p1list{p1num}=paralist{jj};
                      end                    
                 else
                       for jj=1:length(paralist) 
                           p2num=p2num+1;
                           p2list{p2num}=paralist{jj};
                       end   
                 end
              %   cross = Cross_ParallelLine(paralist,codeimg);
            %     crosspoint=[crosspoint;cross];

                 pimg=pimg+paraimg;
              end
          end
      % end
    end
end
%cross = Cross_ParallelLine2(p1list,p2list,codeimg);
%crosspoint=[crosspoint;cross];
Pim = double(pimg>0);
RoadRegion=RoadRegion(Msize+1:M+Msize,Msize+1:N+Msize);
Pim =Pim(Msize+1:M+Msize,Msize+1:N+Msize);

%hold on
%plot(crosspoint(:,1),crosspoint(:,2),'r*');
%hold off
%[vpx,vpy] = get_vanishingpoint(crosspoint,M);
%hold on
%plot(vpx,vpy','+','color','g');


  


    




