clear all
close all

im = imread('DSC00126.jpg');
% figure(1),imshow(im);
im1 = im(1:960,2000:3280-1,:);
im2 = im(960:1920-1,2000:3280-1,:);
im3 = im(960*2:960*3-1,2000:3280-1,:);
% figure(2)
% imshow(im2);
% figure(3)
% imshow(im3);
% figure(4)
% imshow(im4);
imwrite(im1,'test04.jpg');
imwrite(im2,'test05.jpg');
imwrite(im3,'test06.jpg');








