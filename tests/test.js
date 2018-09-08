const glslify = require('glslify');
const assert = require('assert');
const fs = require('fs');
const GL = require('headless-gl');

const SHADER = fs.readFileSync(`${__dirname}/test.glsl`).toString();
const gl = GL(512, 512);

describe('glsl-canny-edge-detection Test', () => {
  let parsedShader;

  it('glslify should be able to parse the shader with glslify', () => {
    let err;
    try {
      parsedShader = glslify`${SHADER}`;
    } catch (e) {
      if (e) console.log(e);
      err = e;
    }
    assert(err === undefined);
  });

  it('headless-gl should be able to compile the shader', () => {
    let err;
    try {
      const shader = gl.createShader(gl.FRAGMENT_SHADER);
      gl.shaderSource(shader, parsedShader);
      gl.compileShader(shader);
      if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
        throw new Error(`Shader failed to compile: ${gl.getShaderInfoLog(shader)}`);
      }
    } catch (e) {
      if (e) console.log(e);
      err = e;
    }
    assert(err === undefined);
  });
});
