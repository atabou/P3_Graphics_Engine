# P3_Graphics_Engine

A Processing implementation of a 3D Graphics Engine

# Motivations

I wanted to learn about how 3D graphics worked, so I decided to construct one.

# Framework Used:

P3 Processing - https://processing.org/

# TODO
- Implement texture mapping
- Support the whole .obj file format
- Fix the the left/right key so that they move the camera horizontaly instead of in the direction of the x-axis

# How to use?

Download the code. Open it in Processing. Press play.

keys:
- W, S: move camera forward/backward
- A, D: rotate camera
- Up, Down: move camera up/down
- Left, Right: move camera left/right

To change 3D Assets:
- line 43: change the name inside the string to the 3D asset you want to load

To change the size of the screen:
- line 36: in size change width ang height

# Limitations

Frame rate is very low:
  - Non-optimised code
  - Runs only on one CPU thread
  - Does not use the GPU
  
Does not support the whole Wavefront .obj file format.

However, those limitations are acceptable as the goal of this code is to learn about 3D graphics programming

# Credits

This whole code is based on the explanations and C++ coding tutorials of javidx9 on his youtube channel: 
https://www.youtube.com/watch?v=ih20l3pJoeU&t=9s
