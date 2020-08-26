function [flag,fi,a,b,u,w] = is_Segment(aa,fj,v)
x=aa(:,1);
x=flipud(x);
y=aa(:,2);
y=flipud(y);
dd=length(x);
%******************************************************≥ı ºªØ
a=0;
b=1;
w=b;
u=0;
M=[x(1),y(1)];
A=zeros(1,dd);
B=zeros(1,dd);
U=zeros(1,dd);
W=zeros(1,dd);
C1=[x(fj),y(fj)];%¥ÊUL
C2=[x(fj),y(fj)];%¥ÊLl
N=[x(1),y(1)];
flag=1;
i=2;
while flag==1 && i<dd
%********************************************************
%for i=2:1:length(x)-1;
    M=[x(i+1),y(i+1)];  
    r=a*M(1)-b*M(2);
    c1=size(C1,1);
    c2=size(C2,1)
     if r==u;
         Ul=M;   
     end
     if  r==u+w-1;
         Ll=M;  
     end
     if r<=u-1;
         Ul=M;
         C1=[C1;Ul];
         V=C2(end,:)
         if c2==1
            DD=V; 
         end
         if c2>1
         V1 = C2(end-1,:)
         if ((V(2)-V1(2))/(V(1)-V1(1)))>a/b
             DD=V1;
         else
             DD=V;
             N=UU;
         end
         end
         a0=M(2)-N(2);  b0=M(1)-N(1);
         a=a0/gcd(a0,b0); A(i+1)=a;
         b=b0/gcd(a0,b0); B(i+1)=b;
         u=a*x(i+1)-b*y(i+1); U(i+1)=u;
         w=a*DD(1)-b*DD(2)-u+1; W(i+1)=w;         
     else 
       if r>=u+w-1 %symmetrical case
         Ll=M;
         C2=[C2;Ll];
         P=C1(end,:)
         if c1==1;
             UU=P;
         end
         if c1>1
         P1=C1(end-1,:)
         if ((P(2)-P1(2))/(P(1)-P1(1)))<a/b
             Ul=P1;
         else UU=P;N=DD;
         end
         end
         a0=M(2)-N(2);  b0=M(1)-N(1);
         a=a0/gcd(a0,b0); A(i+1)=a;
         b=b0/gcd(a0,b0); B(i+1)=b;
         u=a*UU(1)-b*UU(2);U(i+1)=u;
         w=a*M(1)-b*M(2)-u+1;W(i+1)=w;
       end
     end
     i=i+1;
     if (w-1)/b <= v
         flag=1;
     else
         hold on 
         plot(x(1,1),y(1,1),'r+');
         plot(x(i,1),y(i,1),'r*');   
         flag=0;
     end
   % if i==50
   %     y1=(a*x-u-w+1)/b
%y2=(a*x-u)/b
%hold on
%plot(x,y1);
%plot(x,y2);
%hold on
%Scatter(x,y);
%grid on
end
fi=i-1; 
end