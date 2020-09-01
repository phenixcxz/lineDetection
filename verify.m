close all;
clear all;
M = 480;
N = 720;
Msize = 15;


addpath('./jsonlab-1.5');
data=loadjson('DSC00101.json');
multiple = 1920/480;
shapes = data.shapes;
sLength = length(shapes);
points = {6};
for i = 1:6
    temp = shapes(i);
    points{i} = temp{1,1}.points;
end

result = {sLength};
for i = 1:6
   temp = points{i};
%    slope = zeros(1,4);
   p1 = polyfit(temp(1:2,2),temp(1:2,1),1);
   p2 = polyfit(temp(3:4,2),temp(3:4,1),1);
   
   slope1 = atan(p1(1));
   slope2 = atan(p2(1));
   startdot1 = round(p1(2)/multiple);
   startdot2 = round(p2(2)/multiple);
    if slope1 < 0
        slope1 = pi+slope1;
    end
    if slope2 < 0
        slope2 = pi+slope2;
    end
    slope = (slope1+slope2)/2;
    devote = zeros(1,4);
    devote(1,1) = startdot1;
    devote(1,2) = startdot2;
    devote(1,4) = slope;
    result{i} = devote;
end

% 
img = zeros(M+Msize*2,N+Msize*2);
% 
% 
% p = polyfit(points(1,2),points(1:2,1),1);
% 
% slope(1) = atan(p(1));
% if slope(1,1) < 0
%     slope(1,1) = pi+slope(1,1);
% end
% slope(1,2) = round(p(2))/multiple;       %起始点
% % for 1= M+Msize
% %     for n = 1:N+Nsize;
for m = 1:sLength
    slope = result{m};
    for n = slope(1,1):slope(1,2)
        for xx = Msize:Msize+M
            yy = round(xx*tan(slope(1,4))+n);
            if yy >=1 && yy < N+Msize
                img(xx,yy) = 255;
            end
        end
    end
end

figure('Name','直线拟合3'),imshow(uint8(img));


