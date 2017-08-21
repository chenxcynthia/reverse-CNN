% VERSION 4 (general):
% Script for generating a heat map for a pre-trained CNN and an image
% Iterates over many places where the occlusion can be placed
% Covers part of the image with the occlusion
% Generates the score with the occlusion placed and finds the difference in
% scores

folder = 'Users/cynthiachen/Internship/CNN_heatmap/Unknown_test/';
filename = 'Elbow_Lateral_08.jpeg';
fullname = strcat(folder, filename);
img = imread(fullname); % image file name here
copy = imread(fullname);
img = imresize(img, [227 227]);
copy = imresize(copy, [227 227]);
r = 227;
c = 227;
s = 40; % size of square occlusion
delta = 5; % controls heatmap pixel size
diff = zeros(3, r, c, 2);
load('imageDB.mat');
load('model1.mat');
meanImage = uint8(Images.images.data_mean);
classdesc = Images.meta.description;

actualscores = forwardprop_correct(info1, meanImage, classdesc, img, filename);
if max(actualscores) > 0.9 
    Occlusion_heatmap
else
    C = strsplit(filename,'_');
    truelabel = strcat(C{1,1}, C{1,2}); % finds what true label is
    top3 = zeros(3, 2);
    for a = 1:3
        top3(a, 1) = find(actualscores == max(actualscores));
        top3(a, 2) = max(actualscores);
        actualscores(top3(a, 1)) = 0;
    end

    for i = 1:delta:(r-s)
        for j = 1:delta:(c-s)
            img(i:(i+s), j:(j+s)) = 0;
            scores = forwardprop_correct(info1, meanImage, classdesc, img, filename); % finds scores for all classes
            scores2 = zeros(3);
            actualscores2 = zeros(3);
            for k = 1:3
                scores2(k) = scores(int16(top3(k, 1)));
                actualscores2(k) = actualscores(int16(top3(k, 1)));
            end
            
            for k = i:(i+s)
                for l = j:(j+s)
                    for m = 1:3
                        diff(m, k, l, 1) = (diff(m, k, l, 1) * (diff(m, k, l, 2)) + actualscores2(m) - scores2(m)) / (diff(m, k, l, 2) + 1);
                        diff(m, k, l, 2) = diff(m, k, l, 2) + 1;
                    end
                end
            end
            img = copy;
        end
    end

    final = diff(:, :, :, 1);
    
    figure, 
    ax1 = subplot(2, 3, 2); 
    imshow(img), title('Original image')
    colormap(ax1,bone)
    
    for i = 1:3
        ax2 = subplot(2, 3, i + 3); 
        imagesc(squeeze(final(i, :, :))), title(strcat('Heat map', num2str(i), sprintf('\nPrediction:'), ' ', classdesc(int16(top3(i, 1))), ... 
            sprintf('\nProbability:'), num2str(top3(i, 2))))
        colormap(ax2,jet)
    end

end