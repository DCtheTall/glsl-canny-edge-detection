precision mediump float;

#pragma glslify: gradient = require('../lib/intensity-gradient.glsl');
#pragma glslify: cannyEdgeDetection = require('../lib/canny-edge-detection');

uniform sampler2D sampl;

void main() {
  vec2 grad = gradient(sampl, vec2(0.), vec2(512., 512.));
  float edge = cannyEdgeDetection(
    sampl, vec2(0.), vec2(512., 512.), .15, .3);
}
