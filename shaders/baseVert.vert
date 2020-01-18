#version 450
layout (location = 0) in vec3 position;
uniform vec3 uPos; // xyz:Offset, z:ObjectScale

void main()
{
    gl_Position = vec4(position.xyz + uPos.xyz, 1.0);//vec4(uPos.xyz, 1.0);
}