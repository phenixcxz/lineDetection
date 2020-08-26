clear all
close all

warning off
im=imread('test01.JPG');
lineT=10;
im = imresize(im,[480,640]);

figure('Name','缩略图'),imshow(im);

% imHsv=rgb2hsv(im);
% imwrite(imHsv,'1imHsv.jpg');
% 
% Img=rgb2gray(imHsv);
% imwrite(Img,'1grayImg.jpg');

Img=im(:,:,3);
figure('Name','灰度图'), imshow(Img);

[m,n] = size(Img);
threshold = 30
im2 = zeros(m,n);
for i = 3:m-2
    for j = 3:n-2
        im2(i,j) = LTP(Img,i,j,threshold,2);
    end
end

figure('Name','LTP'), imshow(im2);
