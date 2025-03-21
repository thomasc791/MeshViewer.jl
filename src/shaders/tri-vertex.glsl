#version 460 core

layout(location = 0) in vec3 position;

uniform mat4 view;
uniform mat4 projection;
uniform vec4 translation;

void main() {
    gl_Position = projection * view * (translation + vec4(position, 1.0));
}
