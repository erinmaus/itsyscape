uniform float scape_KernelRadius;
uniform vec2 scape_TexelSize;

#include "Resources/Shaders/Dilate.common.glsl"

vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
{
	return dilateMax(scape_KernelRadius, image, textureCoordinate, scape_TexelSize, vec4(0.0));
}
