/**
 * Rotate a 2D vector an angle (in degrees)
 */
vec2 rotate2D(vec2 v, float rad) {
  float s = sin(rad);
  float c = cos(rad);
  return mat2(c, s, -s, c) * v;
}

#pragma glslify: export(rotate2D);
