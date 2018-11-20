
#version 100

precision mediump float;

uniform sampler2D Texture;

varying vec2 TextureCoordOut;

void main(void) {
    vec4 mask = texture2D(Texture, TextureCoordOut);
  //  gl_FragColor = vec4(0.9, 0.5, 0.25, 1.0);
   gl_FragColor = vec4(mask.rgb, 1.0);
}
