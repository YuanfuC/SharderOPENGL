
#version 100

attribute vec4 v_Position;
attribute vec2 TextureCoords;
varying vec2 TextureCoordOut;

void main() {
    gl_Position = v_Position;
    TextureCoordOut = TextureCoords;
}
