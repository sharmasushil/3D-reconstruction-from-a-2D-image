clear all;
close all;
clc;

% Define parameters
   
% Region of Interest (in meters)
x_min =  0;  
x_max =  30;
y_min = -15;
y_max =  15;
  
% Image resolution:
imageSize = [640,480];   

% % 3D camera orientation:
R_cam = [ 0    0    1;
         -1    0    0;
          0   -1    0]';  

 
        

% Intrinsic matrix:    
fu=150; fv=150; 
u0=imageSize(1)/2; v0=imageSize(2)/2; 

Camera_matrix = [fu  0   u0 ;
                 0   fv  v0 ;         
                 0   0   1  ];

             
% 3D camera rotations:   
yaw     =  0*pi/180;  
roll    =  0*pi/180; % Here we can the value of roll angle.
pitch   =  -20*pi/180;


% 3D camera position:
O_Rcam = [-20;0;12];        

% height of camera  
h_cam  = O_Rcam(3);  
Z = h_cam;

% Projection & transformation matrices

rotation_matrix       =  R_cam*[1   0   0; 0 cos(roll) -sin(roll);  0 sin(roll)    cos(roll)]...
                           *[cos(pitch) 0 sin(pitch); 0  1 0 ;  -sin(pitch) 0  cos(pitch)]...
                           *[cos(yaw) -sin(yaw) 0;    sin(yaw) cos(yaw) 0;        0  0 1];
                          
% rotation_matrix    =    R_cam*eul2rotm([yaw,pitch,roll],'ZYX');
% rotation_matrix     = rotationVectorToMatrix([pitch,yaw,roll])'*R_cam;
translation_matrix  =    -rotation_matrix*O_Rcam; 
%  translation_matrix    =     O_Rcam; 
 projection_matrix   =    [Camera_matrix*rotation_matrix Camera_matrix*translation_matrix; zeros(1,3) 1]; 
% projection_matrix   =  [Camera_matrix*rotation_matrix Camera_matrix*translation_matrix + translation_matrix; zeros(1,3) 1]; 
%  projection_matrix     = [rotation_matrix -rotation_matrix*translation_matrix];
    

% Four Square Definition and Projection in 3D to 2D 
c=10;
sq1_3d = [ 0  0  0;
           0  c  0;
           c  c  0;
           c  0  0];

sq2_3d = [ 0  0  0;
           c  0  0;
           c -c  0;
           0 -c  0];
   
sq3_3d = [ 0  0  0;
           0 -c  0;
          -c -c  0;
          -c  0  0];
   
sq4_3d = [ 0  0  0;
          -c  0  0;
          -c  c  0;
           0  c  0];
 
Sq_3D = [sq1_3d; sq2_3d; sq3_3d; sq4_3d];


