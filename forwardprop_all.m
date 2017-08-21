function [finalscores] = forwardprop_all(net, meanImage)

    %define classes for joint+view
    folder = '/Users/cynthiachen/Internship/CNN_heatmap';
	Class = dir([folder, '/Unknow_test_paper/*.jpeg']);
    scores = zeros(numel(Class), 13);
    finalscores = zeros(numel(Class), 1);
	% loading positive samples
	for i=1:numel(Class)
		im = imread([folder '/Unknow_test_paper/', Class(i).name]);
        filename= [folder '/Unknow_paper_results/', num2str(i),'.png'];
        %resizedIm = imresize(im, [256, 256]);
        
        resizedIm = imresize((255*mat2gray(im(:,:,1))), [227, 227]);
        rgbImage = cat(3, resizedIm, resizedIm, resizedIm);
		image =  single(rgbImage - im2double(meanImage));
        
        net.eval({'input',image}) ;
        scores(i,:) = squeeze(net.vars(23).value);
        
        
        %f = figure(i);
        %set(gcf,'units','normalized','position',[0 0 1 1])
        %imshow(mat2gray(rgbImage));
   
        
        %C = strsplit(Class(i).name,'_');
        %ori_label = strcat(C{1,1}, C{1,2});
        %ori_label = Class(i).name;
        %caption1 = strcat('Original label:', ori_label);
        %caption2 = strcat('Prediction:', class(find(scores(i,:) == max(scores(i,:)))), ' Prob:', num2str(max(scores(i,:))));
        %maxscore =  class(find(scores(i,:) == max(scores(i,:))));
        maxscore =  max(scores(i,:));
        finalscores(i) = maxscore;
        %caption2 = strcat(' Prediction:', ori_label);
        %labels(i) = find(scores(i,:) == max(scores(i,:)));
        %S = {caption1; caption2};
        %title(S);
        %saveas(f, filename, 'png');
        %clear im image resizedIm rgbImage f C;
   end
    
        
        
end

