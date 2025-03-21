#version 460 core

layout(location = 3) in vec3 position;

out vec2 fragCoord;

uniform mat4 view;
uniform mat4 projection;
uniform vec4 translation;

void main() {
    gl_Position = projection * view * (translation + vec4(position, 1.0));
}
