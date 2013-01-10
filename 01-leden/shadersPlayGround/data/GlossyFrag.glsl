// Copyright (C) 2007 Dave Griffiths
// Copyright (C) 2007 Dave Griffiths
// Licence: GPLv2 (see COPYING)
// Fluxus Shader Library
// ---------------------
// Glossy Specular Reflection Shader
// A more controllable version of blinn shading,
// Useful for ceramic or fluids - from Advanced 
// Renderman, thanks to Larry Gritz

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D diffuseTexture;
uniform sampler2D normalTexture;
uniform vec2 inTexcoord;

uniform vec3 AmbientColour;
uniform vec3 DiffuseColour;
uniform vec3 SpecularColour;
uniform float AmbientIntensity;
uniform float DiffuseIntensity;
uniform float SpecularIntensity;
uniform float Roughness;
uniform float Sharpness;

varying vec3 N;
varying vec3 P;
varying vec3 V;
varying vec3 L;

varying vec2  TexCoord;

void main()
{ 
  float w = 0.18*(1.0-Sharpness);

  vec3 l = normalize(L);
  vec3 n = normalize(N);
  vec3 v = normalize(V);
  vec3 h = normalize(l+v);

  vec3 diff = texture2D(diffuseTexture,TexCoord).rgb;
  vec3 normal = texture2D(normalTexture,TexCoord).rgb;

  float diffuse = dot(l,n);
  float specular = smoothstep(0.72-w,0.72+w,pow(max(0.0,dot(n,h)),1.0/Roughness));
  gl_FragColor = vec4(
  diff*diffuse*DiffuseColour*DiffuseIntensity + 
  AmbientColour*AmbientIntensity +
  SpecularColour*specular*SpecularIntensity
  ,1);
}
