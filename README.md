# Pavement-Crack-Detection

This project implements the algorithm to detect the cracks on the concrete roads and hopes to be extended to other materials. There are various types of cracks that can be found in the pavement of the roads like longitudinal cracks or transverse cracks or mesh cracks. The algorithm implements majorly edge detection and image morphology to detect the cracks and then use image segmentation techniques to separate the intended regions from the original image. The algorithm follows pre-processing, core processing and post processing techniques to detect these cracks. The preprocessing methods like de-noising and image enhancement to work on the images free from noise. The core processing techniques include edge detection and thresholding. After the edges are detected, we use the morphological operations to enhance the detection of the cracks and
segment them out. Post processing includes the super imposition of the found cracks on the original image. 

# Implementation

Step 1: Reading multiple input data from folder

Step 2: Conversion to grayscale image

Step 3: Contrast stretching

Step 4: Applying median filter to smoothen the image

Step 5: Applying threshold on the image to segment out the cracks

Step 6: Creating a structuring element to detect cracks in all orientations

Step 7: Creating a marker image by erosion with created structuring element

Step 8: Reconstruction by opening using the marker image

Step 9: Applying median filter again to remove detected speckles

Step 10: Superimposing the detected cracks on the original image
