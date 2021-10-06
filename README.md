# Covid-19-Diagnose-System-Using-Matlab
Covid-19 Diagnose System Using Matlab

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






