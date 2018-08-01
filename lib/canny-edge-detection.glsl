#pragma glslify: getSuppressedTextureIntensityGradient = require('./suppressed-intensity-gradient.glsl');
#pragma glslify: applyDoubleThreshold = require('./double-threshold.glsl');

float applyHysteresis(
  sampler2D textureSampler,
  vec2 textureCoord,
  vec2 resolution,
  float weakThreshold,
  float strongThreshold
) {
  float dx = 1. / resolution.x;
  float dy = 1. / resolution.y;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      vec2 ds = vec2(
        -dx + (float(i) * dx),
        -dy + (float(j) * dy));
      vec2 gradient = getSuppressedTextureIntensityGradient(
        textureSampler, clamp(textureCoord + ds, vec2(0.), vec2(1.)), resolution);
      float edge = applyDoubleThreshold(gradient, weakThreshold, strongThreshold);
      if (edge == 1.) return 1.;
    }
  }
  return 0.;
}

float cannyEdgeDetection(
  sampler2D textureSampler,
  vec2 textureCoord,
  vec2 resolution,
  float weakThreshold,
  float strongThreshold
) {
  vec2 gradient = getSuppressedTextureIntensityGradient(textureSampler, textureCoord, resolution);
  float edge = applyDoubleThreshold(gradient, weakThreshold, strongThreshold);
  if (edge == .5) {
    edge = applyHysteresis(
      textureSampler, textureCoord, resolution, weakThreshold, strongThreshold);
  }
  return edge;
}

#pragma glslify: export(cannyEdgeDetection);
