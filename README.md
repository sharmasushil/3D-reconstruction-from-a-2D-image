# 3D-reconstruction-from-a-2D-image


### The camera simulation is based on a traditional camera model.


To begin, we'll use a square box with four distinct colors to better understand how IPM works. After using IPM, or the pixel value equation of an image (u, v), we'll be able to build a top view of the image.
In other words, the BEV image I′ is created by warping each point in I′ onto I using the inverse mapping G1, and then interpolating local pixel intensity in the origin image I to determine the image's intensity. The figure depicted with camera roll angle of 40 and pitch angle of 20 as we addressed the behavior of IPM to build a top view, however the created bird eye is in gray scale property.

![main](https://user-images.githubusercontent.com/70905483/173233004-f1a45ac2-1ad3-4f92-a718-e700dd8106e8.PNG)




![IPM](https://user-images.githubusercontent.com/70905483/173233013-d263d0e5-3f24-45b5-a57f-43cc11cc41f3.PNG)



![visualroi](https://user-images.githubusercontent.com/70905483/173233034-9d25234b-fde8-42be-9b0e-b87201b1cd7f.PNG)
