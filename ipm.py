# -*- coding: utf-8 -*-
"""IPM.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1Z-9n6UFq6LCpEQqRJ0iEpt0AGXAEWe0Q
"""

import numpy as np
import matplotlib.pyplot as plt
import cv2
from mpl_toolkits.mplot3d import Axes3D

# Region of Interest (in meters)
x_min = 0
x_max = 30
y_min = -15
y_max = 15

# Image resolution:
imageSize = (640, 480)

# 3D camera orientation:
R_cam = np.array([[0, 0, 1],
                  [-1, 0, 0],
                  [0, -1, 0]]).T

# Intrinsic matrix:
fu = 150
fv = 150
u0 = imageSize[0] / 2
v0 = imageSize[1] / 2

Camera_matrix = np.array([[fu, 0, u0],
                          [0, fv, v0],
                          [0, 0, 1]])

# 3D camera rotations:
yaw = 0 * np.pi / 180
roll = 0 * np.pi / 180
pitch = -20 * np.pi / 180

# 3D camera position:
O_Rcam = np.array([-20, 0, 12])

# height of camera
h_cam = O_Rcam[2]
Z = h_cam

# Projection & transformation matrices
rotation_matrix = R_cam @ np.array([[1, 0, 0],
                                    [0, np.cos(roll), -np.sin(roll)],
                                    [0, np.sin(roll), np.cos(roll)]]) @ \
                  np.array([[np.cos(pitch), 0, np.sin(pitch)],
                            [0, 1, 0],
                            [-np.sin(pitch), 0, np.cos(pitch)]]) @ \
                  np.array([[np.cos(yaw), -np.sin(yaw), 0],
                            [np.sin(yaw), np.cos(yaw), 0],
                            [0, 0, 1]])

translation_matrix = -rotation_matrix @ O_Rcam

projection_matrix = np.hstack((Camera_matrix @ rotation_matrix, Camera_matrix @ translation_matrix[:, np.newaxis]))

# Four Square Definition and Projection in 3D to 2D
c = 10
sq1_3d = np.array([[0, 0, 0],
                   [0, c, 0],
                   [c, c, 0],
                   [c, 0, 0]])

sq2_3d = np.array([[0, 0, 0],
                   [c, 0, 0],
                   [c, -c, 0],
                   [0, -c, 0]])

sq3_3d = np.array([[0, 0, 0],
                   [0, -c, 0],
                   [-c, -c, 0],
                   [-c, 0, 0]])

sq4_3d = np.array([[0, 0, 0],
                   [-c, 0, 0],
                   [-c, c, 0],
                   [0, c, 0]])

Sq_3D = np.vstack((sq1_3d, sq2_3d, sq3_3d, sq4_3d))

# Projection from 3D to 2D Images
Pj_2D = (projection_matrix @ np.hstack((Sq_3D, np.ones((Sq_3D.shape[0], 1)))).T).T
Pj_2D = Pj_2D[:, :2] / Pj_2D[:, 2, np.newaxis]

# Square splits:
sq1_2D = Pj_2D[0:4, :]
sq2_2D = Pj_2D[4:8, :]
sq3_2D = Pj_2D[8:12, :]
sq4_2D = Pj_2D[12:16, :]

# Plot 3D view
fig = plt.figure(figsize=(15, 5))

ax1 = fig.add_subplot(131, projection='3d')
ax1.set_xlim([-30, 15])
ax1.set_ylim([-15, 15])
ax1.set_zlim([0, 25])
ax1.set_xlabel('X')
ax1.set_ylabel('Y')
ax1.set_zlabel('Z')
ax1.set_title('3D View')

# Virtual Camera Parameters
O_Rcam1 = np.array([0, 0, 18])
yaw1 = 0 * np.pi / 180
roll1 = 0 * np.pi / 180
pitch1 = 90 * np.pi / 180

R_cam1 = np.array([[0, 0, 1],
                   [-1, 0, 0],
                   [0, -1, 0]]).T

rotation_matrix1 = R_cam1 @ np.array([[1, 0, 0],
                                      [0, np.cos(roll1), -np.sin(roll1)],
                                      [0, np.sin(roll1), np.cos(roll1)]]) @ \
                  np.array([[np.cos(pitch1), 0, np.sin(pitch1)],
                            [0, 1, 0],
                            [-np.sin(pitch1), 0, np.cos(pitch1)]]) @ \
                  np.array([[np.cos(yaw1), -np.sin(yaw1), 0],
                            [np.sin(yaw1), np.cos(yaw1), 0],
                            [0, 0, 1]])

# Camera plot
ax1.plot([O_Rcam[0]], [O_Rcam[1]], [O_Rcam[2]], 'bo')
ax1.plot([O_Rcam1[0]], [O_Rcam1[1]], [O_Rcam1[2]], 'ro')

for sq_3d in [sq1_3d, sq2_3d, sq3_3d, sq4_3d]:
    ax1.plot(sq_3d[:, 0], sq_3d[:, 1], sq_3d[:, 2])

# Plot 2D Image
ax2 = fig.add_subplot(132)
ax2.set_xlim([0, imageSize[0]])
ax2.set_ylim([0, imageSize[1]])
ax2.set_title('2D Image')
ax2.invert_yaxis()

for sq_2D in [sq1_2D, sq2_2D, sq3_2D, sq4_2D]:
    ax2.plot(sq_2D[:, 0], sq_2D[:, 1])

# Create an image and save
fig.savefig('king.jpg')

# Bird Eye View Concept
I = cv2.imread('king.jpg', cv2.IMREAD_GRAYSCALE)
n, m = I.shape

U = np.zeros((m, n))
V = np.zeros((m, n))

Roll = -roll
Pitch = -pitch

for u_prime in range(m):
    for v_prime in range(n):
        X = x_max - u_prime * ((x_max - x_min) / m)
        Y = y_max - v_prime * ((y_max - y_min) / n)

        U[u_prime, v_prime] = ((-fu * np.sin(Roll) * np.sin(Pitch) + u0 * np.cos(Pitch)) * X -
                               fu * np.cos(Roll) * Y +
                               (fu * np.sin(Roll) * np.cos(Pitch) + u0 * np.sin(Pitch)) * Z) / \
                              (np.cos(Pitch) * X + np.sin(Pitch) * Z)
        V[u_prime, v_prime] = ((-fv * np.cos(Roll) * np.sin(Pitch) + v0 * np.cos(Pitch)) * X +
                               fv * np.sin(Roll) * Y +
                               (fv * np.cos(Roll) * np.cos(Pitch) + v0 * np.sin(Pitch)) * Z) / \
                              (np.cos(Pitch) * X + np.sin(Pitch) * Z)

# Interpolate the bird-eye view image
I_prime = cv2.remap(I, U.astype(np.float32), V.astype(np.float32), cv2.INTER_LINEAR)

plt.figure()
plt.imshow(I_prime, cmap='gray')
plt.title('Bird Eye View')
plt.xlabel('U (pixels)')
plt.ylabel('V (pixels)')
plt.savefig('bev.jpg')
plt.show()