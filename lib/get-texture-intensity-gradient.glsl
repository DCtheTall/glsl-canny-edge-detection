#pragma glslify: blur = require('glsl-fast-gaussian-blur/5');

const mat3 X_COMPONENT_MATRIX = mat3(1., 0., -1., 2., 0., -2., 1., 0., -1.);
const mat3 Y_COMPONENT_MATRIX = mat3(1., 2., 1., 0., 0., 0., -1., -2., -1.);

/**
 * 3x3 Matrix convolution
 */
float convoluteMatrices(mat3 A, mat3 B) {
  return dot(A[0], B[0]) + dot(A[1], B[1]) + dot(A[2], B[2]);
}

/**
 * Get the color of a texture after
 * a Guassian blur with a radius of 5 pixels
 */
vec3 getBlurredTextureColor(
  sampler2D textureSampler,
  vec2 textureCoord,
  vec2 resolution
) {
  return blur(
    textureSampler,
    textureCoord,
    resolution,
    normalize(textureCoord - vec2(0.5))).xyz;
}

/**
 * Get the intensity of the color on a
 * texture after a guassian blur is applied
 */
float getTextureIntensity(
  sampler2D textureSampler,
  vec2 textureCoord,
  vec2 resolution
) {
  vec3 color = getBlurredTextureColor(textureSampler, textureCoord, resolution);
  return pow(length(clamp(color, vec3(0.), vec3(1.))), 2.) / 3.;
}

/**
 * Get the gradient of the textures intensity
 * as a function of the texture coordinate
 */
vec2 getTextureIntensityGradient(
  sampler2D textureSampler,
  vec2 textureCoord,
  vec2 resolution
) {
  vec2 x0, x1, y0, y1;
  vec2 gradientStep = vec2(1.) / resolution;

  if (textureCoord.x > gradientStep.x) x0 = vec2(-gradientStep.x, 0.);
  else x0 = vec2(0.);
  if (1. - textureCoord.x > gradientStep.x) x1 = vec2(gradientStep.x, 0.);
  else x1 = vec2(0.);
  if (textureCoord.y > gradientStep.y) y0 = vec2(0., -gradientStep.y);
  else y0 = vec2(0.);
  if (1. - textureCoord.y > gradientStep.y) y1 = vec2(0., gradientStep.y);
  else y1 = vec2(0.);

  mat3 imgMat = mat3(
    getTextureIntensity(textureSampler, textureCoord + x0 + y0, resolution),
    getTextureIntensity(textureSampler, textureCoord + y0, resolution),
    getTextureIntensity(textureSampler, textureCoord + x1 + y0, resolution),
    getTextureIntensity(textureSampler, textureCoord + x0, resolution),
    getTextureIntensity(textureSampler, textureCoord, resolution),
    getTextureIntensity(textureSampler, textureCoord + x1, resolution),
    getTextureIntensity(textureSampler, textureCoord + x0 + y1, resolution),
    getTextureIntensity(textureSampler, textureCoord + y1, resolution),
    getTextureIntensity(textureSampler, textureCoord + x1 + y1, resolution));

  float gradX = convoluteMatrices(X_COMPONENT_MATRIX, imgMat);
  float gradY = convoluteMatrices(Y_COMPONENT_MATRIX, imgMat);

  return vec2(gradX, gradY);
}

#pragma glslify: export(getTextureIntensityGradient);
