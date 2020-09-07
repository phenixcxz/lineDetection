clear all
close all
% function [result]=imgFiting(nameJpg)
warning off
lineT=20;
M = 480;
N = 720;
win=31;
Msize=fix(win/2);
 

addpath('./jsonlab-1.5');
resultSave = {20};
for i = 11:20
    mstr = num2str(i);
    nameJpg= ['./data/DSC000',mstr,'.jpg'];
    nameJson = ['./data/DSC000',mstr,'.json'];
    tic
    result2 = imgFiting(nameJpg,lineT,M,N,Msize);
    toc
    testResult = resultTest(result2,nameJson,M,N,Msize);
    resultSave{i-10} = testResult;
%     result2{i-99}=testResult;  
  
end


function [testResult] = resultTest(result2,nameJson,M,N,Msize)

line1 = 'line1';
line2 = 'line2';
testResult =zeros(1,2);

%% 读取标注信息
data=loadjson(nameJson);
multiple = 1920/480;
shapes = data.shapes;
sLength = length(shapes);
points = {sLength};
pointsFlag = zeros(sLength,1);
for i = 1:sLength
    temp = shapes(i);
    points{i} = temp{1,1}.points;
    if temp{1,1}.label == line1
        pointsFlag(i,1) =1;
    else
        pointsFlag(i,1) =2;
    end
end

%% 画出标注图
% img = imread(nameJpg);
% img = imresize(img,[M,N]);
% imGray = rgb2gray(img);

imGray = zeros(M,N);
TP = 0;
FP = 0;
FN = 0;
N = 2*480+4*6*480;
for m = 1:sLength
    line = points{m};
    lineL = length(line);
    for n = 1:lineL-1
        p= polyfit(line(n:n+1,2),line(n:n+1,1),1);
        k = p(1);
        b = round(p(2)/multiple);

        if pointsFlag(m) == 2
            for xx = round(line(n,2)/multiple)+1:round(line(n+1,2)/multiple)
                yy =round(k*xx+b);
                if yy >2 && yy <= N-2
                    imGray(xx,yy-2) = 255;
                    imGray(xx,yy-1) = 255;
                    imGray(xx,yy) = 255;
                    imGray(xx,yy+1) = 255;
                    imGray(xx,yy+2) = 255;
                end
            end
        else
            for xx = round(line(n,2)/multiple):round(line(n+1,2)/multiple)
                yy =round(k*xx+b);
                if yy >1 && yy <= N
                    imGray(xx,yy-1) = 255;
                    imGray(xx,yy) = 255;
                end
            end
        end
    end    
end

for m = 1:length(result2)
    b = result2(m,1)-tan(result2(m,3))*(M/2+Msize);
    for xx = 1:M
        y = round(xx*tan(result2(m,3))+b);
        if y >=1 && y < N-result2(m,2)
            for yy = y:y+result2(m,2)
                if imGray(xx,yy) == 255
                    TP = TP+1;
                else
                    FP = FP +1;
                end    
            end
        end
    end
end 
FN = N-TP;
testResult(1) = TP/(TP+FP);
testResult(2) = TP/(FN+TP);
% figure(1),imshow(imGray);


%     pass = zeros(1,2);
%     for m =1:length(result)
%         dot = result{m};
%         p= polyfit(dot(1:2,1),dot(1:2,2),1);
%         k = p(1);
%         b = p(2);
%         for b1 = b:b+dot(3,2)-dot(2,2)
%             for xx = 1:480
%                 yy = round(k*xx+b1);
%                 if yy >=1 && yy <=N
%                     if test(xx,yy) == 255
%                         pass(1) = pass(1)+1;
%                     else
%                         pass(2) = pass(2)+1;
%                     end
%                         
%                         
%                 end
%             end    
%         end
%     end
%     testResult(1) = pass(1)/(pass(1)+pass(2));
%     testResult(2) = pass(1)/(truth(1)+pass(2));

% figure('Name','数据标注'),imshow(uint8(test));

end
% name = ;

% nameJpg = [name,'.jpg'];
% nameJson = [name,'.json'];