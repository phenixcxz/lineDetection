%%
Bw=imread('392bw.bmp');
[BB,LL]=bwboundaries(Bw);
sLskey=double(LL==340);
sLplane=double(LL==88)+double(LL==90)+double(LL==87);

[m,n]=size(Bw);
vanpoint(1,1)=356;
dep_plane = F_confirmdepth(Bw,vanpoint);
Dep_Plane=dep_plane.*sLplane;

depthimg=zeros(size(Bw));
step=255/n;
idep=255;
for left=1:n
    depthimg(:,left)=idep;
    idep=idep-step;
end

depthimg1=zeros(size(Bw));
step=255/m;
idep=0;
for i=1:m
    depthimg1(i,:)=idep;
    idep=idep+step;
end

Dep_Vertical=depthimg.*~(sLskey+sLplane);

Depthimg=zeros(size(Bw));
Depthimg=Dep_Vertical+Dep_Plane;
imshow(uint8(Depthimg));



%%
Bw=imread('391bw.bmp');
[BB,LL]=bwboundaries(Bw);
sLskey=double(LL==58);
sLplane=double(LL==76)+double(LL==78);
[m,n]=size(Bw);
vanpoint(1,1)=356;
dep_plane = F_confirmdepth(Bw,vanpoint);
Dep_Plane=dep_plane.*sLplane;

depthimg=zeros(size(Bw));
step=255/n;
idep=255;
for right=n:-1:1
    depthimg(:,right)=idep;
    idep=idep-step;
end

Dep_Vertical=depthimg.*~(sLskey+sLplane);
Depthimg=zeros(size(Bw));
Depthimg=Dep_Vertical+Dep_Plane;
imshow(uint8(Depthimg));