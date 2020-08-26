function cross = Cross_ParallelLine2(p1list,p2list,codeimg)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cross=[];
[m,n]=size(codeimg);
pnum1=length(p1list);
pnum2=length(p2list);
for i=1:pnum1
    for j=1:pnum2
        aa=p1list{i};
        bb=p2list{j};
        [deg1,vv,rr]=caleig(aa,0.25,0.45);
        [deg2,vv,rr]=caleig(bb,0.25,0.45);
        if deg1>0 && deg2>0 %两条直线，直接求交点
              node = get_crosspoint(aa,bb);
              cross=[cross;node];
           %   hold on 
           %   plot(cross(1),cross(2),'r*');
        elseif deg2==0 && deg1>0 % 两条中有一条是直线
           dirbb=codeimg((bb(:,2)-1)*m+bb(:,1));
           err=abs(dirbb-deg1)< 15;
           cc=bb(err,:);
           node = get_crosspoint(aa,cc);
           cross=[cross;node];
          % hold on 
          % plot(cross(1),cross(2),'r*');
        elseif deg1==0 && deg2>0 % 两条中有一条是直线
           diraa=codeimg((aa(:,2)-1)*m+aa(:,1));
           err=abs(diraa-deg2)< 15;
           cc=aa(err,:);
           node = get_crosspoint(bb,cc);
           cross=[cross;node];
        %   hold on 
         %  plot(cross(1),cross(2),'r*');
        else % 两条都不是直线
           diraa=codeimg((aa(:,2)-1)*m+aa(:,1));
           dirbb=codeimg((bb(:,2)-1)*m+bb(:,1));
           dir=[diraa;dirbb];
           ni=hist(dir,[min(dir):5:max(dir)]);
           [t,ti]=max(ni);
           deg=min(dir)+5*(ti-1);
           err1=abs(diraa-deg)< 15;
           cc=aa(err1,:);
           err2=abs(dirbb-deg)< 15;
           dd=bb(err2,:);
           node = get_crosspoint(cc,dd);
           cross=[cross;node];
        %   hold on 
        %   plot(cross(1),cross(2),'r*');
        end
    end
end

end

