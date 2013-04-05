uniform float time;

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(){

  float rnd = rand(gl_FragCoord.xy*time);
  gl_FragColor=vec4(vec3(rnd,rnd,rnd),1.0);
}


