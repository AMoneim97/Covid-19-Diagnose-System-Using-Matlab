%% DOCUMENT TITLE
% INTRODUCTORY TEXT
%
% Presented by: 
%         Name: Ahmad AbdalMoneim Shehata Mohamed 
%         Name: Ahmed Gamal Awad Tolba 
%         Name: Ahmed Yehia Zakaria
%
% Supervised by: 
%           Dr.: Mohamed Torad
%
% College: Engineering
% Department: Electrical Engineering & Computers Department
% Institute: Higher Technological Institute 10th of Ramadan
%
%
%
%
% CODE STARTS.
%% SECTION1: DISPLAYING THE  MENU MESSAGE %%
choice  =  menu('Do you want to analyze The images Automatic or Manual?','Automatic','Manual');
global folder fontSize
folder = uigetdir(path);
fontSize = 16;
%=====================================================================================================================
%=====================================================================================================================
                                      %%%%%%%%%%%% Automatic Part %%%%%%%%%%%%
%=====================================================================================================================
%=====================================================================================================================
if choice == 1
    %for k=1:10
        %pause(5);
    f=dir(fullfile(folder,'*.jpg'));
    for k=1:numel(f)        
        filename{k}=fullfile(folder,f(k).name);
        OriginalImage = imread(filename{k});
        OriginalImage = imresize(OriginalImage,[512 512]); % Resize the dimensions of the image.
        [rows, columns, numberOfColorBands] = size(OriginalImage);  % numberOfColorBands should be = 1.
        if numberOfColorBands > 1 % Start of if condition.
            grayImage = OriginalImage(:, :, 2);  % Convert it to gray scale by taking only the green channel.
        end  % End of if condition.
        pause(.6);
        %% SECTION4: THRESOLDING ADJUSTMENT %%
        mask = grayImage > 0 & grayImage < 255;  % Binarize(grayImage);
        thresholdValue = 255 * graythresh(grayImage(mask)); % Label the regions for the two body zones.
        binaryImage = grayImage < thresholdValue; % Apply the thresholding.
        binaryImage = imclearborder(binaryImage);  % Get rid of stuff touching the border.
        binaryImage = bwareafilt(binaryImage, 2); % Extract only the two largest blobs.
        binaryImage = imfill(binaryImage, 'holes'); % Fill holes in the blobs to make them solid.
        maskedImage = grayImage; % Mask image with lungs-only mask.
        maskedImage(~binaryImage) = 0; % This will produce a gray scale image in the lungs and black everywhere else.
        pause(.6);
        %% SECTION5: SEGMENTATION BY CUSTRING %%
        [L,Centers] = imsegkmeans(maskedImage,3);  % Segment the image into 3 regions.
        im = labeloverlay(maskedImage,L); % Overlay label matrix regions on 2-D image
        cform = makecform('srgb2lab'); % Create color transformation structure Useing rgb2lab to convert the RGB white value to CIE 1976 L*a*b* values.
        lab_im = applycform(im,cform); %  converts the color values in (im) to the color space specified in the color transformation structure (cform).
        ab = double(lab_im(:,:,2:3));  % converts the values in (lab_im) to double precision.
        nrows = size(ab,1); % Returns the length of dimension dim (1) of (ab).
        ncols = size(ab,2); % Returns the length of dimension dim (2) of (ab).
        ab = reshape(ab,[nrows*ncols,2]); % Reshape (ab) into a [(nrows*ncols)rows , 2column]
        nColors = 3; % Segment the image into 3 regions with different colors.
        % repeat the clustering 5 times to avoid local minima
        [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
            'Replicates',3); % Partition the data into (3)clusters(nColors), and choose the best arrangement out of (3)initializations.
        pixel_labels = reshape(cluster_idx,nrows,ncols); % Reshape (pixel_labels) into a [(cluster_idx)rows , (ncols)column].
        segmented_images = cell(1,5); % returns a (1) by (5) cell array of empty matrices.
        rgb_label = repmat(pixel_labels,[1 1 3]); %  Returns an array containing [1 1 3] copies of (pixel_labels) in the row and column dimensions of (rgb_label).
        for j = 1:nColors     % Start of for loop.
            color = im; % Color variable equals Overlay label matrix regions on 2-D image
            color(rgb_label ~= j) = 0;    % Any region except rgb_label equal it to zero
            segmented_images{j} = color;  % Put the (segmented_images) array vlaues into variable(K) array, whereas k = 1:nColors.
        end                    % End of for loop.
        pause(.6);
        %% SECTION6: ISOLATION OF NORMAL PARTS %%
        
        coloredLabels = label2rgb (binaryImage, 'hsv', 'k', 'shuffle'); % Specifies the colormap cmap to be used in the RGB image, (hsv) means Hue Saturation Value (K) means Black color, (shuffle) to assigns colormap colors pseudorandomly.
        blobMeasurements = regionprops(binaryImage,maskedImage, 'all');  % Measure properties of image regions, (all) to computes all the shape measurements.
        numberOfBlobs = size(blobMeasurements, 1); % Returns the length of dimension dim (1) of (blobMeasurements).
        axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
        hold on;    % Retains plots in the current axes so that new plots added to the axes do not delete existing plots.
        boundaries = bwboundaries(binaryImage);  % Traces the exterior boundaries of lungs in (binaryImage).
        numberOfBoundaries = size(boundaries, 1); % Returns the length of dimension dim (1) of (boundaries).
        for j = 1 : numberOfBoundaries           % Start of for loop.
            thisBoundary = boundaries{j};  % Put the (boundaries) array vlaues into (j) array, whereas j = 1 : number of lungs.
            %plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2); % Plot a green borders around the lungs.
        end      % End of for loop.
        hold off;  %  Sets the hold state to off so that new plots added to the axes clear existing plots and reset all axes properties
        pause(.6);
        %% SECTION7: PRE-CALCULATION OF hole lungs AREAS %%        
        for j = 1 : numberOfBlobs           % Start of for loop, Loop through all infected parts.
            % directly into regionprops.  The way below works for all versions including earlier versions.)
            thisBlobsPixels = blobMeasurements(j).PixelIdxList;  % Get list of pixels in current blob.
            meanGL = mean(binaryImage(thisBlobsPixels)); % Find mean intensity of labeled normal parts.
            blobArea = blobMeasurements(j).Area;		% Get area of labeld normal parts.
            hole_lungs_area(j)= blobArea;  % Put the valus of normal parts into variable(normal_areas).
        end % End of for loop.
        pause(.6);
        %% SECTION8: ISOLATION OF INFECTED PARTS %%
        gray_img = rgb2gray(segmented_images{3}); % Converts the truecolor image (segmented_images{3}) to the grayscale intensity image (gray_img).
        blobMeasurements = regionprops(gray_img,gray_img, 'all'); % Measure properties of image regions, (all) to computes all the shape measurements.
        numberOfBlobs = size(blobMeasurements, 1); % Returns the length of dimension dim (1) of (blobMeasurements).
        axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
        hold on;  % Retains plots in the current axes so that new plots added to the axes do not delete existing plots.
        boundaries = bwboundaries(gray_img); % Traces the exterior boundaries of lungs in (gray_img).
        numberOfBoundaries = size(boundaries, 1);  % Returns the length of dimension dim (1) of (boundaries).
        for r = 1 : numberOfBoundaries       % Start of for loop.
            thisBoundary = boundaries{r};  % Put the (boundaries) array vlaues into (r) array, whereas r = 1 : number of infected parts.
            % plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);  % Plot a green borders around the infected parts.
        end    % End of for loop.
        hold off;  %  Sets the hold state to off so that new plots added to the axes clear existing plots and reset all axes properties
        pause(.6);
        %% SECTION9: PRE-CALCULATION OF INFECTED PARTS AREAS %%       
        for r = 1 : numberOfBlobs           % Start of for loop, Loop through all infected parts.
            thisBlobsPixels = blobMeasurements(r).PixelIdxList;  % Get list of pixels in current blob.
            meanGL = mean(gray_img(thisBlobsPixels)); % Find mean intensity of labeled infected parts.
            blobArea = blobMeasurements(r).Area;		% Get area of labeld infected parts.
            infected_areas(r)=blobArea;  % Put the valus of infected parts into variable(infected_areas).
        end   % End of for loop.
        pause(.6);
        %% SECTION10: AREA CALCULATION %%        
        a1 = sum(infected_areas(1,:));  % Sum of infected areas.
        a2 = sum(hole_lungs_area(1,:));    % Sum of hole lungs area.
        a3 = a2 - a1;                   % Sum of normal areas.
        p_a = 0;
        p_a = (a1 / a2)*100 ;     % Percentage of infection.
        subplot(3, 4, k);
        imshow(maskedImage, []);
        text(20,450,sprintf('Infection percentage\n      = %0.2f%%',p_a),'Color','g','FontSize',10)
        axis on;
        title("Masked Lung Layer "+k, 'FontSize', fontSize);
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % Enlarge figure window to full screen.
        total_ratio{k}= p_a;
        sum_total_ratio = 0; % Initialize
        for r = 1 : length(total_ratio)
            sum_total_ratio = sum_total_ratio + total_ratio{r};     % Accumulate the sum
            Average = sum_total_ratio/r;
        end        
    end
    pause(.6);
    %%
    subplot(3, 4, k+1);
    w=[512 512];
    imshow(w, []);
    text(0.6,1.2,sprintf('Infection percentage = %0.2f%%',Average),'Color','b','FontSize',10)
    if Average > 5 && Average < 15
        text(0.6,1,sprintf('Level 1 of Infection'),'Color','b','FontSize',12)
    elseif Average >= 15 && Average < 20
        text(0.6,1,sprintf('Level 2 of Infection'),'Color','yellow','FontSize',12)
    elseif Average >= 20
        text(0.6,1,sprintf('Level 3 of Infection'),'Color','r','FontSize',12)
    elseif Average <= 0
        text(0.6,1,sprintf('Error!!'),'Color','c','FontSize',12)
    elseif Average < 5
        text(0.6,1,sprintf('You Are Healthy'),'Color','g','FontSize',12)
    end
    pause(.6);
    clear;
    clear;
    clear;
    pause(.6);
    clc;
    pause(.6);
