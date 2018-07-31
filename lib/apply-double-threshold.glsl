/**
 * Apply a double threshold to each edge to classify each edge
 * as a weak edge or a strong edge
 */
float applyDoubleThreshold(
  vec2 gradient,
  float weakThreshold,
  float strongThreshold
) {
  float gradientLength = length(gradient);
  if (gradientLength < weakThreshold) return 0.;
  if (gradientLength < strongThreshold) return .5;
  return 1.;
}

#pragma glslify: export(applyDoubleThreshold);
