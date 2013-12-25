
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float weight;
uniform float time;

varying vec2 center;
varying vec2 normal;
varying vec4 vertColor;

void main() {
  vec2 v = gl_FragCoord.xy - center;
  float alpha = 0.25 - abs(2.0 * dot(normalize(normal), v) / weight);  
  gl_FragColor = vec4(vertColor.r,vertColor.g,vertColor.b, alpha);
}
