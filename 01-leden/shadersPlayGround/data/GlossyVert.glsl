// Copyright (C) 2007 Dave Griffiths
// Licence: GPLv2 (see COPYING)
// Fluxus Shader Library
// ---------------------
// Glossy Specular Reflection Shader
// A more controllable version of blinn shading,
// Useful for ceramic or fluids - from Advanced 
// Renderman, thanks to Larry Gritz



attribute vec2 inTexcoord;

uniform mat4 modelviewMatrix;
uniform mat4 projmodelviewMatrix;
uniform mat3 normalMatrix;

uniform vec4 lightPosition[8];

attribute vec4 inVertex;
attribute vec3 inNormal;

varying vec3 N;
varying vec3 P;
varying vec3 V;
varying vec3 L;

varying vec2  TexCoord;

void main() {    
  N = normalize(normalMatrix * inNormal); 
  P = inVertex.xyz;
  V = -vec3(modelviewMatrix * inVertex);
  L = vec3(modelviewMatrix * (lightPosition[0] - inVertex));


  TexCoord = inTexcoord;//gl_TextureMatrix[0] * gl_MultiTexCoord0;


  // gl_Position = ftransform();
  gl_Position = projmodelviewMatrix * inVertex;

}

