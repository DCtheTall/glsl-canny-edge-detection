![Edge detection photo](/example.png?raw=true "Edge detection photo")

# glsl-canny-edge-detection
GLSL Canny edge detection module for WebGL
---

[Live demo](https://dcthetall-edge-detection.herokuapp.com/)

### Algorithm
This program uses Canny edge detection on images and video in real time.
The algorithm is broken into the following steps:

1. Apply a 5-pixel Gaussian blur to the image. This program uses the open source library
[glsl-fast-gaussian-blur](https://github.com/Jam3/glsl-fast-gaussian-blur).

2. Calculate the texture intensity gradient using a 3x3 Sobel operator.

3. Round the gradient to 1 of the 8 cardinal directions.
This is done by seeing which direction has the highest
dot product with the gradient vector.

4. Suppress any gradient that is not a local maximum in
the direction the vector points.

5. Apply a double threshold to the gradient vector to classify
each pixel as not an edge, a weak edge, or a strong edge.

6. Apply hysteresis to the existing weak edges. If a weak
edge does not neighbor a strong edge, then it is likely
due to noise, so we consider it to not be an edge. If a weak
edge does neighbor a strong edge, then consider it a strong
edge as well.
