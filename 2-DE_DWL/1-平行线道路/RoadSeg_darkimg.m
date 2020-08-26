function [darkimg,pixel_labels]=RoadSeg_darkimg(I,dark_size)
win_dark=get_darkimg(double(I)/255,dark_size);
figure, imshow(win_dark);
f = fspecial('gaussian',[dark_size dark_size],10); %高斯模板
img_smooth = imfilter(win_dark,f,'same'); 
figure, imshow(img_smooth);
darkimg=img_smooth;
[cluster_idx cluster_center] = kmeans(img_smooth(:),3);
nrows = size(img_smooth,1);
ncols = size(img_smooth,2);
pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('聚类结果');


