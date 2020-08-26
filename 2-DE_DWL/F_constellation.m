%图像颜色聚类函数
% nI——图像区域颜色归一化图像；
%
function segmented_images=F_constellation(I_rgb)

%I_rgb = nI; %imread('10.jpg');      %读取文件数据
%imshow(I_rgb);                  %显示原图
%figure

%将彩色图像从RGB转化到lab彩色空间
C = makecform('srgb2lab');       %设置转换格式
I_lab = applycform(I_rgb, C);

%进行K-mean聚类将图像分割成3个区域
ab = double(I_lab(:,:,2:3));    %取出lab空间的a分量和b分量
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors =5;        %分割的区域个数为3
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);  %重复聚类次数可改
pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('聚类结果');
figure;

%显示分割后的各个区域
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = I_rgb;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

%imshow(segmented_images{1}), title('分割结果——区域1');figure;
%imshow(segmented_images{2}), title('分割结果——区域2');figure;
%imshow(segmented_images{3}), title('分割结果——区域3');figure;
%imshow(segmented_images{4}), title('分割结果——区域4');figure;
%imshow(segmented_images{5}), title('分割结果——区域5');

    