% Projection from 3D to 2D Images
%  points_3D_Rcam = ([projection_matrix]*[Sq_3D,ones(size(Sq_3D,1),1)]')';
% points_3D_Rcam = ([projection_matrix;  0 0 0 1]*[Sq_3D,ones(size(Sq_3D,1),1)]')';
Pj_2D  = (projection_matrix*[Sq_3D ones(size(Sq_3D,1),1)]')';

% Pj_2D = ([Camera_matrix [0;0;0]]*points_3D_Rcam')'; 
Pj_2D  = Pj_2D(:,1:2)./repmat(Pj_2D(:,3),1,2); 

%Square splits:
sq1_2D = Pj_2D(1:4,:);
sq2_2D = Pj_2D(5:8,:);
sq3_2D = Pj_2D(9:12,:);
sq4_2D = Pj_2D(13:16,:);


% Plot 3D_view
figure('units','normalized','outerposition',[0 0 1 1]);
f1=subplot(1,3,1);hold on; grid on; view(50, 30); axis equal;
xlim([-30,15]); ylim([-15,15]); zlim([0,25]);
xlabel('X');ylabel('Y');zlabel('Z'); title('3D View');

% Vitrual Camera Parameters
O_Rcam1 = [0;0;18];
yaw1   =  0*pi/180;
roll1  =  0*pi/180;
pitch1 = 90*pi/180;

R_cam1 = [ 0    0    1;
         -1    0    0;
          0   -1    0]'; 
      
rotation_matrix1  =  R_cam1*[1   0   0; 0 cos(roll1) -sin(roll1);  0 sin(roll1)    cos(roll1)]...
                           *[cos(pitch1) 0 sin(pitch1); 0  1 0 ;  -sin(pitch1) 0  cos(pitch1)]'...
                           *[cos(yaw1) -sin(yaw1) 0;    sin(yaw1) cos(yaw1) 0;        0  0 1];

% camera_plot
plotCamera('Location',O_Rcam,'Orientation',rotation_matrix,'Size',1.8,'color',[0, 0, 1],'AxesVisible',1);

%Vitrual Camera 
plotCamera('Location',O_Rcam1,'Orientation',rotation_matrix1,'Size',1.8,'color',[0.2, 0, 0],'AxesVisible',1);

% Plot the projected squares in 3D view 
patch([sq1_3d(:,1)],[sq1_3d(:,2)],'blue');
patch([sq2_3d(:,1)],[sq2_3d(:,2)],'yellow');
patch([sq3_3d(:,1)],[sq3_3d(:,2)],'cyan');
patch([sq4_3d(:,1)],[sq4_3d(:,2)],'red');


% Plot 2D_Image
subplot(1,2,2);hold on;  grid off; axis equal;  set(gca,'YDir','Reverse');
title('2D Image'); axis off;
xlim([0 imageSize(1)]); ylim([0 imageSize(2)]);


% plot the projected squares in 2D View 
patch ([sq1_2D(:,1)],[sq1_2D(:,2)],'blue');
patch ([sq2_2D(:,1)],[sq2_2D(:,2)],'yellow');
patch ([sq3_2D(:,1)],[sq3_2D(:,2)],'cyan');
patch ([sq4_2D(:,1)],[sq4_2D(:,2)],'red');


% Plot the image boundaries
plot([0 imageSize(1)],[0 0],'k','linewidth',3);
plot([imageSize(1) imageSize(1)],[0 imageSize(2)],'k','linewidth',3);
plot([0 imageSize(1)],[imageSize(2) imageSize(2)],'k','linewidth',3);
plot([0 0],[0 imageSize(2)],'k','linewidth',3);

% generate an image
figure; hold on; grid on; set(gca,'YDir','Reverse'); axis off;
hFig = gcf; hAx  = gca;  set(hFig,'units','normalized','outerposition',[0 0 1 1]); 
set(hAx,'Unit','normalized','Position',[0 0 1 1]);  set(hFig,'menubar','none'); 
set(hFig,'NumberTitle','off');  xlim([0 imageSize(1)]); ylim([0 imageSize(2)]);

patch ([sq1_2D(:,1)],[sq1_2D(:,2)],'blue');
patch ([sq2_2D(:,1)],[sq2_2D(:,2)],'yellow');
patch ([sq3_2D(:,1)],[sq3_2D(:,2)],'cyan');
patch ([sq4_2D(:,1)],[sq4_2D(:,2)],'red');

%Create an image and save
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 imageSize(1)/100 imageSize(2)/100])
print -djpeg king.jpg -r100
save('imagepara.mat', 'Camera_matrix','rotation_matrix','translation_matrix','projection_matrix','O_Rcam' )

% Bird Eye View Concept

load ('imagepara.mat');
I = im2double(imread('king.jpg'));
% figure; imshow(I);
hold on;
I = rgb2gray(I); 
% figure ;imshow(I);impixelinfo

n = size(I,1);
m = size(I,2);


Roll = -roll;
Pitch = -pitch;

for u_prime = 1:m
    for v_prime = 1:n
        X = x_max-u_prime*((x_max-x_min)/m);
        Y = y_max-v_prime*((y_max-y_min)/n);
        
        U(u_prime,v_prime) = ((-fu*sin(Roll)*sin(Pitch)+ u0*cos(Pitch))*X - fu*cos(Roll)*Y + (fu*sin(Roll)*cos(Pitch) + u0*sin(Pitch))*Z)/(cos(Pitch)*X + sin(Pitch)*Z);
        V(u_prime,v_prime) = ((-fv*cos(Roll)*sin(Pitch)+ v0*cos(Pitch))*X + fv*sin(Roll)*Y + (fv*cos(Roll)*cos(Pitch) + v0*sin(Pitch))*Z)/(cos(Pitch)*X + sin(Pitch)*Z);
        
    
    end 
end
%pause 
%subplot(1,3,3)
 figure

I_prime = interp2(double(I(:,:,1)),U(:,:),V(:,:),'linear');
imshow(I_prime);
axis on, grid on, 
xlabel('U (pixels)','FontSize',12,'FontWeight','bold','Color','k')
ylabel('V (pixels)','FontSize',12,'FontWeight','bold','Color','k')
title('Bird Eye View')

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 imageSize(2)/100 imageSize(1)/100])
print -djpeg bev.jpg -r100




