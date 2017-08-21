% Occlusion_bigblock is a script that generates an occlusion that iterates
% all places on the image (no overlap)
% The occlusion covers part of the image

img = imread('Users/cynthiachen/Internship/CNN_heatmap/Unknow_test_paper/Ankle_AP_03.jpeg'); % image file name here
copy = imread('Users/cynthiachen/Internship/CNN_heatmap/Unknow_test_paper/Ankle_AP_03.jpeg');
img = imresize(img, [227 227]);
copy = imresize(copy, [227 227]);
dimensions = size(img);
r = dimensions(1);
c = dimensions(2);
s = 20; % size of occlusion
for i = 1:s:(r-s)
    for j = 1:s:(c-s)
        img(i:(i+s), j:(j+s)) = 0;
        imshow(img) % Call forward propogation here
        pause(1/2) % unneccesary
        img = copy;
    end
end