# 3D-reconstruction-from-a-2D-image


### 1. The camera simulation is based on a traditional camera model.


To begin, we'll use a square box with four distinct colors to better understand how IPM works. After using IPM, or the pixel value equation of an image (u, v), we'll be able to build a top view of the image.
In other words, the BEV image I′ is created by warping each point in I′ onto I using the inverse mapping G1, and then interpolating local pixel intensity in the origin image I to determine the image's intensity. The figure depicted with camera roll angle of 40 and pitch angle of 20 as we addressed the behavior of IPM to build a top view, however the created bird eye is in gray scale property.

![main](https://user-images.githubusercontent.com/70905483/173233004-f1a45ac2-1ad3-4f92-a718-e700dd8106e8.PNG)


### 2. Bird Eye View/ Top View Concept 

As seen in the graphic below, it is a transformation technique for generating a top view perspective of an image. Geometrical image alteration is a type of digital image processing that includes this approach.
As shown in the diagram, if you want to use BEV technique (top view), the algorithm must be aware of camera characteristics such as Extrinsic and Intrinsic parameters, which allow you to obtain rotational, translation, imageSize, focal length, and principal point. Note that once we get all of the information for the camera, we must go through the calibration process to obtain all of the parameters. Many programs, including as MatLab, OpenCV, and NodeJS, are available on the internet to obtain camera parameters.

![IPM](https://user-images.githubusercontent.com/70905483/173233013-d263d0e5-3f24-45b5-a57f-43cc11cc41f3.PNG)


### 3. Region of Interset (ROI Concept)

More information about the figure can be found in the diagram (ROI). We specify the ROI, which is the green portion covered by the virtual camera from top view, as Xmin = 0, Xmax = 20, Ymin = 15, Ymax = 15. As you can see, we have two cameras, a real and a virtual camera. In its most basic form, a region of interest (ROI) is a part of an image that you want to filter or manipulate in some way.

![visualroi](https://user-images.githubusercontent.com/70905483/173233034-9d25234b-fde8-42be-9b0e-b87201b1cd7f.PNG)



Please see a short report file for further information on the mathematical modeling concept.
