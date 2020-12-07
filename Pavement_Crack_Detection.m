%% Pavement Crack Detection %%
% Author: Vishakha Thakurdwarkar %
% Detects cracks in the pavements using Image Segmentation and Mathematical Morphology %

clc;
clear all;
close all;
%% Loading the image files from folder %%
% These images contain different kinds of pavement cracks %
imagefiles = dir('\\blender\homes\v\i\vishakha.t\nt\MATLAB\Project\Images');

numberoffiles = length(imagefiles);    % Total Number of images in folder
for iterator = 3:numberoffiles         % Starting from 3 to avoid reading hidden files
    CurrentFilename = imagefiles(iterator).name;
    CurrentImage = imread(CurrentFilename);
    
    % Converting RGB image to gray to perform all the operations %
    InputImage = rgb2gray(CurrentImage);

    %% Contrast Stretching to adjust the intensities
    AdjustedImage = imadjust(InputImage,stretchlim(InputImage));

    %% Image Smoothing
    BlurredImage = medfilt2(AdjustedImage);

    %% Image segmentation by thresholding
    % 'level' is the threshold value set for thresholding the image
    level = 0.25;
    ThresholdedImage = im2uint8(imbinarize(AdjustedImage,level));

    %% Morphological reconstruction using opening
    % 'B' is the structuring element used in various orientations 
    % This enables the algorithm to detect the cracks conneted in different angles
    B1 = strel('line',3,0);
    B2 = strel('line',3,30);
    B3 = strel('line',3,45);
    B4 = strel('line',3,60);
    B5 = strel('line',3,90);
    B6 = strel('line',3,120);
    
    ThresholdedImage = imcomplement(ThresholdedImage);    

    % Erosion to create a marker image that would be crucial in reconstructing the image
    MARKER1 = imerode(ThresholdedImage,B1);
    MARKER2 = imerode(ThresholdedImage,B2);
    MARKER3 = imerode(ThresholdedImage,B3);
    MARKER4 = imerode(ThresholdedImage,B4);
    MARKER5 = imerode(ThresholdedImage,B5);
    MARKER6 = imerode(ThresholdedImage,B6);

    % Adding all the markers to obtain details from all orientations
    MARKER = MARKER1+MARKER2+MARKER3+MARKER4+MARKER5+MARKER6;

    % Reconstructing the thresholded image using opening
    ReconstructedImage1 = morphoOpenbyRecon4e(MARKER1,ThresholdedImage,B1);
    ReconstructedImage2 = morphoOpenbyRecon4e(MARKER2,ThresholdedImage,B2);
    ReconstructedImage3 = morphoOpenbyRecon4e(MARKER3,ThresholdedImage,B3);
    ReconstructedImage4 = morphoOpenbyRecon4e(MARKER4,ThresholdedImage,B4);
    ReconstructedImage5 = morphoOpenbyRecon4e(MARKER5,ThresholdedImage,B5);
    ReconstructedImage6 = morphoOpenbyRecon4e(MARKER6,ThresholdedImage,B6);

    % Final image with cracks detected
    ReconstructedImage = ReconstructedImage1+ReconstructedImage2+ReconstructedImage3+ReconstructedImage4+ReconstructedImage5+ReconstructedImage6;  
    
    % Applying median filter to remove the speckles detected between the
    % crack areas
    OutputImage = medfilt2(ReconstructedImage);    
    
    % Creating a colored image of the final segmented image to superimpose
    % on the original image
    FinalOutput = convertBinImage2RGB(OutputImage);   
    FinalOutput(:,:,1) = 1;
    
    % Output
    Output_DetectedCracks = CurrentImage + FinalOutput;

    figure;
    subplot(1,2,1);
    imshow(CurrentImage);
    title('Input Image');
    subplot(1,2,2);
    imshow(Output_DetectedCracks);
    title('Output with detected cracks');
    
    OutputFilename  = strcat('Output',CurrentFilename);
    imwrite(Output_DetectedCracks,OutputFilename);
end

%% Function to convert binary image to RGB
function [RGB_Image] = convertBinImage2RGB(BinImage)
  RGB_Image = uint8( BinImage(:,:,[1 1 1]) * 255 );
end

%% Function to reconstruct image by opening
function ReconstructedImage = morphoOpenbyRecon4e(Marker,Mask,StructElem)
    DilatedImage = imdilate(Marker,StructElem);  
    IntersectionImage = DilatedImage & Mask;
    Temp = IntersectionImage;
    NumberofSteps =0;
    
    % Geodesic dilation of previous step
    while(1)
        DilatedImage = imdilate(IntersectionImage,StructElem);
        IntersectionImage = DilatedImage & Mask;
        % Checking if stability is attained
        if(Temp == IntersectionImage)
            break;
        else
            NumberofSteps = NumberofSteps+1;
        end
        Temp = IntersectionImage;
    end
    
    ReconstructedImage = IntersectionImage;
end
