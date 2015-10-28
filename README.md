# Image Processing and Pattern Recognition: 2D object tracking

# Alexandra Popov (12216685)
# Leroy Chika Anozie (12400952)
# Marcel Bühler (99211688)

# 28th of October 2015
# designed with Matlab R2015a and VLFeat 0.9.20

----- How to start -----
run GUI.m in Matlab

----- GitHub URL -----
https://github.com/mbbuehler/kangoroo-tracking

----- Details -----
This object tracking algorithm uses different methods for finding key points and matching them.
Using the GUI the are different parameters to select:

1 Video: Choose the video you want to process, the initial rectangle is already set. You can choose from example videos from PrinctonTrackingBenchmark Website
	
2 Matching algorithm: Choose between two matching algorithms
a) euclidean distance
b) SVM

3 Display mode: Choose between rectangles or rectangles and actual key points  

4 Stop after very frame: Check if you want to see every frame before continuing manually


----- Modality of the code -----

1. reading the images and preprocessing

2. finding and describing the key points with VLFeat

3. matching the key points from the neighbourhood: 
			mode 1: matching key points with euclidean distance
			mode 2: matching key points using svm [trained with 99 tracking examples]
			
4. Rectangles and (optionally) key points are showing the track of the selected object in the video
			
