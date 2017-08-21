function [scores] = forwardprop_correct(net, meanImage, class, img, filename)

    %folder = '/Users/cynthiachen/Internship/CNN_heatmap/';
	%Class = dir([folder, '/Unknow_test_paper/*.jpeg']);
    scores = zeros(1, 13);
	
    im = img;
    %filename= [folder '/Unknow_paper_results/', num2str(i),'.png'];
    resizedIm = imresize((255*mat2gray(im(:,:,1))), [227, 227]); %resize/recolor image
    rgbImage = cat(3, resizedIm, resizedIm, resizedIm);
    image =  single(rgbImage - im2double(meanImage));

    net.eval({'input',image});
    scores(1,:) = squeeze(net.vars(23).value);

    C = strsplit(filename,'_');
    ori_label = strcat(C{1,1}, C{1,2});
    %ori_label = Class(i).name;
    caption1 = strcat('Original label:', ori_label);
    caption2 = cell2mat(strcat('Prediction:', class(find(scores(1,:) == max(scores(1,:)))), ' Prob:', num2str(max(scores(1,:)))));
    maxscore =  class(find(scores(1,:) == max(scores(1,:))));
    %caption2 = strcat(' Prediction:', ori_label);
    S = {caption1; caption2};
    title(S);
    %saveas(f, filename, 'png');
    %clear im image resizedIm rgbImage f C;
    
        
        
end

