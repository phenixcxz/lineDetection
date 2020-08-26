%%%%������������ͳ��
%%% nbw--������ͼ�� I--ԭͼ��ĻҶ�ͼ��  Blist--��յı�Ե����
%%%sf ÿ�����������ͳ������������ llist ֱ���б� slist ƽ�������б�   p1list p2listƽ�����б�
%%%vlist�����б� tlist ��·����ƽ�����б�
function [sf,llist,slist,p1list,p2list,vlist,tlist,vim,tim,pim]=F_SelfFeature(nbw,I,Blist)
[m,n]=size(nbw);
lim=zeros(m,n);
sim=zeros(m,n);
pim=zeros(m,n);
vim=zeros(m,n);
tim=zeros(m,n);
num=length(Blist);
sf=zeros(num,8);
llist={};
vlist={}; %�����б�
tlist={}; %��·�������б�
Lt={};
ldeg={};
lnum=0;
vnum=0;
tnum=0;
slist={};
snum=0;
p1list={};
p2list={};
pnum=0;
for i=1:num
    Cim=zeros(m,n);
    aa=Blist{i};
    dd=length(aa);
    Cim((aa(:,2)-1)*m+aa(:,1))=1;
    figure(3)
    imshow(Cim);
    BW2 = imfill(Cim); 
    Cim((aa(:,2)-1)*m+aa(:,1))=0;
    [deg,vv,rr]=caleig(aa,10000,10000); %������
    sf(i,1)=deg;
    %�������
    [dir,dirc]=get_curvecoding(aa,dd,0.25,5);%��Ե�������
    %������
    sf(i,2)=get_OrientationEntropy(dir);
    %�������е�ֱ�ߡ����ߺ�ƽ����
    [Ll,numL]=bwlabel(dirc>0,8);      %%�����������ֱ���
    Ln=0;
    Sn=0;
    Pn=0;
    for k=1:numL
        x=(Ll==k);
        [deg,vv,rr]=caleig(aa(x,:),0.08,0.45);
        if deg>0 && sum(x)>9 %����Ǿ���һ�����ȵ�ֱ�ߣ���¼
         lnum=lnum+1;
         llist{lnum}=aa(x,:);
         Ln=Ln+1;
         Lt{Ln}=aa(x,:);
         ldeg{Ln}=deg-75;
         %��ֱ��
         if abs(deg-75-90)<10
             vnum=vnum+1;
             vlist{vnum}=aa(x,:);
             vim((aa(x,2)-1)*m+aa(x,1))=1;
         elseif abs(deg-75)>15 && abs(deg-75)<165
             tnum=tnum+1;
             tlist{tnum}=aa(x,:);
             tim((aa(x,2)-1)*m+aa(x,1))=1;
         end
         lim((aa(x,2)-1)*m+aa(x,1))=1;
         if Ln>1
            for kk=Ln-1:-1:1
                cdeg=ldeg{kk};
                if abs(cdeg-ldeg{Ln})<15 || abs(cdeg-ldeg{Ln})>165
                    Pn=Pn+1;
                    pnum=pnum+1;
                    p1list{pnum}=aa(x,:);
                    p2list{pnum}=Lt{kk};
                    cc=Lt{kk};
                    pim((aa(x,2)-1)*m+aa(x,1))=1;
                    pim((cc(:,2)-1)*m+cc(:,1))=1;
                end
            end
         end
        elseif sum(x)>9   %����Ǿ���һ�����ȵ�ƽ������,��¼
         snum=snum+1; 
         Sn=Sn+1;
         slist{snum}=aa(x,:);
         sim((aa(x,2)-1)*m+aa(x,1))=1;
        end
    end
    sf(i,3)=Ln;
    sf(i,4)=Sn;
    sf(i,5)=Pn;
    
    %����������
    figure(4)
    imshow(BW2);  
    sLi=double(BW2>0); %����
    Cim=(sLi./255).*double(I);%ÿ�������Ӧ�ĻҶ�
    figure(4)
    imshow(Cim);  
    s1=regionprops(sLi,'centroid');
    s2=regionprops(sLi,'Orientation');
    s3=regionprops(sLi,'BoundingBox'); %��С��Ӿ���
    thita= fix(cat(1,s2.Orientation)+90);%ȡ������
    centroids = fix(cat(1,s1.Centroid));%ȡ����
    Msize=max(s3.BoundingBox(1,3),s3.BoundingBox(1,4));
    if fix(Msize/2)== Msize/2  %���Msize��ż���������Ϊ����
       Msize=Msize+1;
    end
    Wh=fix(Msize/2);
    Mv=GenVector(Msize,thita); %�����ĽǶ�Ϊ�������ֱ�߾��� 
    A=max(centroids(1,1)-Wh,1);
    B=min(centroids(1,1)+Wh,n);
    C=max(centroids(1,2)-Wh,1);
    D=min(centroids(1,2)+Wh,m);
    currM=Cim(C:D,A:B);%�Ҷ�ͼ��������Ϊ���ĵĴ�С��Mv��ͬ
    figure(4)
    imshow(currM);  
    [mm,nn]=size(currM);
    gImg=currM.*Mv(1:mm,1:nn);%ȡ��ֱ���ϵĻҶ�ֵ
    [x,y]=find(gImg>0);
    gray=gImg((y(:,1)-1)*mm+x(:,1));    
  
end
figure(5);
imshow(lim);
figure(6);
imshow(sim);
figure(7);
imshow(pim);  
figure(8);
imshow(vim); 

figure(9);
imshow(tim); 
end