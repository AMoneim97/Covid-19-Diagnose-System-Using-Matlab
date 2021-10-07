# Covid-19-Diagnose-System-Using-Matlab
Covid-19 Diagnose System Using Matlab
## Problem statement
The proposed work aims to extract and evaluate the Coronavirus disease (COVID-19) caused pneumonia infection in lung using CT scans. We propose an image-assisted system to extract COVID-19 infected sections from lung CT scans. It includes following steps:
* Threshold filter to extract the lung region by eliminating possible artifacts.
* Image Filtration & Histogram Equalization using thresholding.
* Image segmentation to extract infected region(s).
* Region-of-interest (ROI) extraction from binary image to compute level of severity. The features that are extracted from ROI are then employed to identify the pixel ratio between the lung and infection sections to identify infection level of severity. The primary objective of the tool is to assist the pulmonologist not only to detect but also to help plan treatment process. As a consequence, for mass screening processing, it will help prevent diagnostic burden.


## Materials and Methods
The study discusses the proposed method implemented to detect the pneumonia infection from CTSI. The various stages involved in the proposed technique are presented in Figure 1. Initially, the two-dimensional CTSI is collected from the database. The CTSI is associated with the lung section along with the artifacts, such as the bone and other body sections. The threshold filler is used to separate the lungs from the body.


![1](https://user-images.githubusercontent.com/91743675/136189753-e77e7f8e-06f8-45ec-957f-d6b987aa4b1b.jpg)

## Threshold filter
The accuracy in the medical image evaluation depends mainly on the images considered for the examination. In this work, the artifacts (bone and other body segments) existing in the considered test image is initially removed using the threshold filter discussed in. The concept of this filter is simple and it separates the test image into two sections based on the chosen threshold value. In this work, the threshold values are selected due to the result of the calculation between highs and lows in a histogram analysis and chosen threshold then works well on all the images considered in the proposed study.

![2](https://user-images.githubusercontent.com/91743675/136190685-89e50822-9278-463f-9962-5f419acdb5c9.jpg)

The considered images can be exactly separated based on its pixels, when the threshold is chosen as 145 (i.e., < 145 = lung and >145 is body). The results attained with the threshold filter are depicted in figure 2. depicts the original image and the gray histogram. From the chosen threshold, we can separate lungs from the body.



## Segmentation of Pneumonia Infection
In the medical image examination problem, the extraction of the abnormal section from the test image is essential for further assessment. The extraction of an abnormal section is normally done using a chosen image segmentation procedure and, in this work, an automated segmentation procedure called Image segmentation, Image segmentation is the classification of an image into different groups. Many researches have been done in the area of image segmentation using clustering. There are different methods and one of the most popular methods is k-means clustering algorithm. Segmentation makes 3 colors to separate the lungs from body and determine the infection part.


![3](https://user-images.githubusercontent.com/91743675/136190873-d5cdd51b-6a23-40ec-bd22-cdd7921b3207.jpg)

## Calculation of the infection
The total lung area and the area of the infected part are calculated, the infected part is subtracted from the total area, and calculate a percentage. The percentage is printed on the lung image along with the infection level

![4](https://user-images.githubusercontent.com/91743675/136191185-7f6daef0-bac6-4046-9bd8-c262a204c8bc.jpg)
## How the script work ?
### Automatic Part
* using (for loop) to calculate infection in many numbers of CT Images.
This section shows the first main algorism of our program which is one of the main for loop chooses, This part has a job to apply automatic analyzation for every single patient on its whole CT scan images, The CT scan contains eleven image which represented the lungs layers, The goal here is to find total percentage of infection on the whole CT scan layers, which in turn determines the level of risk of injury based on this infection ratio.

![1](https://user-images.githubusercontent.com/91743675/136440130-aa60236f-44e6-4203-b073-0253686f8226.jpg)

### Manual Part
* This section shows the second main algorism of our main for loop, This part has a job to apply manual analyzation for every single patient on its whole CT scan images,
But here, after pressing manual from the menu window the program will open the list of CT scan layers, which we can choose each layer to analyze separately.
* The goal here is to find percentage of infection on each single layer separately, which in turn determines the level of risk of injury and ratio of damage for each layer, for specified diagnose the condition. And show the infected parts segmented with a noticeable color for a diagnosis precisely.

![2](https://user-images.githubusercontent.com/91743675/136440713-9c731656-1c1e-4af2-a3b5-16fd03715048.jpg)






