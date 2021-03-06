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
varying vec3 light_pos;
varying vec2  TexCoord;

uniform float time;


void main() {
  //float noise = cnoise(vec3(inVertex.x/100.0,inVertex.y/100.0,time));
  
  light_pos = lightPosition[0];
  N = normalize(normalMatrix * inNormal); 
  P = inVertex.xyz;
  V = -vec3(modelviewMatrix * inVertex);
  L = vec3(modelviewMatrix * (lightPosition[0] - inVertex));

	

  TexCoord = inTexcoord;

  gl_Position = projmodelviewMatrix * inVertex;
}