%=====================================================================================================================
%=====================================================================================================================
                                      %%%%%%%%%%%% Manual Part %%%%%%%%%%%%
%=====================================================================================================================
%=====================================================================================================================
elseif choice == 2
    for i=1:100      %Start of main for loop.
        choice  =  menu('Do you want to analyze an image?','YES','NO'); % Menu messages.
        if   choice == 1   % Click YES,  Start of manin if loop.
            clc;    % Clear the command window.
            close all;  % Close all figures (except those of imtool.)
            imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
            workspace;  % Make sure the workspace panel is showing.
            format long g;  %Set the output format to the long fixed-decimal format.
            format compact;  %Suppress excess blank lines to show more output on a single screen.
            
            %% SECTION2: READS CT SCAN IMAGES %%
            %selpath = uigetdir(path)
            %folder ='D:\HTI\Graduation Project\CT Images\Patient1'; % Put the current location of your CT scan image here.
            f=dir(fullfile(folder,'*.jpg'));   % Choose your actual images format.
            for k=1:numel(f)       % Start for loop.
                filename{k}=fullfile(folder,f(k).name); % For loop for multi image.
            end                   % End for loop.
            img = menu('Which image do you want to analyze ?', filename);  % Choose one image from a CT scan folder.
            
            %% SECTION3: IMAGE & FIGURE RESIZATION %%
            
            OrginalImage = imread(filename{img}); % Read your chosen image.
            OrginalImage = imresize(OrginalImage,[512 512]); % Resize the dimensions of the image.
            [rows, columns, numberOfColorBands] = size(OrginalImage);  % numberOfColorBands should be = 1.
            if numberOfColorBands > 1 % Start of if condition.
                grayImage = OrginalImage(:, :, 2);  % Convert it to gray scale by taking only the green channel.
            end  % End of if condition.
            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % Enlarge figure window to full screen.
            set(gcf, 'Name', 'Covid-19 Detector Project', 'NumberTitle', 'Off') % Give a title to the figure window.
            drawnow; % Use drawnow to display the changes on the screen after each iteration through the loop.
            
            %% SECTION4: THRESOLDING ADJUSTMENT %%
            
            mask = grayImage > 0 & grayImage < 255;  % Binarize(grayImage);
            thresholdValue = 255 * graythresh(grayImage(mask)); % Label the regions for the two body zones.
            binaryImage = grayImage < thresholdValue; % Apply the thresholding.
            binaryImage = imclearborder(binaryImage);  % Get rid of stuff touching the border.
            binaryImage = bwareafilt(binaryImage, 2); % Extract only the two largest blobs.
            binaryImage = imfill(binaryImage, 'holes'); % Fill holes in the blobs to make them solid.
            maskedImage = grayImage; % Mask image with lungs-only mask.
            maskedImage(~binaryImage) = 0; % This will produce a gray scale image in the lungs and black everywhere else.
            
            %% SECTION5: SEGMENTATION BY CUSTRING %%
            
            [L,Centers] = imsegkmeans(maskedImage,3);  % Segment the image into 3 regions.
            im = labeloverlay(maskedImage,L); % Overlay label matrix regions on 2-D image
            cform = makecform('srgb2lab'); % Create color transformation structure Useing rgb2lab to convert the RGB white value to CIE 1976 L*a*b* values.
            lab_im = applycform(im,cform); %  converts the color values in (im) to the color space specified in the color transformation structure (cform).
            ab = double(lab_im(:,:,2:3));  % converts the values in (lab_im) to double precision.
            nrows = size(ab,1); % Returns the length of dimension dim (1) of (ab).
            ncols = size(ab,2); % Returns the length of dimension dim (2) of (ab).
            ab = reshape(ab,[nrows*ncols,2]); % Reshape (ab) into a [(nrows*ncols)rows , 2column]
            nColors = 3; % Segment the image into 3 regions with different colors.
            % repeat the clustering 5 times to avoid local minima
            [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                'Replicates',3); % Partition the data into (3)clusters(nColors), and choose the best arrangement out of (3)initializations.
            pixel_labels = reshape(cluster_idx,nrows,ncols); % Reshape (pixel_labels) into a [(cluster_idx)rows , (ncols)column].
            segmented_images = cell(1,5); % returns a (1) by (5) cell array of empty matrices.
            rgb_label = repmat(pixel_labels,[1 1 3]); %  Returns an array containing [1 1 3] copies of (pixel_labels) in the row and column dimensions of (rgb_label).
            for k = 1:nColors     % Start of for loop.
                color = im; % Color variable equals Overlay label matrix regions on 2-D image
                color(rgb_label ~= k) = 0;    % Any region except rgb_label equal it to zero
                segmented_images{k} = color;  % Put the (segmented_images) array vlaues into variable(K) array, whereas k = 1:nColors.
            end                    % End of for loop.
            
            %% SECTION6: ISOLATION OF NORMAL PARTS %%
            
            coloredLabels = label2rgb (binaryImage, 'hsv', 'k', 'shuffle'); % Specifies the colormap cmap to be used in the RGB image, (hsv) means Hue Saturation Value (K) means Black color, (shuffle) to assigns colormap colors pseudorandomly.
            blobMeasurements = regionprops(binaryImage,maskedImage, 'all');  % Measure properties of image regions, (all) to computes all the shape measurements.
            numberOfBlobs = size(blobMeasurements, 1); % Returns the length of dimension dim (1) of (blobMeasurements).
            axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
            hold on;    % Retains plots in the current axes so that new plots added to the axes do not delete existing plots.
            boundaries = bwboundaries(binaryImage);  % Traces the exterior boundaries of lungs in (binaryImage).
            numberOfBoundaries = size(boundaries, 1); % Returns the length of dimension dim (1) of (boundaries).
            for j = 1 : numberOfBoundaries           % Start of for loop.
                thisBoundary = boundaries{j};  % Put the (boundaries) array vlaues into (j) array, whereas j = 1 : number of lungs.
                plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2); % Plot a green borders around the lungs.
            end      % End of for loop.
            hold off;  %  Sets the hold state to off so that new plots added to the axes clear existing plots and reset all axes properties
            %% SECTION7: PRE-CALCULATION OF hole lungs AREAS %%
            
            for j = 1 : numberOfBlobs           % Start of for loop, Loop through all infected parts.
                % directly into regionprops.  The way below works for all versions including earlier versions.)
                thisBlobsPixels = blobMeasurements(j).PixelIdxList;  % Get list of pixels in current blob.
                meanGL = mean(binaryImage(thisBlobsPixels)); % Find mean intensity of labeled normal parts.
                blobArea = blobMeasurements(j).Area;		% Get area of labeld normal parts.
                hole_lungs_area(j)= blobArea;  % Put the valus of normal parts into variable(normal_areas).
            end % End of for loop.
            subplot(2, 3, 1); % Plot the image on the top left part.
            imshow(grayImage, []);  % Display the the image.
            axis on; % Display the axis on the image.
            title('Original Grayscale Image', 'FontSize', fontSize); % Set the image title and font size.
            
            %% SECTION8: ISOLATION OF INFECTED PARTS %%
            
            gray_img = rgb2gray(segmented_images{3}); % Converts the truecolor image (segmented_images{3}) to the grayscale intensity image (gray_img).
            blobMeasurements = regionprops(gray_img,gray_img, 'all'); % Measure properties of image regions, (all) to computes all the shape measurements.
            numberOfBlobs = size(blobMeasurements, 1); % Returns the length of dimension dim (1) of (blobMeasurements).
            axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
            hold on;  % Retains plots in the current axes so that new plots added to the axes do not delete existing plots.
            boundaries = bwboundaries(gray_img); % Traces the exterior boundaries of lungs in (gray_img).
            numberOfBoundaries = size(boundaries, 1);  % Returns the length of dimension dim (1) of (boundaries).
            for r = 1 : numberOfBoundaries       % Start of for loop.
                thisBoundary = boundaries{r};  % Put the (boundaries) array vlaues into (r) array, whereas r = 1 : number of infected parts.
                plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);  % Plot a green borders around the infected parts.
            end    % End of for loop.
            hold off;  %  Sets the hold state to off so that new plots added to the axes clear existing plots and reset all axes properties
            
            %% SECTION9: PRE-CALCULATION OF INFECTED PARTS AREAS %%
            
            for r = 1 : numberOfBlobs           % Start of for loop, Loop through all infected parts.
                thisBlobsPixels = blobMeasurements(r).PixelIdxList;  % Get list of pixels in current blob.
                meanGL = mean(gray_img(thisBlobsPixels)); % Find mean intensity of labeled infected parts.
                blobArea = blobMeasurements(r).Area;		% Get area of labeld infected parts.
                infected_areas(r)=blobArea;  % Put the valus of infected parts into variable(infected_areas).
            end   % End of for loop.
            
            %% SECTION10: AREA CALCULATION %%
            
            a1 = sum(infected_areas(1,:));  % Sum of infected areas.
            a2 = sum(hole_lungs_area(1,:));    % Sum of hole lungs area.
            a3 = a2 - a1;                   % Sum of normal areas.
            p_a = (a1 / a2)*100 ;     % Percentage of infection.
            
            %% SECTION11: PLOTTING THRESOLDING VALUE ON HISTOGRAM %%
            
            [pixelCount, grayLevels] = imhist(grayImage); % calculates the histogram for the grayscale image, imhist function returns the histogram counts in pixelCount and the bin locations in grayLevels
            pixelCount(1) = 0;  % Put first Count of Histogram equal to zero
            pixelCount(end) = 0;  % Put end Count of Histogram equal to zero (Location number 256)
            subplot(2, 3, 2); % Plot the (grayImage) on the top middle.
            bar(grayLevels, pixelCount, 'BarWidth', 1, 'FaceColor', 'b'); % Displays histogram in blue.
            grid on;  %  displays the major grid lines for the current axes.
            title('Histogram of Original Image', 'FontSize', fontSize);   % Set the image title and font size.
            xlim([0 grayLevels(end)]); % Scale x axis manually.
            line([thresholdValue, thresholdValue], ylim, 'LineWidth', 2, 'Color', 'r'); % Draw a red line on the histogram at thresholding value.
            yl = ylim;  % Scale y axis manually.
            text(50, 0.9*yl(2), 'Lungs', 'Color', 'r', 'FontSize', 20, 'FontWeight', 'bold'); % Display the histogram of the (lungs) on the left of red line.
            text(175, 0.9*yl(2), 'Body', 'Color', 'r', 'FontSize', 20, 'FontWeight', 'bold'); % Display the histogram of the (body) on the left of red line
            
            %% SECTION12: PLOTTING MASKED GRAY IMAGE OF LUNGS %%
            subplot(2, 3, 3); % Plot the image on the top right.
            imshow(maskedImage, []); % Display the the image.
            axis on; % Display the axis on the image.
            title('Masked Image', 'FontSize', fontSize); % Set the image title and font size.
            
            %% SECTION12: PLOTTING HOLE LUNGS WITH ITS AREA %%
            subplot(2, 3, 4);  % Plot the image on the down left.
            imshow(binaryImage, []); % Display the the image.
            text(100,450,sprintf('Lungs Area = %d pixel',a2),'Color','g','FontSize',10) % Display the vlaue of hole lungs area.
            axis on; % Display the axis on the image.
            title('Whole Lungs', 'FontSize', fontSize); % Set the image title and font size.
            
            %% SECTION12: PLOTTING NORMAL PARTS WITH ITS AREA %%
            
            subplot(2, 3, 5); % Plot the image on the down middle.
            imshow(segmented_images{2}, []); % Display the the image.
            text(100,450,sprintf('Normal Area = %d pixel',a3),'Color','g','FontSize',10) % Display the vlaue of normal parts area.
            axis on;  % Display the axis on the image.
            title('Normal Parts', 'FontSize', fontSize); % Set the image title and font size.
            
            %% SECTION12: PLOTTING INFECTION PARTS WITH ITS AREA %%
            
            subplot(2, 3, 6); % Plot the image on the right down.
            imshow(segmented_images{3}, []); % Display the the image.
            text(50,420,sprintf('Infected Area = %d pixel',a1),'Color','g','FontSize',10) % Display the vlaue of normal parts area.
            text(50,470,sprintf('Infection percentage = %0.2f%% ',p_a),'Color','g','FontSize',10) % Display the vlaue of percentage value of infection.
            axis on; % Display the axis on the image.
            title('Infected Parts', 'FontSize', fontSize); % Set the image title and font size.
            
        elseif choice == 2   % Press NO.
            quit cancel;     % Press cancle to quit.
            clc;    % Clear the command window.
            close all force;  % Close all figures (except those of imtool.)
            imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
            clear;  % Erase all existing variables. Or clearvars if you want.
            break   % terminates the execution of for loop.
        end   % End of main if loop.
    end % End the main for loop.
end