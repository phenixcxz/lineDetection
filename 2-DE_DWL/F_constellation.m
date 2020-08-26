%ͼ����ɫ���ຯ��
% nI����ͼ��������ɫ��һ��ͼ��
%
function segmented_images=F_constellation(I_rgb)

%I_rgb = nI; %imread('10.jpg');      %��ȡ�ļ�����
%imshow(I_rgb);                  %��ʾԭͼ
%figure

%����ɫͼ���RGBת����lab��ɫ�ռ�
C = makecform('srgb2lab');       %����ת����ʽ
I_lab = applycform(I_rgb, C);

%����K-mean���ཫͼ��ָ��3������
ab = double(I_lab(:,:,2:3));    %ȡ��lab�ռ��a������b����
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors =5;        %�ָ���������Ϊ3
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);  %�ظ���������ɸ�
pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('������');
figure;

%��ʾ�ָ��ĸ�������
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = I_rgb;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

%imshow(segmented_images{1}), title('�ָ�����������1');figure;
%imshow(segmented_images{2}), title('�ָ�����������2');figure;
%imshow(segmented_images{3}), title('�ָ�����������3');figure;
%imshow(segmented_images{4}), title('�ָ�����������4');figure;
%imshow(segmented_images{5}), title('�ָ�����������5');

    
