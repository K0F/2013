uniform vec2 resolution;
uniform float time;

uniform float x;
uniform float y;

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
   
    float a = time*40.0;
    
    gl_FragColor=vec4(vec3(sin(x*10.0),cos(y*10.0),a),1.0);
}
