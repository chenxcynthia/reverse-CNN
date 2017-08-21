% given function and image, computes the highest score of all the scores
% assumes that the max score is correct label
function[maxscore] = forwardprop_single(net, meanImage, img)

    %define classes for joint+view
    scores = zeros(1, 13);
    im = img;
    %resizedIm = imresize(im, [256, 256]);
        
    resizedIm = imresize((255*mat2gray(im(:,:,1))), [227, 227]);
    rgbImage = cat(3, resizedIm, resizedIm, resizedIm);
	image =  single(rgbImage - im2double(meanImage));
        
    net.eval({'input',image}) ;
    scores(1,:) = squeeze(net.vars(23).value);
        
    maxscore = max(scores(1,:));
        
        
end

