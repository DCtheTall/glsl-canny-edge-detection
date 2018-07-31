#pragma glslify: getTextureIntensityGradient = require('./get-texture-intensity-gradient.glsl');
#pragma glslify: round2DVectorAngle = require('./round-2d-vector-angle.glsl');

/**
 * Get the texture intensity gradient of an image
 * where the angle of the direction is rounded to
 * one of the 8 cardinal directions and gradients
 * that are not local extrema are zeroed out
 */
vec2 getSuppressedTextureIntensityGradient(
  sampler2D textureSampler,
  vec2 textureCoord,
  vec2 resolution
) {
  vec2 gradient = getTextureIntensityGradient(textureSampler, textureCoord, resolution);
  gradient = round2DVectorAngle(gradient);
  vec2 gradientStep = normalize(gradient) / resolution;
  float gradientLength = length(gradient);
  vec2 gradientPlusStep = getTextureIntensityGradient(
    textureSampler, textureCoord + gradientStep, resolution);
  if (length(gradientPlusStep) >= gradientLength) return vec2(0.);
  vec2 gradientMinusStep = getTextureIntensityGradient(
    textureSampler, textureCoord - gradientStep, resolution);
  if (length(gradientMinusStep) >= gradientLength) return vec2(0.);
  return gradient;
}

#pragma glslify: export(getSuppressedTextureIntensityGradient);
