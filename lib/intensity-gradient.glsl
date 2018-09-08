#pragma glslify: blur = require('glsl-fast-gaussian-blur/5');

const mat3 X_COMPONENT_MATRIX = mat3(
  1., 0., -1.,
  2., 0., -2.,
  1., 0., -1.
);
const mat3 Y_COMPONENT_MATRIX = mat3(
  1., 2., 1.,
  0., 0., 0.,
  -1., -2., -1.
);

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
  vec2 gradientStep = vec2(1.) / resolution;

  mat3 imgMat = mat3(0.);

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      vec2 ds = vec2(
        -gradientStep.x + (float(i) * gradientStep.x),
        -gradientStep.y + (float(j) * gradientStep.y));
      imgMat[i][j] = getTextureIntensity(
        textureSampler, clamp(textureCoord + ds, vec2(0.), vec2(1.)), resolution);
    }
  }

  float gradX = convoluteMatrices(X_COMPONENT_MATRIX, imgMat);
  float gradY = convoluteMatrices(Y_COMPONENT_MATRIX, imgMat);

  return vec2(gradX, gradY);
}

#pragma glslify: export(getTextureIntensityGradient);
