uniform float pointSize;
uniform float gui;
varying vec4 vFragColor;


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


void main(void) {
    gl_Position = projmodelviewMatrix * inVertex;
    vec4 modv = vec4( modelviewMatrix * inVertex );
    if(gui == 0.0) {
        gl_PointSize = 200.0 * pointSize/ -modv.z ;
    } else {
        gl_PointSize = pointSize;
    }
    float fog = 8000.0/ -modv.z;
    if (fog < 8.0 && gui == 0.0) {
         vFragColor = smoothstep(0.0, 8.0, fog) * gl_Color;
    } else {
        vFragColor = gl_Color;
    }
    gl_FrontColor = gl_Color;
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
}
