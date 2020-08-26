function [edgelist,EDGE,JIMG] = EDPF(image, smoothingSigma)

dim = size(image);
edgelist={};
edgeNo=0;
[m,n,t]=size(image);

EDGE=zeros(m,n);
JIMG=zeros(m,n);

temp = EDPFmex(image, dim(1), dim(2), smoothingSigma);

noOfSegments = size(temp, 1) / 2;

edgeSegments = cell(noOfSegments, 1);

for i = 1:noOfSegments
	edgeSegments{i} = zeros(size(temp{i * 2}, 1), 2);	
    edgeSegments{i}(:,1) = temp{i * 2 - 1};
	edgeSegments{i}(:,2) = temp{i * 2};
    cc=edgeSegments{i};
    EDGE((cc(:,1)-1)*m+cc(:,2))=1;
end
figure
imshow(EDGE);
%cimg=ones(m,n);

%hold on
%plot(CJ(:,1),RJ(:,1),'r*');

%figure
%imshow(JIMG);
for i = 1:noOfSegments
    cc=edgeSegments{i};
   % cimg((cc(:,1)-1)*m+cc(:,2))=0;
   % figure
   % imshow(cimg);
    dd=length(cc);
    k=1;
    k1=1;

    while k<=dd
        W=EDGE(max(1,cc(k,2)-1):min(cc(k,2)+1,n),max(1,cc(k,1)-1):min(cc(k,1)+1,m)); 
        if  sum(sum(W))>=4 && k-k1>2
            edgeNo=edgeNo+1;
            edgelist{edgeNo}=cc(k1:k,:);
            JIMG((cc(:,1)-1)*m+cc(:,2))=edgeNo;
            k1=k+1;
        end
        k=k+1;
    end
    if k1<dd
       edgeNo=edgeNo+1;
       edgelist{edgeNo}=cc(k1:dd,:); 
        JIMG((cc(:,1)-1)*m+cc(:,2))=edgeNo;
    end
    if k1==1
       edgeNo=edgeNo+1;
       edgelist{edgeNo}=cc;
        JIMG((cc(:,1)-1)*m+cc(:,2))=edgeNo;
    end
end
edgeNo


