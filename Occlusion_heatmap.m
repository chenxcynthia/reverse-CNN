% VERSION 3 (final):
% Script for generating a heat map for a pre-trained CNN and an image
% Iterates over many places where the occlusion can be placed
% Covers part of the image with the occlusion
% Generates the score with the occlusion placed and finds the difference in
% scores

filename = 'Users/cynthiachen/Internship/CNN_heatmap/Unknow_test_paper/Elbow_Lateral_02.jpeg'; 
img = imread(filename); % image file name here
copy = imread(filename);
img = imresize(img, [227 227]);
copy = imresize(copy, [227 227]);
r = 227;
c = 227;
s = 40; % size of square occlusion
delta = 2; % controls heatmap pixel size
diff = zeros(r, c, 2);
load('imageDB.mat');
load('model1.mat');
meanImage = uint8(Images.images.data_mean);
meanImage = meanImage(:, :, 1)

for i = 1:delta:(r-s)
    for j = 1:delta:(c-s)
        img(i:(i+s), j:(j+s)) = 0;
        score = forwardprop_single(info1, meanImage, img); % forward propogation, finds specific score
        for k = i:(i+s)
            for l = j:(j+s)
                diff(k, l, 2) = diff(k, l, 2) + 1;
                diff(k, l, 1) = (diff(k, l, 1) * (diff(k, l, 2) - 1) + 1 - score) / diff(k, l, 2);
            end
        end
        img = copy;
    end
end

final = diff(:, :, 1);
final = (final-min(final(:))) ./ max(final(:));
final = final .* (255/max(final(:)));
figure, imagesc(final)
colormap jet